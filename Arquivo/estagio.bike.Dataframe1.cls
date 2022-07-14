Class estagio.bike.Dataframe1 Extends %Persistent
{

Parameter DIRECTORY As %String = "E:\trabalho\innovatium\0Estudos\";

Property RideId As %String [ Required, SqlColumnNumber = 2 ];

Index RideID On RideId [ IdKey ];

Property RideableType As %String [ Required, SqlColumnNumber = 3 ];

Property StartedAt As %TimeStamp [ Required, SqlColumnNumber = 4 ];

Property EndedAt As %TimeStamp [ Required, SqlColumnNumber = 5 ];

Property StartStationName As %String [ Required, SqlColumnNumber = 6 ];

Property StartStationID As %Decimal(SCALE = 2) [ Required, SqlColumnNumber = 7 ];

Property EndStationName As %String [ Required, SqlColumnNumber = 8 ];

Property EndStationID As %Decimal(SCALE = 2) [ Required, SqlColumnNumber = 9 ];

Property StartLatitude As %Decimal(SCALE = 7) [ Required, SqlColumnNumber = 10 ];

Property StartLongitude As %Decimal(SCALE = 7) [ Required, SqlColumnNumber = 11 ];

Property EndLatitude As %Decimal(SCALE = 7) [ Required, SqlColumnNumber = 12 ];

Property EndLongitude As %Decimal(SCALE = 7) [ Required, SqlColumnNumber = 13 ];

Property MemberCasual As %String [ Required, SqlColumnNumber = 14 ];

ClassMethod LerArquivo() As %Status
{
	Set tSC = $SYSTEM.Status.OK()
	
	Try
	{
		Set tArquivo = ##class(estagio.exemplos.Arquivo).LerArquivo("teste.csv", ..#DIRECTORY, 1)
		Set tSC = ##class(estagio.exemplos.Arquivo).RetornarElementos(.tResult)
		
		Throw:$$$ISERR(tSC)
		
		While (tResult.%Next())
		{
			Set tLine = tResult.%Get("Informacoes")
			Set tLine = $LISTTOSTRING(tLine, ";")
			Set tSC = $SYSTEM.Status.OK()
			
			Try
			{
				Set tSC = ##class(estagio.bike.Dataframe1).%New(tLine)
				
				Throw:$$$ISERR(tSC)
			}
			Catch Err
			{
				Set tSC = Err.AsStatus()
				Write !, "Erro na persistencia", $SYSTEM.Status.DisplayError(tSC)
			}
			
		}
	}
	Catch Err
	{
		Set tSC = Err.AsStatus()
		Write !, "Erro na leitura:", $SYSTEM.Status.DisplayError(tSC)
	}
	
	Quit tSC
}

Method %OnNew(pLine As %String) As %Status
{
	Set tSC = $SYSTEM.Status.OK()
			
	Try
	{	
		Set tViagem = $THIS
		Set tSC = ..PersistirArquivo(pLine, .tViagem, 1)
		
		Throw:$$$ISERR(tSC)
	}
	Catch Err
	{
		Set tSC = Err.AsStatus()
		Write !, "Erro na leitura:", $SYSTEM.Status.DisplayError(tSC)
	}
	Quit tSC
}

Method PersistirArquivo(pLine As %String, ByRef pViagem As estagio.bike.Dataframe, pNovo As %Boolean = 1) As %Status
{
	Set:pNovo ..RideId = $PIECE(pLine, ";", 1)
	Set ..RideableType = $PIECE(pLine, ";", 2)
	Set ..StartedAt = $PIECE(pLine, ";", 3)
	Set ..EndedAt = $PIECE(pLine, ";", 4)
	Set ..StartStationName = $PIECE(pLine, ";", 5)
	Set ..StartStationID = $PIECE(pLine, ";", 6)
	Set ..EndStationName = $PIECE(pLine, ";", 7)
	Set ..EndStationID = $PIECE(pLine, ";", 8)
	Set ..StartLatitude = $PIECE(pLine, ";", 9)
	Set ..StartLongitude = $PIECE(pLine, ";", 10)
	Set ..EndLatitude = $PIECE(pLine, ";", 11)
	Set ..EndLongitude = $PIECE(pLine, ";", 12)
	Set ..MemberCasual = $PIECE(pLine, ";", 13)
	Set tSC = $SYSTEM.Status.OK()
	
	Try
	{
		Set tSC = ..%Save()
		
		If ($$$GETERRORCODE(tSC)=5805) // se o ID já existe
		{
			Write !, "ID já existente, atualizando informações"
			
			Set pViagem = ##class(estagio.bike.Dataframe1).%OpenId($PIECE(pLine, ";", 1))
			Set tSC = pViagem.PersistirArquivo(pLine,.pViagem, 0)
		}
		
		Throw:$$$ISERR(tSC)
		
		Set pViagem = $THIS
		
	}
	Catch Err
	{
		Write !, "Erro para salvar informações:", $SYSTEM.Status.DisplayError(tSC)
		Set tSC = Err.AsStatus()
		
		
	}
	
	Quit tSC
}

Method %OnAfterSave() As %Status [ Private ]
{
	Set tStationA = ##class(estagio.bike.Estacao1).%New()
	Set tStationA.Station = ..StartStationID
	Set tStationA.Nome = ..StartStationName
	
	Do tStationA.Localizacao.Insert(..StartLatitude)
	Do tStationA.Localizacao.Insert(..StartLongitude)
	
	Set tStationB = ##class(estagio.bike.Estacao1).%New()
	Set tStationB.Station = ..EndStationID
	Set tStationB.Nome = ..EndStationName
	
	Do tStationB.Localizacao.Insert(..EndLatitude)
	Do tStationB.Localizacao.Insert(..EndLongitude)
	
	Set tSC = $SYSTEM.Status.OK()
	
	Try
	{
		Set tSCa = tStationA.%Save()
		
		Set tSCb = tStationB.%Save()
		
	}
	Catch Err
	{
		If (($$$GETERRORCODE(tSCa)=5805)||($$$GETERRORCODE(tSCa)=5805)) // se o ID já existe
		{
			Write:($$$GETERRORCODE(tSCa)=5805) !, "Estação A já cadastrada"
			Write:($$$GETERRORCODE(tSCb)=5805) !, "Estação B já cadastrada"
		}
		Else
		{
			Set tSC = Err.AsStatus()
			
			Write !, "Erro para salvar estações:", $SYSTEM.Status.DisplayError(tSC)
		}
	}

	Quit tSC
}

Storage Default
{
<Data name="Dataframe1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RideableType</Value>
</Value>
<Value name="3">
<Value>StartedAt</Value>
</Value>
<Value name="4">
<Value>EndedAt</Value>
</Value>
<Value name="5">
<Value>StartStationName</Value>
</Value>
<Value name="6">
<Value>StartStationID</Value>
</Value>
<Value name="7">
<Value>EndStationName</Value>
</Value>
<Value name="8">
<Value>EndStationID</Value>
</Value>
<Value name="9">
<Value>StartLatitude</Value>
</Value>
<Value name="10">
<Value>StartLongitude</Value>
</Value>
<Value name="11">
<Value>EndLatitude</Value>
</Value>
<Value name="12">
<Value>EndLongitude</Value>
</Value>
<Value name="13">
<Value>MemberCasual</Value>
</Value>
</Data>
<DataLocation>^estagio.bike.Dataframe1D</DataLocation>
<DefaultData>Dataframe1DefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^estagio.bike.Dataframe1D</IdLocation>
<IndexLocation>^estagio.bike.Dataframe1I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>18</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="EndLatitude">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EndLongitude">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EndStationID">
<AverageFieldSize>6</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EndStationName">
<AverageFieldSize>17</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EndedAt">
<AverageFieldSize>21</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MemberCasual">
<AverageFieldSize>8</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RideId">
<AverageFieldSize>18</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="RideableType">
<AverageFieldSize>13</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="StartLatitude">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="StartLongitude">
<AverageFieldSize>6</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="StartStationID">
<AverageFieldSize>6</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="StartStationName">
<AverageFieldSize>20</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="StartedAt">
<AverageFieldSize>21</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="RideID">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.bike.Dataframe1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
