Class estagio.livraria.Livro Extends %Persistent
{

// TO DO

// // Comentar codigo

Relationship Aluguel As estagio.livraria.Aluguel [ Cardinality = many, Inverse = Livro ];

Property Titulo As %String(MAXLEN = 100) [ Required ];

Property Autor As %String;

Property Editora As %String;

Property Status As %String(DISPLAYLIST = ",Disponível, Alugado", VALUELIST = ",D,A");

Trigger Cadastro [ Event = INSERT, Time = AFTER ]
{
	Try
	{
		Set tID = {ID}
		
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Livro SET Status = 'D' WHERE ID = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tID)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write !, "Erro de TRIGGER"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!, tRset.%Message
		Write !!, $SYSTEM.Status.DisplayError(tSC)
		Write !!, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
}

ClassMethod Cadastrar() As %Status
{
	Set tSC = $$$OK
	
	Read !, ">>> Título: ", tTitulo
	Read !, ">>> Autor: ", tAutor
	Read !, ">>> Editora: ", tEditora	
	
	Try
	{
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Livro SET Titulo = ?, Autor = ?, Editora = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tTitulo, tAutor, tEditora)	
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{	
		Set tSC = EXC.AsStatus()
		
		Write !, "Erro no Cadastro"
		Write !, $SYSTEM.Status.DisplayError(tSC)
	}
	
	Quit tSC
}

ClassMethod Exibir(pAlugado As %String)
{
	Set tSC = $$$OK
	
	Try
	{
		Set tQuery = "SELECT ID, Titulo, Autor, Editora, Status FROM estagio_livraria.Livro WHERE Titulo LIKE ? AND Autor LIKE ? AND Editora LIKE ?"
		
		Read !, ">>> Por Título: ", tTitulo
		Read !, ">>> Por Autor@: ", tAutor
		Read !, ">>> Por Editora: ", tEditora, !
		
		Set tAutor = "%"_tAutor_"%", tEditora = "%"_tEditora_"%", tTitulo = "%"_tTitulo_"%"
		Set:($DATA(pAlugado)) tQuery = tQuery_" AND Status = '"_pAlugado_"'"
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare(tQuery)
		
		Throw:$$$ISERR(tSC)

		Set tRset = tSt.%Execute(tTitulo, tAutor, tEditora)

		
		Write !, "     Título", ?29, "Autor", ?50, "Editora", ?65, "Status"
		
		While (tRset.%Next())
		{
			Set tTitulo = tRset.%Get("Titulo")
			Set:($LENGTH(tTitulo)>20) tTitulo = $EXTRACT(tTitulo,1, 17)_"..."
			Set tEditora = tRset.%Get("Editora")
			Set:($LENGTH(tEditora)>14) tEditora = $EXTRACT(tEditora, 1, 11)_"..."
	
			Write !, "#"_tRset.%Get("ID"), ?5, tTitulo, ?29, tRset.%Get("Autor"), ?50, tEditora, ?65, tRset.%Get("Status")
		} 
		
		Read !,tEnter
		
	}
	Catch EXC
	{
		Write !, "Erro de exibição"
		Write:$$$ISERR(tSC) !, $SYSTEM.Status.DisplayError(tSC)
		Write !, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit
}

ClassMethod Apagar() As %Status
{
	Set tSC = $$$OK
	
	Try
	{		
		Do
		{
			Read !, ">>> Apagar livro: ", tTitulo
		
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("SELECT ID, Status, Titulo FROM estagio_livraria.Livro WHERE Titulo LIKE ?")
		
			Throw:$$$ISERR(tSC)
			
			Set tRset = tSt.%Execute("%"_tTitulo_"%")
			
			While tRset.%Next()
			{
				/* Achar rowcount */
			}
			
			Write:(tRset.%Get("Status")="A") !, """"_tRset.%Get("Titulo")_""" não pode ser apagado, pois está alugado."
		}
		While ((tRset.%ROWCOUNT '=1)||(tRset.%Get("Status")="A"))
		
		Write !, " >>> Deletar "_tRset.%Get("Titulo")_"? "
		
		Read tResposta
		
		Set tSt = ##class(%SQL.Statement).%New()
		Set:("SIMSimsim"[tResposta) tSC = tSt.%Prepare("DELETE FROM estagio_livraria.Livro WHERE ID = "_tRset.%Get("ID"))
		
		Write !, $SELECT("SIMSimsim"[tResposta:">>> Dados apagados", "SIMSimsim"'[tResposta:">>> Dados mantidos")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute()
		
		Throw:(tRset.%SQLCODE<0)
		
	}
	Catch EXC
	{
		Write !, "Erro ao apagar dados"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!, tRset.%Message
		Write:$$$ISERR(tSC) !!, $SYSTEM.Status.DisplayError(tSC)
		
		Set tSC = EXC.AsStatus()

		Write !!, $SYSTEM.Status.DisplayError(tSC)	
	}
	
	Quit tSC
}

Storage Default
{
<Data name="LivroDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Titulo</Value>
</Value>
<Value name="3">
<Value>Autor</Value>
</Value>
<Value name="4">
<Value>Editora</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^estagio.livraria.LivroD</DataLocation>
<DefaultData>LivroDefaultData</DefaultData>
<ExtentSize>4</ExtentSize>
<IdLocation>^estagio.livraria.LivroD</IdLocation>
<IndexLocation>^estagio.livraria.LivroI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Autor">
<AverageFieldSize>15.25</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="Editora">
<AverageFieldSize>8</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="Status">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Titulo">
<AverageFieldSize>24.75</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.livraria.LivroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
