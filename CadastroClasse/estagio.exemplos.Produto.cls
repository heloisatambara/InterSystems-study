Class estagio.exemplos.Produto Extends %Persistent
{

Relationship PedidoProduto As estagio.exemplos.Pedido [ Cardinality = many, Inverse = Produto ];

// Index PedidoProdutoIndex On PedidoProduto;

Property Nome As %String [ Required, SqlColumnNumber = 2 ];

Property Descricao As %String [ SqlColumnNumber = 3 ];

Property Preco As %Decimal(SCALE = 2) [ Required, SqlColumnNumber = 4 ];

Parameter DOLLARPRICE = 5.20;

// cadastrar, atualizar, excluir, exibir, dar preco em dolar

/// Pede informações para serem cadastradas através do método Cadastrar. Retorna status.
ClassMethod ChamaCadastro() As %Status
{
	Set tSC = 0
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Nome.............: ", tNome, ?70,                                  "#"
	Hang .25
	Read !,  "# Descrição........: ", tDescricao, ?70,                             "#"
	Hang .25
	Read !,  "# Preço............: ", tPreco, ?70,                                 "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	
	// se todas as entradas forem vazias volta para Iniciar() 
	Set:(tNome_tDescricao_tPreco '= "") tSC = ##class(estagio.exemplos.Produto).Cadastrar(tNome, tDescricao, tPreco)
	Quit tSC
}

/// Define como propriedades os argumentos passados e salva. Retorna status
ClassMethod Cadastrar(pNome As %String, pDescricao As %String, pPreco As %Decimal) As %Status
{
	Set tSC = 1
	// consistencia aqui mesmo:
	If ((pNome="")||(pPreco '> 0))
	{	
		Write !, " Dados não cadastrados."
		Hang 1
		Set tSC = 0	
	}
	If (tSC=1) // cadastro realizado se passar na consistência
	{
		Set tProduto = ##class(estagio.exemplos.Produto).%New()
		Set tProduto.Nome = pNome, tProduto.Descricao = pDescricao, tProduto.Preco = pPreco
		Set tSC = tProduto.%Save() // guarda informações na forma mais simples
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC) // a consistencia já garante que nunca vai cair aqui
		}
		Else
		{
			Write !, " Dados cadastrados com sucesso:"
			Do tProduto.ExibirUm() // se o cadastro ocorreu com sucesso, mostra as informações no formato de display definido na classe
		}
	}
	Quit tSC
}

/// Pergunta forma de exibição e chama método Exibir
ClassMethod ChamaExibir()
{
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Exibir todos", "Pesquisar por ID", "Pesquisar por nome", "Pesquisar por preço")
	Hang .25
	
	Do:tNum ##class(estagio.exemplos.Produto).Exibir(tNum)
	Quit
}

/// Exibe tudo ou filtra com base no que for escolhido pelo usuário
ClassMethod Exibir(pTipo As %Integer = 1, pExpandir As %Boolean = 1)
{
	If (pTipo'=1)
	{
		Write !!, " Digite o ", $Case(pTipo, 2:"ID", 3:"Nome", 4:"Preço"), ": "
		Read tSearch
		Set:(pTipo=3) tSearch = "%"_tSearch_"%" // query por nome non case-sensitive
	}
	If (pTipo=4)
	{
		Read !, " Ver quais resultados? (>/</=) ", tString // define se a querty mostra produtos acima abaixo ou igual ao preço escolhido pelo usuário
		Set:("><="[tString) tString = " WHERE Preco"_tString  // será passado na condição 
	}
	
	Write !!, ?10, "|     Nome     |            Descrição            |   Preço   |"
	Set tQuery = "SELECT ID, Descricao, Nome, Preco FROM estagio_exemplos.Produto"
	Set tCondition = $Case(pTipo, 1:"", 2:" WHERE ID=?", 3:" WHERE Nome LIKE ?", 4:tString_"?") // filtro selecionado no ChamaExibir()
	Set tQuery = tQuery_tCondition
 	Set tStatement = ##class(%SQL.Statement).%New()
 	Set tStatus = tStatement.%Prepare(tQuery)
	Set trset = $CASE(pTipo, 1:tStatement.%Execute(), :tStatement.%Execute(tSearch)) // se não houve pesquisa, não precisa passar parâmetro
	
	While (trset.%Next()) // itera por todas as linhas que passam no filtro do usuário e escreve
	{
		Set tProduto = ##class(estagio.exemplos.Produto).%OpenId(trset.%Get("ID"))
		Set tNome = tProduto.Nome, tDescricao = tProduto.Descricao
		If ($LENGTH(tNome) > 14) { // trunca nomes longos demais para a tabela
			Set $Extract(tNome,12, *) = "..."
		}
		If ($LENGTH(tDescricao) > 34) { // trunca descrições longss demais para a tabela
			Set $Extract(tDescricao,31, *) = "..."
		}
		// escreve
		Write !, "Produto ", tProduto.%Id(), ?11, tNome, ?26, tDescricao, ?60, "R$", $Justify($FNUMBER(tProduto.Preco,,2), 9) // preço no formato R$ x.xx
	}
	
	If (pExpandir)
	{
		Read !, " Para expandir informações de algum produto, digite o ID: ", tAns
		Hang .25
		If (tAns '= "")
		{
			Set tProdutoExp = ##class(estagio.exemplos.Produto).%OpenId(tAns)
			If (tProdutoExp="")
			{
				Write !  // ID inválido escreve linha em branco
			}
			Else
			{
				Do tProdutoExp.ExibirUm()
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
	Write !,  "# ID..................: ", ..%Id(), ?70,                             "#"
	Write !,  "# Nome................: ", ..Nome, ?70,                              "#"
	Write !,  "# Descrição...........: ", ..Descricao, ?70,                         "#"
	Write !,  "# Preço...............: ", "R$"_$FNUMBER(..Preco,,2), ?70,           "#"  // preço no formato R$ x.xx
	Write !,  "#", ?70,                                                             "#"
	Write !,  "#######################################################################"
	
	Read !, tEnter // espera interação para seguir
}

/// Seleciona um produto com o método estagio.exemplos.Pedido.ProcurarNome("P") e altera os valores que forem passados pelo usuário
ClassMethod ChamaAtualiza() As %Status
{
	Set tID = ##class(estagio.exemplos.Pedido).ProcurarNome("P")  // garante que o ID selecionado é válido - escolhe pelo nome
		
	Read !,  "# Nome.............: ", tNome, ?70,                                  "#"
	Read !,  "# Descrição........: ", tDescricao, ?70,                             "#"
	Read !,  "# Preço............: ", tPreco, ?70,                                 "#"
	Write !, "#", ?70,                                                             "#"
	
	Set:(tID'=0) tProduto = ##class(estagio.exemplos.Produto).%OpenId(tID) // instancia o produto escolhido para alterar suas propriedades
	Set:(tProduto'="") tSC = tProduto.Atualizar(tNome, tDescricao, tPreco) // chama atualização somente se o id selecionado é válido 
	Set:(tProduto="") tSC = 0
	Quit tSC
}

/// Altera as propriedades do objeto instanciado passadas como argumentos e salva
Method Atualizar(pNome As %String, pDescricao As %String, pPreco As %Decimal) As %Status
{
	// checa consistencia e salva igual no cadastro
	Set tSC = 1
	// consistencia aqui mesmo:
	If (pPreco'="")&&(pPreco '> 0)
	{	
		Write !, " Dados inválidos."
		Hang 1
		Set tSC = 0
	}
	
	If (tSC=1)
	{ // altera argumentos não nulos
		Set:(pNome'="") ..Nome = pNome
		Set:(pDescricao'="") ..Descricao = pDescricao
		Set:(pPreco'="") ..Preco = pPreco
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

/// Calcula e retorna o valor em dólar da propriedade preco
Method DarPrecoEmDolar() As %Decimal
{
	Set tPrecoEmDolar = ..Preco * ..#DOLLARPRICE // calcula preço em dólar da instância e retorna o valor
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
