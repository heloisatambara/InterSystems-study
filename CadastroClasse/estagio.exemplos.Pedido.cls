Class estagio.exemplos.Pedido Extends (%Persistent, %Populate)
{

Relationship Cliente As estagio.exemplos.Cliente [ Cardinality = one, Inverse = PedidoCliente, OnDelete = cascade, SqlColumnNumber = 2 ];

Relationship Produto As estagio.exemplos.Produto [ Cardinality = one, Inverse = PedidoProduto, OnDelete = cascade, SqlColumnNumber = 3 ];

Property Quantidade As %Integer [ Required, SqlColumnNumber = 4 ];

Index ClienteIndex On Cliente;

// Index ProdutoIndex On Produto;

// cadastrar, atualizar, excluir, exibir, procurar por nome

/// Pede informações para serem cadastradas através do método Cadastrar. Retorna status. As propriedades cliente e produto são selecionadas pelo nome através do método ProcurarNome
ClassMethod ChamaCadastro() As Pedido
{
	Set tSC = 0
	Set tCliente = ##class(estagio.exemplos.Pedido).ProcurarNome("C") // pega ID de cliente pelo nome para cadastrar na propriedade
	
	Hang .25
	Set tProduto = ##class(estagio.exemplos.Pedido).ProcurarNome("P") // pega ID de produto pelo nome para cadastrar na propriedade
	
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Quantidade.....: ", tQuantidade, ?70,                             "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	
	// se todas as entradas forem vazias volta para Iniciar() 
	Set tCliente = ##class(estagio.exemplos.Cliente).%OpenId(tCliente), tProduto = ##class(estagio.exemplos.Produto).%OpenId(tProduto)
	Set:(tCliente_tProduto_tQuantidade '= "") tSC = ##class(estagio.exemplos.Pedido).Cadastrar(tCliente, tProduto, tQuantidade)
	Quit tSC
}

/// Define como propriedades os argumentos passados e salva. Retorna status
ClassMethod Cadastrar(pCliente As estagio.exemplos.Cliente, pProduto As estagio.exemplos.Produto, pQuantidade As %Integer) As %Status
{
	Set tSC = 1
	// consistencia aqui mesmo:
	If (pQuantidade '> 0)
	{	
		Write !, " Dados não cadastrados."
		Hang 1
		Set tSC = 0
	}
	If (tSC=1) // cadastro realizado se passar na consistência
	{
		Set tPedido = ##class(estagio.exemplos.Pedido).%New()
		Set tPedido.Cliente = pCliente, tPedido.Produto = pProduto, tPedido.Quantidade = pQuantidade
		Set tSC = tPedido.%Save() // guarda informações na forma mais simples
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC) // a consistencia já garante que nunca vai cair aqui
		}
		Else
		{
			Write !, " Dados cadastrados com sucesso:"
			Do tPedido.ExibirUm() // se o cadastro ocorreu com sucesso, mostra as informações no formato de display definido na classe
		}
	}
	Quit tSC
}

/// Pergunta forma de exibição e chama método Exibir
ClassMethod ChamaExibir()
{
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Exibir todos", "Pesquisar por ID", "Pesquisar por cliente", "Pesquisar por produto", "Pesquisar por quantidade")
	Hang .25
	
	Do:tNum ##class(estagio.exemplos.Pedido).Exibir(tNum)
	Quit
}

/// Exibe tudo ou filtra com base no que for escolhido pelo usuário - pesquisa por produto ou cliente pelo nome
ClassMethod Exibir(pTipo As %Integer = 1, pExpandir As %Boolean = 1)
{
	If (pTipo'=1)
	{
		Write !!, "Digite o ", $Case(pTipo, 2:"ID", 3:"cliente", 4:"produto", 5:"quantidade"), ": "
		Read tSearch
		Set:((pTipo=3)||(pTipo=4)) tSearch = "%"_tSearch_"%" // query por nome do cliente ou produto non case-sensitive
	}
	If (pTipo=5)
	{
		Read !, " Ver quais resultados? (>/</=) ", tString // define se a querty mostra pedidos acima abaixo ou igual à quantidade escolhida pelo usuário
		Set:("><="[tString) tString = " WHERE Quantidade"_tString // será passado na condição 
	}
	
	Write !!, ?13, "|     Cliente     |     Produto     |  Quantidade  |"
	Set tQuery = "SELECT ID, Cliente, Produto, Quantidade FROM estagio_exemplos.Pedido"
	Set tCondition = $Case(pTipo, 1:"", 2:" WHERE ID=?", 3:" WHERE Cliente->Nome LIKE ?", 4:" WHERE Produto->Nome LIKE ?", 5:tString_"?")  // filtro selecionado no ChamaExibir()
	Set tQuery = tQuery_tCondition
	// Write !, tQuery
 	Set tStatement = ##class(%SQL.Statement).%New()
 	Set tStatus = tStatement.%Prepare(tQuery)
	Set trset = $CASE(pTipo, 1:tStatement.%Execute(), :tStatement.%Execute(tSearch)) // se não houve pesquisa, não precisa passar parâmetro
	
	While (trset.%Next()) // itera por todas as linhas que passam no filtro do usuário e escreve
	{
		Set tPedido = ##class(estagio.exemplos.Pedido).%OpenId(trset.%Get("ID"))
		Set tCliente = tPedido.Cliente.Nome, tProduto = tPedido.Produto.Nome
		If ($LENGTH(tCliente) > 15) { // trunca nomes de clientes longos demais para a tabela
			Set $Extract(tCliente,12, *) = "..."
		}
		If ($LENGTH(tProduto) > 18) { // trunca nomes de produtos longos demais para a tabela
			Set $Extract(tProduto,15, *) = "..."
		}
		// escreve
		Write !, "Pedido ", tPedido.%Id(), ?14, tCliente, ?32, tProduto, ?50, $JUSTIFY(tPedido.Quantidade, 14)
	}
	
	If (pExpandir)
	{
		Read !, " Para expandir informações de algum produto, digite o ID: ", tAns
		Hang .25
		If (tAns '= "")
		{
			Set tPedidoExp = ##class(estagio.exemplos.Pedido).%OpenId(tAns)
			If (tPedidoExp="")
			{
				Write ! // ID inválido escreve linha em branco
			}
			Else
			{
				Do tPedidoExp.ExibirUm()
			}
		}
	}
}

/// Exibe informações completas de objeto instanciado
Method ExibirUm()
{
	Hang .25
	Write !,  "#######################################################################"
	Write !,  "#", ?70,                                                             "#"
	Write !,  "# ID................: ", ..%Id(), ?70,                               "#"
	Write !,  "# Cliente...........: ", ..Cliente.Nome, ?70,                        "#"
	Write !,  "# Produto...........: ", ..Produto.Nome, ?70,                        "#"
	Write !,  "# Quantidade........: ", ..Quantidade, ?70,                          "#"
	Write !,  "#", ?70,                                                             "#"
	Write !,  "#######################################################################"
	
	Read !, tEnter // espera interação para seguir
}

/// Seleciona um pedido e altera suas propriedades (cliente e produto pelo método ProcurarNome())
ClassMethod ChamaAtualiza()
{
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Pesquisar lista de pedidos? ", tAns, ?70,                          "#"
	If ("SimsimSIM"[tAns)
	{ // pesquisa e exibe todos os pedidos do cliente ou produto escolhidos 
		Read !, "# Pesquisar por cliente (1) ou por produto (2)? ", tNum, ?70,         "#"
		Write !, "#", ?70, "#"
		Write !, "#######################################################################"
		Do ##class(estagio.exemplos.Pedido).Exibir(tNum+2, 0)
	}
	
	Write !, "#######################################################################"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Qual pedido deseja atualizar? ", tID, ?70,                         "#" // seleciona o pedido por ID - apareceu na pesquisa anterior
	
	Set tCliente = ##class(estagio.exemplos.Pedido).ProcurarNome("C") // pega ID de cliente pelo nome para cadastrar na propriedade
	Set tProduto = ##class(estagio.exemplos.Pedido).ProcurarNome("P") // pega ID de produto pelo nome para cadastrar na propriedade
	
	Read !,  "# Quantidade.....: ", tQuantidade, ?70,                              "#"
	Write !, "#", ?70,                                                             "#"
	
	
	Set:(tID'=0) tPedido = ##class(estagio.exemplos.Pedido).%OpenId(tID) // instancia o pedido escolhido por ID para atualizar suas propriedades
	Write:(tPedido="") !, " ID inválido"
	Do:(tPedido '= "") tPedido.Atualizar(tCliente, tProduto, tQuantidade)
	Quit
}

/// Altera as propriedades do objeto instanciado passadas como argumentos e salva
Method Atualizar(pCliente As %Integer, pProduto As %Integer, pQuantidade As %Integer) As %Status
{
 	Set pCliente = ##class(estagio.exemplos.Cliente).%OpenId(pCliente) // cliente e produto passado por ID
 	Set pProduto = ##class(estagio.exemplos.Produto).%OpenId(pProduto) // aqui são instanciados
 	
 	// checa consistencia e salva igual no cadastro
	Set tSC = 1
	// consistencia aqui mesmo:
	If (pQuantidade'="")&&(pQuantidade '> 0)
	{	
		Write !, " Dados inválidos."
		Hang 1
		Set tSC = 0
	}
	
	If (tSC=1)
	{ // altera argumentos não nulos
		Set:(pCliente'="") ..Cliente = pCliente
		Set:(pProduto'="") ..Produto = pProduto
		Set:(pQuantidade'="") ..Quantidade = pQuantidade
		Set tSC = ..%Save() // guarda informações na forma mais simples
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC) // a consistencia já garante que nunca vai cair aqui
		}
		Else
		{
			Write !!, "Dados atualizados:" // se o cadastro ocorreu com sucesso, mostra as informações no formato de display definido na classe
			Do ..ExibirUm()
		}
	}
	Quit tSC
}

/// Seleciona um cliente ou produto pelo nome através de uma query e retorna o ID
ClassMethod ProcurarNome(pQual As %String(MAXLEN=1)) As %Integer
{
	Set pQual = $CASE(pQual, "C":"Cliente", "P":"Produto") // argumento define se a query será para produtos ou clientes
	While 1 // roda até conseguir um ID válido ou 0
	{
		Write !, "#", ?70, "#", !,  "# "_pQual_"........: " // pergunta nome do cliente ou produto
		Read tSearch
		If ($ISVALIDNUM(tSearch)) // possibilita escolha por ID caso o nome não seja único.
		{
			Set tID = $CASE(pQual, "Cliente":##class(estagio.exemplos.Cliente).%OpenId(tSearch), "Produto":##class(estagio.exemplos.Produto).%OpenId(tSearch))
			Set:tID tID = tID.%Id() // não faço Set tID = tSearch para verificar se foi um ID válido digitado
			Quit:tID 
		}
		ElseIf (tSearch="")
		{
			Set tID=0 // se a pesquisa foi vazia segue com ID inválido (para possibilitar deixar atualização em branco)
			Quit
		}
		Else
		{
			Set tSearch = "%"_tSearch_"%" // query non case-sensitive
			Set tQuery =  "SELECT ID, Nome FROM estagio_exemplos."_pQual_" WHERE Nome LIKE ?"
			Set tStatement = ##class(%SQL.Statement).%New()
 			Set tStatus = tStatement.%Prepare(tQuery)
			Set tRSet = tStatement.%Execute(tSearch) // passada por parâmetro para evitar injection
			Set tRowcount = 0
			Set tNamesID = ""
			
			While (tRSet.%Next())
			{
				Set tNamesID = tNamesID_tRSet.%Get("ID")_" - "_tRSet.%Get("Nome")_", "
				Do $INCREMENT(tRowcount) // conta quantas linhas passaram no filtro do nome e anota todos esses nomes (pq não consegui usar %ROWCOUNT?)
			}	
			
			If (tRowcount=1)
			{
				Write " - ", tRSet.%Get("Nome"), ?70, "#" // se só teve um resultado no filtro, esse será o resultado final,
				
				Set tID = tRSet.%Get("ID")                // então pega o ID
				
				Quit                                      // e sai do loop
			}
			ElseIf (tRowcount'=0)
			{   // se tem várias linhas resultantes da pesquisa, apresenta todos os nomes e IDs que passaram no filtro
				Write ?70, "#"
				Write !, "# Vários dados com esse nome: ", ?70, "#"
				Write !, "# ", tNamesID, ?70, "#"		
			}
		}
	}
	Quit tID // retorna o ID
}

Storage Default
{
<Data name="PedidoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Quantidade</Value>
</Value>
<Value name="3">
<Value>Produto</Value>
</Value>
<Value name="4">
<Value>Cliente</Value>
</Value>
</Data>
<DataLocation>^estagio.exemplos.PedidoD</DataLocation>
<DefaultData>PedidoDefaultData</DefaultData>
<ExtentSize>2</ExtentSize>
<IdLocation>^estagio.exemplos.PedidoD</IdLocation>
<IndexLocation>^estagio.exemplos.PedidoI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Cliente">
<AverageFieldSize>2.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Produto">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Quantidade">
<AverageFieldSize>3.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="ClienteIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.exemplos.PedidoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
