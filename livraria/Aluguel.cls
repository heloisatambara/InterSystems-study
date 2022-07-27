Class estagio.livraria.Aluguel Extends %Persistent
{

Property DataDeEmp As %Date(FORMAT = 4);

Property DataDeDev As %Date(FORMAT = 4);

Property Livro As estagio.livraria.Livro;

Property Fidelidade As %Boolean;

Property Valor As %Decimal(SCALE = 2) [ Calculated, SqlComputeCode = { Set {Valor} = $CASE({Fidelidade}, 0:5, 1:2) }, SqlComputed ];

ClassMethod Alugar() As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		Read !, ">>> Fidelidade: ", tFidelidade
		
		Do
		{
			Read !, ">>> Titulo do Livro: ", tTitulo
		
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("SELECT * FROM estagio_livraria.Livro WHERE Titulo LIKE ?")
		
			Throw:$$$ISERR(tSC)
			
			Set tRset = tSt.%Execute("%"_tTitulo_"%")
			
			While tRset.%Next()
			{
				/* Achar rowcount */
			}
		}
		While (tRset.%ROWCOUNT '=1)
		
		Set tLivro = tRset.%CurrentResult
		
		Write !!,  ">>> Alugar """_tLivro.Titulo_""""
		
	
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Aluguel SET DataDeEmp = ?, Livro = ?, Fidelidade = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(+$HOROLOG, tLivro, tFidelidade)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write:(tRset.%SQLCODE<0) !!, tRset.%Message
		Write !!, $SYSTEM.Status.DisplayError(tSC)
		Write !!, $SYSTEM.Status.DisplayError(EXC.AsStatus())	
	}
	
	
		
	Quit tSC
}

Storage Default
{
<Data name="AluguelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataDeEmp</Value>
</Value>
<Value name="3">
<Value>DataDeDev</Value>
</Value>
<Value name="4">
<Value>Livro</Value>
</Value>
<Value name="5">
<Value>Fidelidade</Value>
</Value>
</Data>
<DataLocation>^estagio.livraria.AluguelD</DataLocation>
<DefaultData>AluguelDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^estagio.livraria.AluguelD</IdLocation>
<IndexLocation>^estagio.livraria.AluguelI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="DataDeDev">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DataDeEmp">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Fidelidade">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Livro">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.livraria.AluguelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
