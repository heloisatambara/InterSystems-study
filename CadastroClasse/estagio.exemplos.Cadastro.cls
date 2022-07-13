Class estagio.exemplos.Cadastro [ Abstract ]
{

// Observações:

// // aqui não é necessário usar o "NEW": as variaveis dentro de cada método ficam definidas só enquanto o método roda

// // guardar a informação da forma mais simples possível e interpretar de maneira legivel somente na hora de exibir

// // comentarios em /// aparecem na pagina HTML da classe

// Dúvidas:

// // É preferível definir como Query ou do jeito que eu to fazendo? Tem diferença?

/// Exibe menu inicial
ClassMethod Iniciar()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Solicitação de Pedido")
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Cadastrar dados", "Exibir dados", "Atualizar dados", "Apagar dados")


	Hang .25 // cada opção exibe um menu para escolher se a ação será em produtos, clientes ou pedidos
	Do $Case(tNum, 1:##class(estagio.exemplos.Cadastro).CadastrarMenu(), 2:##class(estagio.exemplos.Cadastro).ExibirMenu(), 3:##class(estagio.exemplos.Cadastro).AtualizarMenu(), 4:##class(estagio.exemplos.Cadastro).ExcluirMenu(), :##class(estagio.exemplos.Cadastro).Sair())
	Do ##class(estagio.exemplos.Cadastro).Iniciar() // Só sai quando chama halt
	Quit
}

/// Exibe menu de cadastro
ClassMethod CadastrarMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Cadastrar")
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Cadastrar clientes", "Cadastrar produtos", "Cadastrar pedidos")

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaCadastro(), 2:##class(estagio.exemplos.Produto).ChamaCadastro(), 3:##class(estagio.exemplos.Pedido).ChamaCadastro(), :##class(estagio.exemplos.Cadastro).Iniciar()) 
	Quit
}

/// Exibe menu de exibição
ClassMethod ExibirMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Exibir Dados")
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Exibir dados de clientes", "Exibir dados de produtos", "Exibir dados de pedidos")

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaExibir(), 2:##class(estagio.exemplos.Produto).ChamaExibir(), 3:##class(estagio.exemplos.Pedido).ChamaExibir(), :##class(estagio.exemplos.Cadastro).Iniciar()) 
	Quit
}

/// Exibe menu de atualização
ClassMethod AtualizarMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Atualizar Dados")
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Atualizar dados de clientes", "Atualizar dados de produtos", "Atualizar dados de pedidos")

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaAtualiza(), 2:##class(estagio.exemplos.Produto).ChamaAtualiza(), 3:##class(estagio.exemplos.Pedido).ChamaAtualiza(), :##class(estagio.exemplos.Cadastro).Iniciar()) 
	Quit
}

/// Exibe menu de exclusão
ClassMethod ExcluirMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Excluir Dados")
	Set tNum = ##class(estagio.exemplos.Cadastro).Menu("Excluir dados de clientes", "Excluir dados de produtos", "Excluir dados de pedidos")
	
	Do:(tNum=1)||(tNum=2)||(tNum=3) ##class(estagio.exemplos.Cadastro).ChamaApagar(tNum)
	//	Do $Case(tNum, 1:##class(estagio.exemplos.Cadastro).ChamaApagar(1), 2:##class(estagio.exemplos.Cadastro).ChamaApagar(2), 3:##class(estagio.exemplos.Pedido).ChamaApagar(), :##class(estagio.exemplos.Cadastro).Iniciar()) // arrumar
	Quit
}

/// Apaga tudo ou o objeto escolhido por ID.
ClassMethod ChamaApagar(pClasse As %Integer)
{
	Set tAux = pClasse
	Set pClasse = $CASE(pClasse, 1:##class(estagio.exemplos.Cliente).%New(), 2:##class(estagio.exemplos.Produto).%New(), 3:##class(estagio.exemplos.Pedido).%New())
	Do pClasse.Exibir(,0) // exibe todos os produtos (sem opção de expandir)
	Read !!, " Deseja apagar quais dados? (0 apaga  tudo) ", tNum
	Set tObjeto = pClasse.%OpenId(tNum)
	Do:(tObjeto'="") tObjeto.ExibirUm() // se for digitado ID válido, mostra o produto que pediu para apagar
	
	Read !!, " Tem certeza? ", tAns
	
	If ("SimSIMsim"[tAns)
	{	// se usuário confirma, apaga o ID selecionado ou o extent
		If (tNum = 0)
		{
			Do pClasse.%DeleteExtent()
			Write !, " Todos os dados apagados."
		}   
		Else
		{	
			Do pClasse.%DeleteId(tNum)
			Write !, " Dados apagados."
		}
		Read !, " Apagar mais algum? ", tAns
		If ("simSimSIM"[tAns)
		{
			Do ##class(estagio.exemplos.Cadastro).ChamaApagar(tAux) // começa de novo para apagar mais
		}		
	}
	Quit
}

/// Exibe halt
ClassMethod Sair()
{
	Read !, " Tem certeza que deseja sair? ", tAns
	Hang .25
	If ("SimSIMsim"[tAns)
	{
		Halt	
	}
	Else
	{
		Quit // volta para Iniciar()
	}
}

/// Exibe cabeçalho com título (passado por parâmetro) e horário
ClassMethod Cabecalho(pTitulo As %String)
{
	Set tHora = $Zdatetime($Horolog, 4, 2)
	
	Write !!!, "#######################################################################"
	Write !,   "#", ?70,                                                             "#"
	Write !,   "#", ?(35-($LENGTH(pTitulo)/2)) ,pTitulo, ?70,                        "#"
	Write !,   "#", $Justify(tHora_" #", 70)
	Write !,   "#######################################################################"
	Quit
}

/// Exibe Menu com opções para escolha e retorna a escolha.
ClassMethod Menu(pOpcao... As %String) As %Integer
{
	Set args = $GET(pOpcao, 0)
	Set tCount = 0
	Write !,   "#", " Menu", ?70,                                                    "#"
	Write !,   "#", ?70,                                                             "#"
	For i = 1:1:args
	{	
		Write !, "# "_$INCREMENT(tCount)_"- "_pOpcao(i), ?70,                        "#"
	}
	Write !,   "#", " 0- Sair", ?70,                                                 "#"
	Write !,   "#", ?70,                                                             "#"
	
	Read !,    "# Entre com a opção desejada: ", tNum
	
	Write ?70,                                                                       "#"
	Write !,   "#", ?70,                                                             "#"
	Write !,   "#######################################################################"
	
	Quit tNum
}

Storage Default
{
<Data name="CadastroDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^estagio.exemplos.CadastroD</DataLocation>
<DefaultData>CadastroDefaultData</DefaultData>
<ExtentSize>17</ExtentSize>
<IdLocation>^estagio.exemplos.CadastroD</IdLocation>
<IndexLocation>^estagio.exemplos.CadastroI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>28</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("~estagio.exemplos.Cliente~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~","~estagio.exemplos.Produto~"),$lb(18,27,27,27,27,27,27,27,27,27,27,27,27,27,27),$lb(2120577908,1131178341,1349676900,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2120577908))</Histogram>
<OutlierSelectivity>.941176:"~estagio.exemplos.Produto~"</OutlierSelectivity>
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("1","3","7","12","13","14","15","16","17","18","29","30","31","32","33","42"),$lb(0,0,0,1,1,1,1,1,1,0,0,1,1,1,0),$lb(822083584,822083584,855638016,855638016,922746880,922746880,825360384,838860800,855638016,855638016,872415232,872415232,889192448,889192448,905969664,905969664,922746880,922746880,939524096,825753600,842596352,842596352,858783744,805306368,822083584,822083584,838860800,838860800,855638016,858980352,875692032,875692032))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.exemplos.CadastroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

