Class estagio.livraria.Livro Extends %Persistent
{

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
