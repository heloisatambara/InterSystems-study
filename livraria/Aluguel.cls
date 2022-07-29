Class estagio.livraria.Aluguel Extends %Persistent
{

// To do:

// // DELETE por data

Relationship Livro As estagio.livraria.Livro [ Cardinality = one, Inverse = Aluguel, OnDelete = cascade ];

Property DataDeEmp As %Date(FORMAT = 4);

Property DataDeDev As %Date(FORMAT = 4);

Property Fidelidade As %Boolean;

Property Cliente As estagio.livraria.Cadastro;

Property Valor As %Decimal(SCALE = 2) [ Calculated, SqlComputeCode = { Set {Valor} = $CASE({Fidelidade}, 0:5, 1:2) }, SqlComputed ];

/// Ao criar aluguel, altera status do livro de "Disponível" para "Alugado"
Trigger Emprestimo [ Event = INSERT, Time = AFTER ]
{
	Try
	{
		/* QUERY - altera status do livro alugado*/
		Set tLivro = {Livro} // pega ID do livro inserido no aluguel
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Livro SET Status = 'A' WHERE ID = ?")
		
		Throw:$$$ISERR(tSC)
		
		// UPDATE do status do livro inserido no aluguel
		Set tRset = tSt.%Execute(tLivro)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro de TRIGGER"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!,"A", tRset.%Message
		Write !!,"B", $SYSTEM.Status.DisplayError(tSC)
		Write !!,"C", $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
}

/// A devolução é registrada como um UPDATE na DataDeDev - se esse campo não for alterado o trigger não faz nada. Se for, cria registro de lucro e altera status do livro para disponível.
Trigger Devolucao [ Event = UPDATE, Time = AFTER ]
{
	If ({DataDeDev}'="") // checa se a mudança foi colocar a data de devolução
	{
		
		/* INPUT - pega valores do aluguel alterado */
		Set tValor = ({DataDeDev}-{DataDeEmp})*{Valor} // calcula valor 
		Set:(tValor<10) tValor = 10 // valor mínimo - 10
		Set tID = {ID} // ID do aluguel atualizado
		Set tData = {DataDeDev} // data de devolução
		Set tLivro = {Livro} // ID do livro devolvido
		
		
		/* DISPLAY - mostra valor calculado */
		Write !!, ">>> Valor: R$"_$FNUMBER(tValor,, 2)
		
		Hang 1
		
		
		/* LUCRO - cria registro de lucro*/
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
			/* tratamento de erros */
			Write !, "Erro de TRIGGER - Registrar Lucro"
			Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!,"A", tRset.%Message
			Write !!,"B", $SYSTEM.Status.DisplayError(tSC)
			Write !!,"C", $SYSTEM.Status.DisplayError(EXC.AsStatus())
		}
		
		
		/* LIVRO - atualiza status do livro para "Disponível" */
		Try
		{
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Livro SET Status = 'D' WHERE ID = ?")
			
			Throw:$$$ISERR(tSC)
			
			Set tRset = tSt.%Execute(tLivro)
			
			Throw:(tRset.%SQLCODE<0)
		}
		Catch EXC
		{
			/* tratamento de erros */
			Write !, "Erro de TRIGGER - Registrar Devolução"
			Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!,"A", tRset.%Message
			Write !!,"B", $SYSTEM.Status.DisplayError(tSC)
			Write !!,"C", $SYSTEM.Status.DisplayError(EXC.AsStatus())
		}
	}
}

/// Aluga livro para cliente passado por ID, calcula o valor a partir da fidelidade do mesmo.
ClassMethod Alugar(pCliente As %Integer, pFidelidade As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		/* INPUT - pede título do livro até que encontre um só que tenha a string inserida e esteja disponível */
		Do
		{
			Read !, ">>> Titulo do Livro: ", tTitulo
				
			Set tROWCOUNT = ..ProcuraTitulo(tTitulo, .tLivro) 

			Write:(tLivro.Status="A") !, """"_tLivro.Titulo_""" já está alugado."
		}
		While ((tROWCOUNT '=1)||(tLivro.Status="A"))
		
		/* QUERY - insere novo aluguel */
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Aluguel SET DataDeEmp = ?, Livro = ?, Fidelidade = ?, Cliente = ?")
		
		Throw:$$$ISERR(tSC)
		
		// Registra o aluguel com a data atual, ID do livro procurado e ID e fidelidade do cliente passados como argumentos
		Set tRset = tSt.%Execute(+$HOROLOG, tLivro.%Id, pFidelidade, pCliente)
		
		Throw:(tRset.%SQLCODE<0)
		
		/* DISPLAY - Mostra livro alugado se tudo deu certo */
		Write !!,  ">>> Alugado: """_tLivro.Titulo_""" de "_tLivro.Autor, !!
		
		Hang 1
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro ao registrar aluguel"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!, "A- ", tRset.%Message
		Write:$$$ISERR(tSC) !!, "B- ", $SYSTEM.Status.DisplayError(tSC)
		Write !!, "C- ",  $SYSTEM.Status.DisplayError(EXC.AsStatus())	
	}
		
	Quit tSC
}

/// Atualiza aluguel para registrar data de devolução
ClassMethod Devolver() As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		/* INPUT - pede título do livro até que encontre um só que tenha a string inserida e esteja alugado */
		Do
		{
			Read !, ">>> Devolver livro: ", tTitulo
		
			Set tROWCOUNT = ..ProcuraTitulo(tTitulo, .tLivro) 

			Write:(tLivro.Status="D") !, """"_tLivro.Titulo_""" não está alugado."
		}
		While ((tROWCOUNT '=1)||(tLivro.Status="D"))
		
		
		/* QUERY - atualiza o aluguel do livro que ainda não tenha data de devolução */
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Aluguel SET DataDeDev = ? WHERE Livro = ? AND DataDeDev IS NULL")
		
		Throw:$$$ISERR(tSC)
		
		// coloca a data atual como data de devolução
		Set tRset = tSt.%Execute(+$HOROLOG, tLivro.%Id)
		
		Throw:(tRset.%SQLCODE<0)
		
		
		/* DISPLAY - Mostra livro devolvido se tudo deu certo */
		Write !!,  ">>> Livro devolvido: """_tTitulo_""""
		
		Hang 1	
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro ao registrar a devolução"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!, tRset.%Message
		Write:$$$ISERR(tSC) !!, $SYSTEM.Status.DisplayError(tSC)
		Write !!, $SYSTEM.Status.DisplayError(EXC.AsStatus())	
	}
	
	Quit tSC
}

/// Exibe todos os aluguéis ou somente os do cliente passado como argumento
ClassMethod Exibir(pCliente As %Integer = 0)
{
	Set tSC = $$$OK
	
	Try
	{
		/* QUERY - mostra só os do cliente se foi passado como argumento (por ID) */
		Set tQuery = "SELECT ID, Livro->Titulo As Livro, DataDeEmp, DataDeDev, Valor, Cliente->Usuario As Cliente FROM estagio_livraria.Aluguel"
		Set:pCliente tQuery = tQuery_" WHERE Cliente = "_pCliente
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare(tQuery)
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute()
		
		/* DISPLAY */
		// cabeçalho
		Write !, "    Livro", ?16, "Data de Empréstimo", ?36, "Data de Devolução", ?56, "R$/Dia", ?64, "Cliente"
		
		While tRset.%Next()
		{
			// arruma tamanho das strings
			Set tLivro = tRset.%Get("Livro")
			Set:($LENGTH(tLivro)>12) tLivro = $EXTRACT(tLivro,1, 9)_"..."
			Set tDataDeDev = ""
			Set:(tRset.%Get("DataDeDev")'="") tDataDeDev = $ZDATE(tRset.%Get("DataDeDev"),4)
	
			Write !, "#"_tRset.%Get("ID"), ?4, tLivro, ?20, $ZDATE(tRset.%Get("DataDeEmp"),4), ?40, tDataDeDev, ?56, "R$"_$FNUMBER(tRset.%Get("Valor"),,2), ?64, tRset.%Get("Cliente")
		}
		
		Read !,tEnter // espera interação do usuário para seguir
		
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro de exibição"
		Write:$$$ISERR(tSC) !, $SYSTEM.Status.DisplayError(tSC)
		Write !, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
}

/// Procura título digitado e retorna %ROWCOUNT, Autor, Status (disponível ou alugado) e ID
ClassMethod ProcuraTitulo(pTitulo As %String, Output pLivro) As %Integer
{
	Try
	{
		/* QUERY - procura título inserido*/
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("SELECT ID, Titulo, Status, Autor FROM estagio_livraria.Livro WHERE Titulo LIKE ?")
		
		Throw:$$$ISERR(tSC)
			
		Set tRset = tSt.%Execute("%"_pTitulo_"%")
			
		While tRset.%Next()
		{
			/* Achar rowcount */
			Set tTitulos(tRset.%ROWCOUNT) = tRset.%Get("Titulo")_tRset.%Get(Status)
		}
		
		/* OUTPUT - retornos desejados */
		Set pLivro = tRset.%CurrentResult
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro ao procurar título do livro"
		Write $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}

	Quit tRset.%ROWCOUNT
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
<Value name="6">
<Value>Cliente</Value>
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
