Class estagio.livraria.Lucro Extends %Persistent
{

Property Aluguel As estagio.livraria.Aluguel;

Property Valor As %Decimal(SCALE = 2) [ Required ];

Property Data As %Date [ Required ];

/// Exibe todos os registros de lucros
ClassMethod Exibir()
{
	Set tSC = $$$OK
	
	Try
	{
		/* QUERY - exibe tudo */
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("SELECT Data, Valor, Aluguel FROM estagio_livraria.Lucro")
		
		Throw:$$$ISERR(tSC) // se der erro ao preparar
		
		Set tRset = tSt.%Execute()
		
		
		/* DISPLAY */
		// cabeçalho
		Write !, "ID do Aluguel", ?17, "Data do Pagamento",  ?40, "Valor"
		
		While tRset.%Next()
		{
			// resultados da query
			Write !, $JUSTIFY("#"_tRset.%Get("Aluguel"),13), ?21, $ZDATE(tRset.%Get("Data"),4) , ?35, $JUSTIFY("R$"_$FNUMBER(tRset.%Get("Valor"),,2),10)
		}
		
		Read !,tEnter // espera interação do usuário para seguir
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro de exibição"
		Write:$$$ISERR(tSC) !, "Erro no %Prepare", $SYSTEM.Status.DisplayError(tSC)
		Write !, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}

	Quit
}

Storage Default
{
<Data name="LucroDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Aluguel</Value>
</Value>
<Value name="3">
<Value>Valor</Value>
</Value>
<Value name="4">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^estagio.livraria.LucroD</DataLocation>
<DefaultData>LucroDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^estagio.livraria.LucroD</IdLocation>
<IndexLocation>^estagio.livraria.LucroI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Aluguel">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Data">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Valor">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.livraria.LucroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
