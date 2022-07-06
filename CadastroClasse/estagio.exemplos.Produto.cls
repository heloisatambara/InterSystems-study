Class estagio.exemplos.Produto Extends %Persistent
{

Relationship PedidoProduto As estagio.exemplos.Pedido [ Cardinality = many, Inverse = Produto ];

// Index PedidoProdutoIndex On PedidoProduto;

Property Nome As %String [ Required, SqlColumnNumber = 2 ];

Property Descricao As %String [ SqlColumnNumber = 3 ];

Property Preco As %Decimal(SCALE = 2) [ Required, SqlColumnNumber = 4 ];

Parameter DOLLARPRICE = 5.20;

ClassMethod ChamaCadastro() As Produto
{

	Write !, "#", ?70,                                                             "#"
	Read !,  "# Nome.............: ", tNome, ?70,                                  "#"
	Hang .25
	Read !,  "# Descrição........: ", tDescricao, ?70,                             "#"
	Hang .25
	Read !,  "# Preço............: ", tPreco, ?70,                                 "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	
	Quit:(tNome_tDescricao_tPreco = "") 0
	Set tSC = ##class(estagio.exemplos.Produto).Cadastrar(tNome, tDescricao, tPreco)
	Quit tSC
}

ClassMethod Cadastrar(pNome As %String, pDescricao As %String, pPreco As %Decimal) As estagio.exemplos.Produto
{
	
	Set tSC = 1
	// consistencia aqui mesmo:
	If ((pNome="")||(pPreco '> 0))
	{	
		Write !, " Dados não cadastrados."
		Hang 1
		Set tSC = 0
		
	}
	If (tSC=1)
	{
		Set tProduto = ##class(estagio.exemplos.Produto).%New()
		Set tProduto.Nome = pNome, tProduto.Descricao = pDescricao, tProduto.Preco = pPreco
		Set tSC = tProduto.%Save()
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC)
		}
		Else
		{
			Write !, " Dados cadastrados com sucesso:"
			Do tProduto.ExibirUm()
		}
	}
	Quit tSC
}

ClassMethod ChamaExibir()
{
	Write !, "#", ?70,                                                             "#"
	Write !, "#", " 1- Exibir todos", ?70,                                         "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,                                     "#"
	Write !, "#", " 3- Pesquisar por nome", ?70,                                   "#"
	Write !, "#", " 4- Pesquisar por preço", ?70,                                  "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum,?70,                           "#"
	Write !, "#",?70,                                                              "#"
	Write !, "#######################################################################"
	Hang .25
	Quit:'tNum
	Do ##class(estagio.exemplos.Produto).Exibir(tNum)
	Quit
}

ClassMethod Exibir(pTipo As %Integer = 1)
{
	If (pTipo'=1)
	{
		Write !!, "Digite o ", $Case(pTipo, 2:"ID", 3:"Nome", 4:"Preço"), ": "
		Read tSearch
	}
	
	Write !!, ?10, "|     Nome     |            Descrição            |   Preço   |"
	Set tQuery = "SELECT ID, Descricao, Nome, Preco FROM estagio_exemplos.Produto"
	Set tCondition = $Case(pTipo, 1:"", 2:" WHERE ID='"_tSearch_"'", 3:" WHERE Nome LIKE '%"_tSearch_"%'", 4:" WHERE Preco"_tSearch)
	Set tQuery = tQuery_tCondition
	// Write !, tQuery
 	Set tStatement = ##class(%SQL.Statement).%New()
 	Set tStatus = tStatement.%Prepare(tQuery)
	Set trset = tStatement.%Execute()
	
	While (trset.%Next())
	{
		Set tProduto = ##class(estagio.exemplos.Produto).%OpenId(trset.%Get("ID"))
		Set tNome = tProduto.Nome, tDescricao = tProduto.Descricao
		If ($LENGTH(tNome) > 14) {
			Set $Extract(tNome,12, *) = "..."
		}

		If ($LENGTH(tDescricao) > 34) {
			Set $Extract(tDescricao,31, *) = "..."
		}
		
		Write !, "Produto ", tProduto.%Id(), ?11, tNome, ?26, tDescricao, ?60, "R$", $Justify($FNUMBER(tProduto.Preco,,2), 9)
	}
	
	Read !, " Para expandir informações de algum produto, digite o ID: ", tAns
	Hang .25
	If (tAns '= "")
	{
		Set tProdutoExp = ##class(estagio.exemplos.Produto).%OpenId(tAns)
		If (tProdutoExp="")
		{
			Write !
		}
		Else
		{
			Do tProdutoExp.ExibirUm()
		}
		
	}
}

Method ExibirUm()
{
	Hang .25
	Write !,  "#######################################################################"
	Write !,  "#", ?70,                                                             "#"
	Write !,  "# ID..................: ", ..%Id(), ?70,                             "#"
	Write !,  "# Nome................: ", ..Nome, ?70,                              "#"
	Write !,  "# Descrição...........: ", ..Descricao, ?70,                         "#"
	Write !,  "# Preço...............: ", ..Preco, ?70,                             "#"
	Write !,  "#", ?70,                                                             "#"
	Write !,  "#######################################################################"
	
	Read !, tEnter
}

ClassMethod ChamaApagar()
{
	Do ##class(estagio.exemplos.Produto).Exibir()
	Read !!, "Deseja apagar quais dados? (0 apaga tudo) ", tNum
	Set tProduto = ##class(estagio.exemplos.Produto).%OpenId(tNum)
	Do:(tNum'=0) tProduto.ExibirUm()
	
	Read !!, " Tem certeza? ", tAns
	
	If ("SimSIMsim"[tAns)
	{	
		Do:(tNum=0) ##class(estagio.exemplos.Produto).%DeleteExtent()
		Do:(tNum'=0) ##class(estagio.exemplos.Produto).%DeleteId(tNum)
		Write !, " Dados apagados."
		Hang .5
	}
	
	Read !, " Apagar mais algum? ", tAns
	If ("simSimSIM"[tAns)
	{
		Do ##class(estagio.exemplos.Produto).ChamaApagar()
	}
	
	Quit
}

ClassMethod ChamaAtualiza() As %Status
{
	Set tID = ##class(estagio.exemplos.Pedido).ProcurarNome("P")
		
	Read !,  "# Nome.............: ", tNome, ?70,                                  "#"
	Read !,  "# Descrição........: ", tDescricao, ?70,                             "#"
	Read !,  "# Preço............: ", tPreco, ?70,                                 "#"
	Write !, "#", ?70,                                                             "#"
	
	Set:(tID'=0) tProduto = ##class(estagio.exemplos.Produto).%OpenId(tID)
	Set:(tProduto'="") tSC = tProduto.Atualizar(tNome, tDescricao, tPreco)
	Set:(tProduto="") tSC = 0
	Quit tSC
}

Method Atualizar(pNome As %String, pDescricao As %String, pPreco As %Decimal) As %Status
{
 // atualizar pelo nome do cliente e do produto
	Set tSC = 1
	// consistencia aqui mesmo:
	If (pPreco'="")&&(pPreco '> 0)
	{	
		Write !, " Dados inválidos."
		Hang 1
		Set tSC = 0
	}
	
	If (tSC=1)
	{
		Set:(pNome'="") ..Nome = pNome
		Set:(pDescricao'="") ..Descricao = pDescricao
		Set:(pPreco'="") ..Preco = pPreco
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

ClassMethod PrecoEmDolar(pID As %Integer) As %Decimal
{
	Set tProduto = ##class(estagio.exemplos.Produto).%OpenId(pID)
	Set tPrecoEmDolar = tProduto.Preco * ..#DOLLARPRICE
	Quit tPrecoEmDolar
}

Storage Default
{
<Data name="ProdutoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nome</Value>
</Value>
<Value name="3">
<Value>Descricao</Value>
</Value>
<Value name="4">
<Value>Preco</Value>
</Value>
</Data>
<DataLocation>^estagio.exemplos.ProdutoD</DataLocation>
<DefaultData>ProdutoDefaultData</DefaultData>
<ExtentSize>2</ExtentSize>
<IdLocation>^estagio.exemplos.ProdutoD</IdLocation>
<IndexLocation>^estagio.exemplos.ProdutoI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Descricao">
<AverageFieldSize>35</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Nome">
<AverageFieldSize>22.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Preco">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.exemplos.ProdutoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
