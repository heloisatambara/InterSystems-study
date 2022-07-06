Class estagio.exemplos.Pedido Extends (%Persistent, %Populate)
{

// Property Cliente As estagio.exemplos.Cliente [ Required, SqlColumnNumber = 2 ];

// Property Produto As estagio.exemplos.Produto [ Required, SqlColumnNumber = 3 ];

Property Quantidade As %Integer [ Required, SqlColumnNumber = 4 ];

Relationship Produto As estagio.exemplos.Produto [ Cardinality = one, Inverse = PedidoProduto, OnDelete = cascade, SqlColumnNumber = 3 ];

// Index ProdutoIndex On Produto;

Relationship Cliente As estagio.exemplos.Cliente [ Cardinality = one, Inverse = PedidoCliente, OnDelete = cascade, SqlColumnNumber = 2 ];

Index ClienteIndex On Cliente;

ClassMethod ChamaCadastro() As Pedido
{
	Set tSC = 0
	Set tCliente = ##class(estagio.exemplos.Pedido).ProcurarNome("C")
	
	Hang .25
	Set tProduto = ##class(estagio.exemplos.Pedido).ProcurarNome("P")
	
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Quantidade......: ", tQuantidade, ?70,                             "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	
	Set tCliente = ##class(estagio.exemplos.Cliente).%OpenId(tCliente), tProduto = ##class(estagio.exemplos.Produto).%OpenId(tProduto)
	Set:(tCliente_tProduto_tQuantidade '= "") tSC = ##class(estagio.exemplos.Pedido).Cadastrar(tCliente, tProduto, tQuantidade)
	Quit tSC
}

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
	If (tSC=1)
	{
		Set tPedido = ##class(estagio.exemplos.Pedido).%New()
		Set tPedido.Cliente = pCliente, tPedido.Produto = pProduto, tPedido.Quantidade = pQuantidade
		Set tSC = tPedido.%Save()
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC)
		}
		Else
		{
			Write !, " Dados cadastrados com sucesso:"
			Do tPedido.ExibirUm()
		}
	}
	Quit tSC
}

ClassMethod ChamaExibir()
{
	Write !, "#", ?70,                                                             "#"
	Write !, "#", " 1- Exibir todos", ?70,                                         "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,                                     "#"
	Write !, "#", " 3- Pesquisar por cliente", ?70,                                "#"
	Write !, "#", " 4- Pesquisar por produto", ?70,                                "#"
	Write !, "#", " 5- Pesquisar por quantidade", ?70,                             "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum,?70,                           "#"
	Write !, "#",?70,                                                              "#"
	Write !, "#######################################################################"
	Hang .25
	
	Do:tNum ##class(estagio.exemplos.Pedido).Exibir(tNum)
	Quit
}

ClassMethod Exibir(pTipo As %Integer = 1, pExpandir As %Boolean = 1)
{
 // todo: possibilitar pesquisa por nome do cliente e nome do produto
	If (pTipo'=1)
	{
		Write !!, "Digite o ", $Case(pTipo, 2:"ID", 3:"cliente", 4:"produto", 5:">/</=quantidade"), ": "
		Read tSearch
	}
	
	Write !!, ?13, "|     Cliente     |     Produto     |  Quantidade  |"
	Set tQuery = "SELECT ID, Cliente, Produto, Quantidade FROM estagio_exemplos.Pedido"
	Set tCondition = $Case(pTipo, 1:"", 2:" WHERE ID='"_tSearch_"'", 3:" WHERE Cliente->Nome LIKE '%"_tSearch_"%'", 4:" WHERE Produto->Nome LIKE '%"_tSearch_"%'", 5:" WHERE Quantidade"_tSearch)
	Set tQuery = tQuery_tCondition
	// Write !, tQuery
 	Set tStatement = ##class(%SQL.Statement).%New()
 	Set tStatus = tStatement.%Prepare(tQuery)
	Set trset = tStatement.%Execute()
	
	While (trset.%Next())
	{
		Set tPedido = ##class(estagio.exemplos.Pedido).%OpenId(trset.%Get("ID"))
		Set tCliente = tPedido.Cliente.Nome, tProduto = tPedido.Produto.Nome
		If ($LENGTH(tCliente) > 15) {
			Set $Extract(tCliente,12, *) = "..."
		}
		If ($LENGTH(tProduto) > 18) {
			Set $Extract(tProduto,15, *) = "..."
		}
		
		Write !, "Pedido ", tPedido.%Id(), ?14, tCliente, ?32, tProduto, ?50, $JUSTIFY(tPedido.Quantidade, 14)
	}
	
	If pExpandir
	{
		Read !, " Para expandir informações de algum produto, digite o ID: ", tAns
		Hang .25
		If (tAns '= "")
		{
			Set tPedidoExp = ##class(estagio.exemplos.Pedido).%OpenId(tAns)
			If (tPedidoExp="")
			{
				Write !
			}
			Else
			{
				Do tPedidoExp.ExibirUm()
			}
		}
	}
}

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
	
	Read !, tEnter
}

ClassMethod ChamaAtualiza()
{
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Pesquisar lista de pedidos? ", tAns, ?70,                          "#"
	If ("SimsimSIM"[tAns)
	{
		Read !, "# Pesquisar por cliente (1) ou por produto (2)? ", tNum, ?70,         "#"
		Write !, "#", ?70, "#"
		Write !, "#######################################################################"
		Do ##class(estagio.exemplos.Pedido).Exibir(tNum+2, 0)
	}
	
	Write !, "#######################################################################"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Qual pedido deseja atualizar? ", tID, ?70,                         "#"
	
	Set tCliente = ##class(estagio.exemplos.Pedido).ProcurarNome("C")
	Set tProduto = ##class(estagio.exemplos.Pedido).ProcurarNome("P")
	
	Read !,  "# Quantidade.....: ", tQuantidade, ?70,                              "#"
	Write !, "#", ?70,                                                             "#"
	
	
	Set:(tID'=0) tPedido = ##class(estagio.exemplos.Pedido).%OpenId(tID)
	Write:(tPedido="") !, " ID inválido"
	Do:(tPedido '= "") tPedido.Atualizar(tCliente, tProduto, tQuantidade)
	Quit
}

Method Atualizar(pCliente As %Integer, pProduto As %Integer, pQuantidade As %Integer) As %Status
{
 	Set pCliente = ##class(estagio.exemplos.Cliente).%OpenId(pCliente)
 	Set pProduto = ##class(estagio.exemplos.Produto).%OpenId(pProduto)
 	
	Set tSC = 1
	// consistencia aqui mesmo:
	If (pQuantidade'="")&&(pQuantidade '> 0)
	{	
		Write !, " Dados inválidos."
		Hang 1
		Set tSC = 0
	}
	
	If (tSC=1)
	{
		Set:(pCliente'="") ..Cliente = pCliente
		Set:(pProduto'="") ..Produto = pProduto
		Set:(pQuantidade'="") ..Quantidade = pQuantidade
		Set tSC = ..%Save()
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC)
		}
		Else
		{
			Do ..ExibirUm()
		}
	}
	Quit tSC
}

ClassMethod ChamaApagar()
{
	Do ##class(estagio.exemplos.Pedido).Exibir(,0)
	Read !!, " Deseja apagar quais dados? (0 apaga  tudo) ", tNum
	Set tPedido = ##class(estagio.exemplos.Pedido).%OpenId(tNum)
	Do:(tPedido'="") tPedido.ExibirUm()
	Read !!, " Tem certeza? ", tAns
	
	If ("SimSIMsim"[tAns)
	{	
		If (tNum = 0)
		{
			Do ##class(estagio.exemplos.Pedido).%DeleteExtent()
			Write !, " Todos os dados apagados."
		}   
		Else
		{	
			Do ##class(estagio.exemplos.Pedido).%DeleteId(tNum)
			Write !, " Dados apagados."
		}
	Read !, " Apagar mais algum? ", tAns
	If ("simSimSIM"[tAns)
	{
		Do ##class(estagio.exemplos.Cliente).ChamaApagar()
	}	
	}
	Quit
}

ClassMethod ProcurarNome(pQual As %String(MAXLEN=1)) As %Integer
{
	Set pQual = $CASE(pQual, "C":"Cliente", "P":"Produto")
	While 1
	{
		Write !, "#", ?70, "#", !,  "# "_pQual_"........: "
		Read tSearch
		
		Set tQuery =  "SELECT ID, Nome FROM estagio_exemplos."_pQual_" WHERE Nome LIKE '%"_tSearch_"%'"
		Set tStatement = ##class(%SQL.Statement).%New()
 		Set tStatus = tStatement.%Prepare(tQuery)
		Set tRSet = tStatement.%Execute()
		Set tRowcount = 0
		Set tNames = ""
		While (tRSet.%Next())
		{
			Set tNames = tNames_tRSet.%Get("Nome")_", "
			Do $INCREMENT(tRowcount)
		}
		If (tRowcount=1)
		{
			Write " - ", tRSet.%Get("Nome"), ?70, "#"
			Set tID = tRSet.%Get("ID")
			Quit
		}
		ElseIf (tSearch="")
		{
			Set tID=0
			Quit
		}
		ElseIf (tRowcount'=0)
		{
			Write ?70, "#"
			Write !, "# Vários dados com esse nome: ", ?70, "#"
			Write !, "# ", tNames, ?70, "#"		
		}
		
	}
	Quit tID
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
