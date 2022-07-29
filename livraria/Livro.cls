Class estagio.livraria.Livro Extends %Persistent
{

Relationship Aluguel As estagio.livraria.Aluguel [ Cardinality = many, Inverse = Livro ];

Property Titulo As %String(MAXLEN = 100) [ Required ];

Property Autor As %String;

Property Editora As %String;

Property Status As %String(DISPLAYLIST = ",Disponível,Alugado", VALUELIST = ",D,A");

/// Trigger define o livro como disponível ao ser cadastrado
Trigger Cadastro [ Event = INSERT, Time = AFTER ]
{
	Try
	{
		/* INPUT - Id do livro que foi cadastrado */
		Set tID = {ID}
		
		/* QUERY - Define como disponível */
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("UPDATE estagio_livraria.Livro SET Status = 'D' WHERE ID = ?")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tID)
		
		Throw:(tRset.%SQLCODE<0)
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro de TRIGGER"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!, tRset.%Message
		Write !!, $SYSTEM.Status.DisplayError(tSC)
		Write !!, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
}

/// Realiza o cadastro do livro por INSERT - pede Título, Autor e Editora
ClassMethod Cadastrar() As %Status
{
	Set tSC = $$$OK
	
	/* INPUT - pede as informações que serão guardadas */
	Read !, ">>> Título: ", tTitulo
	Read !, ">>> Autor: ", tAutor
	Read !, ">>> Editora: ", tEditora	
	
	
	/* QUERY - inserir as informações digitadas na tabela */
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
		/* tratamento de erro */
		Set tSC = EXC.AsStatus()
		
		Write !, "Erro no Cadastro"
		Write !, $SYSTEM.Status.DisplayError(tSC)
	}
	
	Quit tSC
}

/// Exibe os livros - por argumento pode filtrar por Status (Disponível ou Alugado) e o método pede filtros por título, autor e editora (podem ser preenchidos quantos quiser - inclusive nenhum)
ClassMethod Exibir(pAlugado As %String)
{
	Set tSC = $$$OK
	
	Try
	{
		/* QUERY (string) - com filtros para Titulo, Autor e Editora */
		Set tQuery = "SELECT ID, Titulo, Autor, Editora, Status FROM estagio_livraria.Livro WHERE Titulo LIKE ? AND Autor LIKE ? AND Editora LIKE ?"
		
		
		/* INPUT - filtros desejados */
		Read !, ">>> Por Título: ", tTitulo
		Read !, ">>> Por Autor@: ", tAutor
		Read !, ">>> Por Editora: ", tEditora, !
		
		// ajusta para colocar na pesquisa - non case-sensitive e com mais letras antes ou depois
		Set tAutor = "%"_tAutor_"%", tEditora = "%"_tEditora_"%", tTitulo = "%"_tTitulo_"%"
		
		
		/* QUERY - prepara */
		// se passado por argumento, mostra somente os livros alugados ou somente os disponíveis
		Set:($DATA(pAlugado)) tQuery = tQuery_" AND Status = '"_pAlugado_"'"
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare(tQuery)
		
		Throw:$$$ISERR(tSC)
		
		// faz a pesquisa
		Set tRset = tSt.%Execute(tTitulo, tAutor, tEditora)

		/* DISPLAY */
		// cabeçalho
		Write !, "     Título", ?29, "Autor", ?50, "Editora", ?66, "Status"
		
		While (tRset.%Next())
		{
			// arruma tamanho das strings
			Set tTitulo = tRset.%Get("Titulo")
			Set:($LENGTH(tTitulo)>20) tTitulo = $EXTRACT(tTitulo,1, 17)_"..."
			Set tEditora = tRset.%Get("Editora")
			Set:($LENGTH(tEditora)>14) tEditora = $EXTRACT(tEditora, 1, 11)_"..."
	
			Write !, "#"_tRset.%Get("ID"), ?5, tTitulo, ?29, tRset.%Get("Autor"), ?50, tEditora, ?66, ..StatusLogicalToDisplay(tRset.%Get("Status"))
		} 
		
		
		Read !, tEnter // pede interação do usuário antes de continuar
	}
	Catch EXC
	{
		/* tratamento de erro */
		Write !, "Erro de exibição"
		Write:$$$ISERR(tSC) !, $SYSTEM.Status.DisplayError(tSC)
		Write !, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit
}

/// Apaga por DELETE do SQL - Pesquisa por título do livro e pede confirmação antes de apagar
ClassMethod Apagar() As %Status
{
	Set tSC = $$$OK
	
	Try
	{	
		/* INPUT - pede título do livro até que encontre um só que tenha a string inserida e esteja disponível */
		Do
		{
			Read !, ">>> Apagar livro: ", tTitulo
		
			Set tROWCOUNT = ##class(estagio.livraria.Aluguel).ProcuraTitulo(tTitulo, .tLivro) 
			
			// não termina a pesquisa se o livro estiver alugado - não pode ser apagado
			Write:(tLivro.Status="A") !, """"_tLivro.Titulo_""" não pode ser apagado, pois está alugado."
		}
		While ((tROWCOUNT '=1)||(tLivro.Status="A"))
		
		
		/* INPUT - pede confirmação antes de apagar */
		Write !, " >>> Deletar "_tLivro.Titulo_"? "
		
		Read tResposta
		
		
		/* QUERY - deleta livro selecionado */
		If ("SIMSimsim"[tResposta)
		{
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("DELETE FROM estagio_livraria.Livro WHERE ID = "_tLivro.%Id)
		
			Throw:$$$ISERR(tSC)
		
			Set tRset = tSt.%Execute()
		
			Throw:(tRset.%SQLCODE<0)	
		}
		
		/* DISPLAY - mensagem se foi deletado ou não */
		Write !, $SELECT("SIMSimsim"[tResposta:">>> Dados apagados", "SIMSimsim"'[tResposta:">>> Dados mantidos")	
		
	}
	Catch EXC
	{
		/* tratamento de erros */
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
