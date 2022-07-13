Class estagio.exemplos.Cliente Extends %Persistent
{

Relationship PedidoCliente As estagio.exemplos.Pedido [ Cardinality = many, Inverse = Cliente ];

// Index PedidoClienteIndex On PedidoCliente;

Property Nome As %String [ Required, SqlColumnNumber = 2 ];

Property Endereco As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

Property Telefone As %Integer [ Required, SqlColumnNumber = 4 ];

Property CPF As %Integer [ Required, SqlColumnNumber = 5 ];

Property DataDeNascimento As %Date [ Required, SqlColumnNumber = 6 ];

// cadastrar, atualizar, excluir, pegar idade, exibir

/// Pede nome, endereço, telefone, CPF e data de nascimento e cadastra através do método Cadastrar. Retorna valor de Status
ClassMethod ChamaCadastro() As %Status
{
	Set tSC = 0
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Nome................: ", tNome, ?70,                               "#"
	Hang .25
	Read !,  "# Endereço............: ", tEndereco, ?70,                           "#"
	Hang .25
	Read !,  "# Telefone............: ", tTelefone, ?70,                           "#"
	Hang .25
	Read !,  "# CPF.................: ", tCPF, ?70,                                "#"
	Hang .25
	Read !,  "# Data de Nascimento..: ", tDataDeNascimento, ?70,                   "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	
	// se todas as entradas forem vazias volta para Iniciar() 
	Set:(tNome_tEndereco_tTelefone_tCPF_tDataDeNascimento '= "") tSC = ##class(estagio.exemplos.Cliente).Cadastrar(tNome, tEndereco, tTelefone, tCPF, tDataDeNascimento)
	Quit tSC
}

/// Testa consistência para propriedades passadas como argumentos pelo método Consistencia e, se tudo estiver certo, salva
ClassMethod Cadastrar(pNome As %String, pEndereco As %String, pTelefone As %String, pCPF As %String, pDataDeNascimento As %String) As %Status
{

	Set tConsistencia = ##class(estagio.exemplos.Cliente).Consistencia(pNome, pEndereco, pTelefone, pCPF, pDataDeNascimento)
	If (tConsistencia["^") // consistência retorna as propriedades no formato Nome^Endereco^Telefone^CPF^DataDeNascimento se entradas forem válidas
	{
		Set tCliente = ##class(estagio.exemplos.Cliente).%New() // chama nova instancia 
		Set tCliente.Nome = $ZCONVERT($PIECE(tConsistencia, "^", 1), "W"), tCliente.Endereco = $PIECE(tConsistencia, "^", 2), tCliente.Telefone = $PIECE(tConsistencia, "^", 3), tCliente.CPF = $PIECE(tConsistencia, "^", 4), tCliente.DataDeNascimento = $PIECE(tConsistencia, "^", 5)
		Set tSC = tCliente.%Save() // guarda informações na forma mais simples, e nome com letra maiúscula
		If (tSC'=1) 
		{
			Write !, $System.Status.DisplayError(tSC) // a consistencia já garante que nunca vai cair aqui
		}
		Else
		{	
			Write !, " Cliente cadastrado com sucesso:"
			Do tCliente.ExibirUm() // se o cadastro ocorreu com sucesso, mostra as informações no formato de display definido na classe
		}
	}
	Else
	{
		Write !, tConsistencia // Mostra quais dados foram inválidos
		Write !, " Dados não cadastrados."
		Set tSC = 0
		Hang 1
	}
	
	Quit tSC
}

/// Testa se os valores passados como argumentos podem ser usados como propriedades
ClassMethod Consistencia(pNome As %String, pEndereco As %String, pTelefone As %String, pCPF As %String, pDataDeNascimento As %String) As %String
{
		Set tOutput = "" // mensagens de erros serão concatenadas aqui 
		Set tPropriedades = $LISTBUILD() // propriedades válidas serão listadas aqui
		If (pNome'="")&&(pEndereco'="")
		{
			Set $LIST(tPropriedades, 1) = pNome
			Set $LIST(tPropriedades, 2) = pEndereco
		}
		Else
		{	
			Write !, "A - Nome ou Endereço inválidos"
			Set tOutput = tOutput_"A"
		}
	
		Set pTelefone = $Translate($Get(pTelefone), " -()", "") // retira caracteres de formatação
		If (pTelefone?11N)
		{
			Set $LIST(tPropriedades, 3) = pTelefone
		}
		Else
		{
			Write !, "B - Telefone inválido"
			Set tOutput = tOutput_"B"
		}
		
		
		Set pCPF = $Translate($Get(pCPF), " .-", "") // retira caracteres de formatação
		If (pCPF?11N)
		{
			Set $LIST(tPropriedades, 4) = pCPF
		}
		Else
		{ 
			Write !, "C - CPF inválido"
			Set tOutput = tOutput_"C"
		}
		
		Try
		{
			Set pDataDeNascimento = $ZDATEH(pDataDeNascimento, 4)
			If (pDataDeNascimento > $HOROLOG) // verifica se é data válida e do passado
			{
				Set tOutput = tOutput_"D"
			}
				
			Set $LIST(tPropriedades, 5) = pDataDeNascimento
		}
		Catch
		{
			Write !, "D - Data de Nascimento inválida"
			Set tOutput = tOutput_"D"
		}
		
		Set:(tOutput="") tOutput = $LISTTOSTRING(tPropriedades, "^") // se nenhum erro foi concatenado, o output se torna a lista de propriedades
		Quit tOutput // output no formato Nome^Endereco^Telefone^CPF^DataDeNascimento
}

/// Pergunta como o usuário quer escolher os dados que serão exibidos
ClassMethod ChamaExibir()
{
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Exibir todos", "Pesquisar por ID", "Pesquisar por nome", "Pesquisar por CPF", "Pesquisar por idade")
	Hang .25
	
	Do:tNum ##class(estagio.exemplos.Cliente).Exibir(tNum)
	Quit
}

/// Exibe as linhas com base na pesquisa, e pode perguntar se quer expandir os dados de algum ID. 
ClassMethod Exibir(pTipo As %Integer = 1, pExpandir As %Boolean = 1)
{
	If (pTipo'=1)
	{
		Write !!, "Digite o ", $Case(pTipo, 2:"ID", 3:"Nome", 4:"CPF", 5:"Idade"), ": "
		Read tSearch
		Set:(pTipo=3) tSearch = "%"_tSearch_"%" // query por nome non case-sensitive
	}
	If (pTipo=5)
	{
		Read !, " Ver quais resultados? (>/</=) ", tString // define se a querty mostra clientes acima abaixo ou igual à idade escolhida pelo usuário
		Set:(">=<="[tString) tString = " WHERE DATEDIFF(dy,DataDeNascimento,CURRENT_DATE)\365"_tString // será passado na condição 
	}
	// mudar para abaixo/acima da idade especificada
	// pesquisar por parte do nome/CPF
	Write !!, "   |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	Set tQuery = "SELECT ID, Nome, Endereco, Telefone, CPF, DataDeNascimento FROM estagio_exemplos.Cliente"
	Set tCondition = $Case(pTipo, 1:"", 2:" WHERE ID = ?", 3:" WHERE Nome LIKE ?", 4:" WHERE CPF[?", 5:tString_"?") // filtro selecionado no ChamaExibir()
	Set tQuery = tQuery_tCondition
 	Set tStatement = ##class(%SQL.Statement).%New()
 	Set tStatus = tStatement.%Prepare(tQuery)
	Set trset = $CASE(pTipo, 1:tStatement.%Execute(), :tStatement.%Execute(tSearch)) // se não houve pesquisa, não precisa passar parâmetro
	
	
	While (trset.%Next()) // itera por todas as linhas que passam no filtro do usuário e escreve
	{
		Set tCliente = ##class(estagio.exemplos.Cliente).%OpenId(trset.%Get("ID"))
		Set tNome = tCliente.Nome, tEndereco = tCliente.Endereco, tTelefone = tCliente.Telefone, tCPF = tCliente.CPF
		// arruma as saidas
		If $LENGTH(tNome) > 11 {  // trunca nomes longos demais para a tabela
			Set $Extract(tNome,8, *) = "..."
		}
		If $LENGTH(tEndereco) > 19 { // trunca endereços longos demais para a tabela
			Set $Extract(tEndereco,16, *) = "..."
		}
		Set tTelefone = "("_$Extract(tTelefone, 1,2)_") "_$Extract(tTelefone, 3,7)_"-"_$Extract(tTelefone, 8,11) // (nn) nnnnn-nnnn
		Set tCPF = $Extract(tCPF,1,3)_"."_$Extract(tCPF,4,6)_"."_$Extract(tCPF,7,9)_"-"_$Extract(tCPF,10,11) // nnn.nnn.nnn-nn
		// escreve
		Write !, tCliente.%Id(), ?4, tNome, ?15, tEndereco, ?35, tTelefone, ?52, tCPF, ?68, $ZDATE(tCliente.DataDeNascimento,4) //[d]d/[m]m/[aa]aa
	}
	
	If pExpandir
	{
		Read !, " Para expandir informações de algum cliente, digite o ID: ", tAns
		Hang .25
		If (tAns '= "")
		{
			Set tClienteExp = ##class(estagio.exemplos.Cliente).%OpenId(tAns)
			If (tClienteExp="")
			{
				Write ! // ID inválido escreve linha em branco
			}
			Else
			{
				Do tClienteExp.ExibirUm()
			}
		}
	}
	
	Quit
}

/// Pergunta qual Cliente quer alterar e recebe novos dados - se deixados em branco não serão alterados.
ClassMethod ChamaAtualiza()
{
	Set tID = ##class(estagio.exemplos.Pedido).ProcurarNome("C") // garante que o ID selecionado é válido - escolhe pelo nome
		
		
	Hang .25
	Read !,  "# Nome................: ", tNome, ?70,                               "#"
	Hang .25
	Read !,  "# Endereço............: ", tEndereco, ?70,                           "#"
	Hang .25
	Read !,  "# Telefone............: ", tTelefone, ?70,                           "#"
	Hang .25
	Read !,  "# CPF.................: ", tCPF, ?70,                                "#"
	Hang .25
	Read !,  "# Data de Nascimento..: ", tDataDeNascimento, ?70,                   "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	
	Set:(tID'=0) tCliente = ##class(estagio.exemplos.Cliente).%OpenId(tID) // instancia o cliente escolhido para alterar suas propriedades
	
	
	Do:(tCliente'="") tCliente.Atualizar(tNome, tEndereco, tTelefone, tCPF, tDataDeNascimento) // chama atualização somente se o id selecionado é válido 
	Quit
}

/// Altera os dados que forem passados como argumentos
Method Atualizar(pNome As %String, pEndereco As %String, pTelefone As %String, pCPF As %String, pDataDeNascimento As %String) As %Status
{
	
	Set tNome = ..Nome, tEndereco = ..Endereco, tTelefone = ..Telefone, tCPF = ..CPF, tDDN = ..DataDeNascimento // variáveis temporárias guardam as propriedades da instância
	
	// altera argumentos não nulos
	Set:(pNome'="") tNome = pNome
	Set:(pEndereco'="") tEndereco = pEndereco
	Set:(pTelefone'="") tTelefone = pTelefone
	Set:(pCPF'="") tCPF = pCPF
	Set:(pDataDeNascimento'="") tDDN = $ZDATEH(pDataDeNascimento, 4)
	
	// checa consistencia e salva igual no cadastro
	Set tConsistencia = ##class(estagio.exemplos.Cliente).Consistencia(tNome, tEndereco, tTelefone, tCPF, $ZDATE(tDDN, 4))
	If (tConsistencia["^") // consistência retorna as propriedades no formato Nome^Endereco^Telefone^CPF^DataDeNascimento se entradas forem válidas
	{
		Set ..Nome = $ZCONVERT(tNome, "w"), ..Endereco = tEndereco, ..Telefone = tTelefone, ..CPF = tCPF, ..DataDeNascimento = tDDN
		
		Set tSC = ..%Save() // guarda informações na forma mais simples, e nome com letra maiúscula
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
	Else
	{	
		Write !, tConsistencia // Mostra quais dados foram inválidos
		Write !, " Dados inválidos" 
		Set tSC = 0
	}
	Quit tSC
}

/// Exibe propriedades da instância
Method ExibirUm()
{
	Hang .5
	// para arrumar saidas:
	Set tTelefone = ..Telefone, tCPF = ..CPF // variáveis temporárias com as infos das propriedades da instância
	Set tTelefone = "("_$Extract(tTelefone, 1,2)_") "_$Extract(tTelefone, 3,7)_"-"_$Extract(tTelefone, 8,11) // (nn) nnnnn-nnnn
	Set tCPF = $Extract(tCPF,1,3)_"."_$Extract(tCPF,4,6)_"."_$Extract(tCPF,7,9)_"-"_$Extract(tCPF,10,11) // nnn.nnn.nnn-nn
	
	Write !,  "#######################################################################"
	Write !,  "#", ?70,                                                             "#"
	Write !,  "# ID..................: ", ..%Id(), ?70,                             "#"
	Write !,  "# Nome................: ", ..Nome, ?70,                              "#"
	Write !,  "# Endereço............: ", ..Endereco, ?70,                          "#" 
	Write !,  "# Telefone............: ", tTelefone, ?70,                           "#"
	Write !,  "# CPF.................: ", tCPF, ?70,                                "#"
	Write !,  "# Data de Nascimento..: ", $ZDATE(..DataDeNascimento, 4), ?70,       "#" // [d]d/[m]m/[aa]aa
	Write !,  "#", ?70,                                                             "#"
	Write !,  "#######################################################################"
	
	Read !, tEnter // espera interação para seguir

	Quit
}

/// Calcula a idade do cliente instanciado
Method PegarIdade() As %Decimal
{
	Set tIdade = (+$HOROLOG - ..DataDeNascimento)/365 
	Quit tIdade // retorna idade em anos
}

Storage Default
{
<Data name="ClienteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nome</Value>
</Value>
<Value name="3">
<Value>Endereco</Value>
</Value>
<Value name="4">
<Value>Telefone</Value>
</Value>
<Value name="5">
<Value>CPF</Value>
</Value>
<Value name="6">
<Value>DataDeNascimento</Value>
</Value>
</Data>
<DataLocation>^estagio.exemplos.ClienteD</DataLocation>
<DefaultData>ClienteDefaultData</DefaultData>
<ExtentSize>3</ExtentSize>
<IdLocation>^estagio.exemplos.ClienteD</IdLocation>
<IndexLocation>^estagio.exemplos.ClienteI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="CPF">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DataDeNascimento">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Endereco">
<AverageFieldSize>26.33</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Nome">
<AverageFieldSize>16.33</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Telefone">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.exemplos.ClienteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
