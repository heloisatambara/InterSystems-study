Class estagio.exemplos.Cliente Extends Cadastro
{

Relationship PedidoCliente As estagio.exemplos.Pedido [ Cardinality = many, Inverse = Cliente ];

// Index PedidoClienteIndex On PedidoCliente;

Property Nome As %String [ Required, SqlColumnNumber = 2 ];

Property Endereco As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

Property Telefone As %Integer [ Required, SqlColumnNumber = 4 ];

Property CPF As %Integer [ Required, SqlColumnNumber = 5 ];

Property DataDeNascimento As %Date [ Required, SqlColumnNumber = 6 ];

// cadastrar, atualizar, excluir, pegar idade, exibir

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
	
	Set:(tNome_tEndereco_tTelefone_tCPF_tDataDeNascimento '= "") tSC = ##class(estagio.exemplos.Cliente).Cadastrar(tNome, tEndereco, tTelefone, tCPF, tDataDeNascimento)
	Quit tSC
}

ClassMethod Cadastrar(pNome As %String, pEndereco As %String, pTelefone As %String, pCPF As %String, pDataDeNascimento As %String) As %Status
{

	Set tConsistencia = ##class(estagio.exemplos.Cliente).Consistencia(pNome, pEndereco, pTelefone, pCPF, pDataDeNascimento)
	If (tConsistencia["^")
	{
		Set tCliente = ##class(estagio.exemplos.Cliente).%New() // chama nova instancia 
		Set tCliente.Nome = $PIECE(tConsistencia, "^", 1), tCliente.Endereco = $PIECE(tConsistencia, "^", 2), tCliente.Telefone = $PIECE(tConsistencia, "^", 3), tCliente.CPF = $PIECE(tConsistencia, "^", 4), tCliente.DataDeNascimento = $PIECE(tConsistencia, "^", 5)
		Set tSC = tCliente.%Save()
		If (tSC'=1) 
		{
			Write !, $System.Status.DisplayError(tSC)
		}
		Else
		{	
			Write !, " Cliente cadastrado com sucesso:"
			Do tCliente.ExibirUm()	
		}
	}
	Else
	{
		Write !, tConsistencia
		Write !, " Dados não cadastrados."
		Set tSC = 0
		Hang 1
	}
	
	Quit tSC
}

ClassMethod Consistencia(pNome As %String, pEndereco As %String, pTelefone As %String, pCPF As %String, pDataDeNascimento As %String) As %String
{
		Set tOutput = ""
		Set tPropriedades = $LISTBUILD()
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
	
		Set pTelefone = $Translate($Get(pTelefone), " -()", "")
		If (pTelefone?11N)
		{
			Set $LIST(tPropriedades, 3) = pTelefone
		}
		Else
		{
			Write !, "B - Telefone inválido"
			Set tOutput = tOutput_"B"
		}
		
		
		Set pCPF = $Translate($Get(pCPF), " .-", "")
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
			If (pDataDeNascimento > $HOROLOG)
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
		
		Set:(tOutput="") tOutput = $LISTTOSTRING(tPropriedades, "^")
		Quit tOutput
}

ClassMethod ChamaExibir()
{
	Write !, "#", ?70,                                                             "#"
	Write !, "#", " 1- Exibir todos", ?70,                                         "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,                                     "#"
	Write !, "#", " 3- Pesquisar por nome", ?70,                                   "#"
	Write !, "#", " 4- Pesquisar por CPF", ?70,                                    "#"
	Write !, "#", " 5- Pesquisar por idade", ?70,                                  "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum, ?70,                          "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"
	Hang .25
	
	Do:tNum ##class(estagio.exemplos.Cliente).Exibir(tNum)
	Quit
}

ClassMethod Exibir(pTipo As %Integer = 1, pExpandir As %Boolean = 1) As %Integer
{
 // SQL Injection!
	If (pTipo'=1)
	{
		Write !!, "Digite o ", $Case(pTipo, 2:"ID", 3:"Nome", 4:"CPF", 5:">/</=Idade"), ": "
		Read tSearch
		Hang .25
	}
	// mudar para abaixo/acima da idade especificada
	// pesquisar por parte do nome/CPF
	Write !!, "   |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	Set tQuery = "SELECT ID, Nome, Endereco, Telefone, CPF, DataDeNascimento FROM estagio_exemplos.Cliente"
	Set tCondition = $Case(pTipo, 1:"", 2:" WHERE ID='"_tSearch_"'", 3:" WHERE Nome LIKE '%"_tSearch_"%'", 4:" WHERE CPF["_tSearch_"", 5:" WHERE DATEDIFF(dy,DataDeNascimento,CURRENT_DATE)\365"_tSearch)
	Set tQuery = tQuery_tCondition
 	Set tStatement = ##class(%SQL.Statement).%New()
 	Set tStatus = tStatement.%Prepare(tQuery)
	Set trset = tStatement.%Execute()
	
	While (trset.%Next())
	{
		Set tCliente = ##class(estagio.exemplos.Cliente).%OpenId(trset.%Get("ID"))
		// arruma as saidas
		Set tNome = tCliente.Nome, tEndereco = tCliente.Endereco, tTelefone = tCliente.Telefone, tCPF = tCliente.CPF
		If $LENGTH(tNome) > 11 {
			Set $Extract(tNome,8, *) = "..."
		}
		If $LENGTH(tEndereco) > 19 {
			Set $Extract(tEndereco,16, *) = "..."
		}
		Set tTelefone = "("_$Extract(tTelefone, 1,2)_") "_$Extract(tTelefone, 3,7)_"-"_$Extract(tTelefone, 8,11)
		Set tCPF = $Extract(tCPF,1,3)_"."_$Extract(tCPF,4,6)_"."_$Extract(tCPF,7,9)_"-"_$Extract(tCPF,10,11)
		
		Write !, tCliente.%Id(), ?4, tNome, ?15, tEndereco, ?35, tTelefone, ?52, tCPF, ?68, $ZDATE(tCliente.DataDeNascimento,4)
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
				Write !
			}
			Else
			{
				Do tClienteExp.ExibirUm()
			}
		}
	}
	
	Quit
}

ClassMethod ChamaAtualiza()
{
	Set tID = ##class(estagio.exemplos.Pedido).ProcurarNome("C")
		
		
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
	
	Set:(tID'=0) tCliente = ##class(estagio.exemplos.Cliente).%OpenId(tID)
	
	
	Do:(tCliente'="") tCliente.Atualizar(tNome, tEndereco, tTelefone, tCPF, tDataDeNascimento)
	Quit
}

Method Atualizar(pNome As %String, pEndereco As %String, pTelefone As %String, pCPF As %String, pDataDeNascimento As %String) As %Status
{
	
	Set tNome = ..Nome, tEndereco = ..Endereco, tTelefone = ..Telefone, tCPF = ..CPF, tDDN = ..DataDeNascimento 
	
	Set:(pNome'="") tNome = pNome
	Set:(pEndereco'="") tEndereco = pEndereco
	Set:(pTelefone'="") tTelefone = pTelefone
	Set:(pCPF'="") tCPF = pCPF
	Set:(pDataDeNascimento'="") tDDN = $ZDATEH(pDataDeNascimento, 4)
		
	Set tConsistencia = ##class(estagio.exemplos.Cliente).Consistencia(tNome, tEndereco, tTelefone, tCPF, $ZDATE(tDDN, 4))
	If (tConsistencia["^")
	{
		Set ..Nome = tNome, ..Endereco = tEndereco, ..Telefone = tTelefone, ..CPF = tCPF, ..DataDeNascimento = tDDN
		
		Set tSC = ..%Save()
		If (tSC'=1) 
		{
			Set tSC = $System.Status.DisplayError(tSC)
		}
		Else
		{
			Write !!, "Dados atualizados:"
			Do ..ExibirUm()
		}
	}
	Else
	{	
		Write !, " Dados inválidos"
		Set tSC = 0
	}
	Quit tSC
}

Method ExibirUm(pQualInformacao As %Integer)
{
	If ('$DATA(pQualInformacao))
	{ 	
		Hang .5
		// para arrumar saidas:
		Set tTelefone = ..Telefone, tCPF = ..CPF
		Set tTelefone = "("_$Extract(tTelefone, 1,2)_") "_$Extract(tTelefone, 3,7)_"-"_$Extract(tTelefone, 8,11)
		Set tCPF = $Extract(tCPF,1,3)_"."_$Extract(tCPF,4,6)_"."_$Extract(tCPF,7,9)_"-"_$Extract(tCPF,10,11)
		
		Write !,  "#######################################################################"
		Write !,  "#", ?70,                                                             "#"
		Write !,  "# ID..................: ", ..%Id(), ?70,                             "#"
		Write !,  "# Nome................: ", ..Nome, ?70,                              "#"
		Write !,  "# Endereço............: ", ..Endereco, ?70,                          "#" 
		Write !,  "# Telefone............: ", tTelefone, ?70,                           "#"
		Write !,  "# CPF.................: ", tCPF, ?70,                                "#"
		Write !,  "# Data de Nascimento..: ", $ZDATE(..DataDeNascimento, 4), ?70,       "#"
		Write !,  "#", ?70,                                                             "#"
		Write !,  "#######################################################################"
		Read !, tEnter
	}
	ElseIf (pQualInformacao=1)
	{
		Write !, ..Nome
	}
	ElseIf (pQualInformacao=2)
	{	
		Write !, ..Endereco
	}
	ElseIf (pQualInformacao=3)
	{
		Write !, ..Telefone
	}
	ElseIf (pQualInformacao=4)
	{
		Write !, ..CPF
	}
	ElseIf (pQualInformacao=5)
	{
		Write !, $ZDATE(..DataDeNascimento, 4)
	}
	Quit
}

Method PegarIdade() As %Decimal
{
	Set tDataDeNascimento = ..DataDeNascimento
	Set tIdade = (+$HOROLOG - tDataDeNascimento)/365
	Quit tIdade
}

ClassMethod OREF(pIDCliente As %Integer) As %String
{
	Quit ##class(estagio.exemplos.Cliente).%OpenId(pIDCliente)
}

ClassMethod ChamaApagar()
{
	Do ##class(estagio.exemplos.Cliente).Exibir(,0)
	Read !!, "Deseja apagar quais dados? (0 apaga tudo) ", tNum
	Set tCliente = ##class(estagio.exemplos.Cliente).%OpenId(tNum)
	Do:(tNum'=0) tCliente.ExibirUm()
	
	Read !!, " Tem certeza? ", tAns
	
	If ("SimSIMsim"[tAns)
	{	
		Do:(tNum=0) ##class(estagio.exemplos.Cliente).%DeleteExtent()
		Do:(tNum'=0) ##class(estagio.exemplos.Cliente).%DeleteId(tNum)
		Write !, " Dados apagados."
		Hang .5
	}
	
	Read !, " Apagar mais algum? ", tAns
	If ("simSimSIM"[tAns)
	{
		Do ##class(estagio.exemplos.Cliente).ChamaApagar()
	}
	
	Quit
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
