Class estagio.exemplos.Arquivo Extends %Persistent
{

Property Informacoes As %ListOfDataTypes [ Required ];

Parameter DIRECTORY As %String = "E:\trabalho\innovatium\0Estudos\";

ClassMethod LerArquivo(pArquivo As %String, pDiretorio As %String, pTitulo As %Boolean = 0) As %Status
{
	Do ##class(estagio.exemplos.Arquivo).%KillExtent()
	Read:('$DATA(pDiretorio)) !, "Diretório: ", pDiretorio
	Read:('$DATA(pArquivo)) !, "Ler qual arquivo? ", pArquivo
	
	Set tSC = $SYSTEM.Status.OK()
	
	Try
	{
		Set tFile = ##class(%File).%New(pDiretorio_pArquivo)
		//Set tFile = ##class(%File).%New(tDiretorio_tArquivo)
		Set tSC = tFile.Open("R")
		
		Throw:$$$ISERR(tSC)
		
		
		Set:pTitulo tLine = tFile.ReadLine(,.tSC) // primeira linha é titulo
		Set tLine = tFile.ReadLine(,.tSC)
		//Write !, "Erro na leitura:", $SYSTEM.Status.DisplayError(tSC)
	
		While (tLine'="")
		{
			Set tArquivo = ##class(estagio.exemplos.Arquivo).%New()
			Set tLine = $LISTFROMSTRING(tLine, ";")
			
			For i = 1:1:$LISTLENGTH(tLine)
			{
				Do tArquivo.Informacoes.Insert($LIST(tLine, i))
			}
			
			//Set tLineTerminator = tFile.ReadLineIntoStream(.tSC).LineTerminator
			Set tSC = tArquivo.%Save()
			Throw:$$$ISERR(tSC)
			
			Set tLine = tFile.ReadLine(,.tSC)
		}
	}
	Catch Err
	{
		Write !!, "Erro na leitura:", $SYSTEM.Status.DisplayError(tSC)
		Set tSC = Err.AsStatus()
		
	}
	
	Quit tSC
}

Query Linhas() As %SQLQuery [ SqlProc ]
{
	SELECT Informacoes FROM estagio_exemplos.Arquivo
}

ClassMethod RetornarElementos(ByRef pResultSet As %SQL.StatementResult) As %Status
{
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatus = tStatement.%PrepareClassQuery("estagio.exemplos.Arquivo", "Linhas")
		Set pResultSet = tStatement.%Execute()
		
		Quit tStatus
}

Storage Default
{
<Data name="ArquivoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Informacoes</Value>
</Value>
</Data>
<DataLocation>^estagio.exemplos.ArquivoD</DataLocation>
<DefaultData>ArquivoDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^estagio.exemplos.ArquivoD</IdLocation>
<IndexLocation>^estagio.exemplos.ArquivoI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Informacoes">
<AverageFieldSize>82</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.exemplos.ArquivoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
