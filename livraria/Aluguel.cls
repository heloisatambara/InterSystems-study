Class estagio.livraria.Aluguel Extends %Persistent
{

// To do:

// // Comentar código

// // Mostrar Livros alugados

// // DELETE

Relationship Livro As estagio.livraria.Livro [ Cardinality = one, Inverse = Aluguel ];

Property DataDeEmp As %Date(FORMAT = 4);

Property DataDeDev As %Date(FORMAT = 4);

Property Fidelidade As %Boolean;

Property Valor As %Decimal(SCALE = 2) [ Calculated, SqlComputeCode = { Set {Valor} = $CASE({Fidelidade}, 0:5, 1:2) }, SqlComputed ];

Trigger Emprestimo [ Event = INSERT, Time = AFTER ]
{
	Try
	{
		Set tLivro = {Livro}	
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Livro SET Status = 'A' WHERE ID = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tLivro)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write !, "Erro de TRIGGER"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!,"A", tRset.%Message
		Write !!,"B", $SYSTEM.Status.DisplayError(tSC)
		Write !!,"C", $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
}

Trigger Devolucao [ Event = UPDATE, Time = AFTER ]
{
	If ({DataDeDev}'="")
	{
		Set tValor = ({DataDeDev}-{DataDeEmp})*{Valor}
		Set:(tValor<10) tValor = 10
		Set tID = {ID}
		Set tData = {DataDeDev}
		
		Write !!, ">>> Valor: R$"_$FNUMBER(tValor,, 2)
		
		Try
		{
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Lucro (Aluguel, Valor, Data) VALUES (?,?,?)")
			
			Throw:$$$ISERR(tSC)
			
			Set tRset = tSt.%Execute(tID, tValor, tData)
			
			Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write !, "Erro de TRIGGER - Registrar Lucro"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!,"A", tRset.%Message
		Write !!,"B", $SYSTEM.Status.DisplayError(tSC)
		Write !!,"C", $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Try
	{
		Set tLivro = {Livro}	
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Livro SET Status = 'D' WHERE ID = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tLivro)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write !, "Erro de TRIGGER - Registrar Devolução"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!,"A", tRset.%Message
		Write !!,"B", $SYSTEM.Status.DisplayError(tSC)
		Write !!,"C", $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	
	}
}

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
			Set tSC = tSt.%Prepare("SELECT ID, Titulo, Status, Autor FROM estagio_livraria.Livro WHERE Titulo LIKE ?")
		
			Throw:$$$ISERR(tSC)
			
			Set tRset = tSt.%Execute("%"_tTitulo_"%")
			
			While tRset.%Next()
			{
				/* Achar rowcount */
			}
			
			Write:(tRset.%Get("Status")="A") !, """"_tRset.%Get("Titulo")_""" já está alugado."
		}
		While ((tRset.%ROWCOUNT '=1)||(tRset.%Get("Status")="A"))
		
		Set tLivro = tRset.%CurrentResult
		
		Write !!,  ">>> Alugar """_tLivro.Titulo_""" de "_tLivro.Autor
	
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Aluguel SET DataDeEmp = ?, Livro = ?, Fidelidade = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(+$HOROLOG, tLivro.ID, tFidelidade)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write:(tRset.%SQLCODE<0) !!, "A", tRset.%Message
		Write:$$$ISERR(tSC) !!, "B", $SYSTEM.Status.DisplayError(tSC)
		Write !!, "C",  $SYSTEM.Status.DisplayError(EXC.AsStatus())	
	}
		
	Quit tSC
}

ClassMethod Devolver() As %Status
{
	Set tSC = $$$OK
	
	Try
	{		
		Do
		{
			Read !, ">>> Devolver livro: ", tTitulo
		
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("SELECT ID, Status, Titulo FROM estagio_livraria.Livro WHERE Titulo LIKE ?")
		
			Throw:$$$ISERR(tSC)
			
			Set tRset = tSt.%Execute("%"_tTitulo_"%")
			
			While tRset.%Next()
			{
				/* Achar rowcount */
			}
			
			Write:(tRset.%Get("Status")="D") !, """"_tRset.%Get("Titulo")_""" não está alugado."
		}
		While ((tRset.%ROWCOUNT '=1)||(tRset.%Get("Status")="D"))
		
		Write !!,  ">>> Devolver """_tRset.%Get("Titulo")_""""	
	
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Aluguel SET DataDeDev = ? WHERE Livro = ? AND DataDeDev IS NULL")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(+$HOROLOG, tRset.%Get("ID"))
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		Write:(tRset.%SQLCODE<0) !!, tRset.%Message
		Write:$$$ISERR(tSC) !!, $SYSTEM.Status.DisplayError(tSC)
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
