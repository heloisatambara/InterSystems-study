Class estagio.exemplos.Cadastro Extends %Persistent
{

// TODO: 

// arrumar SQL injection - exibir e atualizar

// colocar /// nas funcoes

// comentar codigo

// fazer Query

// deixar cadastro como abstract? fazer as outras serem extend de cadastro? - tralha como parametro

// quebrar linha quando passar de 70 caracteres?

// Observações:

// // aqui não é necessário usar o "NEW": as variaveis dentro de cada método ficam definidas só enquanto o método roda

// // guardar a informação da forma mais simples possível e interpretar de maneira legivel somente na hora de exibir

/// Teste - início do cadastro - HTML
ClassMethod Iniciar()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Solicitação de Pedido")
	Write !, "#", " Menu", ?70,                                                    "#"
	Write !, "#", " 1- Cadastrar dados", ?70,                                      "#"
	Write !, "#", " 2- Exibir dados", ?70,                                         "#"
	Write !, "#", " 3- Atualizar dados", ?70,                                      "#"
	Write !, "#", " 4- Apagar dados", ?70,                                         "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum Write ?70,                     "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"

	Hang .25
	// Ver como funciona halt aqui
	// Set:'num $Halt = "sairHalt^cadastroOFC"
	Do $Case(tNum, 1:##class(estagio.exemplos.Cadastro).CadastrarMenu(), 2:##class(estagio.exemplos.Cadastro).ExibirMenu(), 3:##class(estagio.exemplos.Cadastro).AtualizarMenu(), 4:##class(estagio.exemplos.Cadastro).ExcluirMenu(), :##class(estagio.exemplos.Cadastro).Sair())
	Do ##class(estagio.exemplos.Cadastro).Iniciar()
	Quit
}

ClassMethod CadastrarMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Cadastrar")
	Write !, "#", " Menu", ?70,                                                    "#"
	Write !, "#", " 1- Cadastrar clientes", ?70,                                   "#"
	Write !, "#", " 2- Cadastrar produtos",?70,                                    "#"
	Write !, "#", " 3- Cadastrar pedidos", ?70,                                    "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum Write ?70,                     "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaCadastro(), 2:##class(estagio.exemplos.Produto).ChamaCadastro(), 3:##class(estagio.exemplos.Pedido).ChamaCadastro(), :##class(estagio.exemplos.Cadastro).Iniciar()) 
	Quit
}

ClassMethod ExibirMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Exibir Dados")
	Write !, "#", " Menu", ?70,                                                    "#"
	Write !, "#", " 1- Exibir dados de clientes", ?70,                             "#"
	Write !, "#", " 2- Exibir dados de produtos",?70,                              "#"
	Write !, "#", " 3- Exibir dados de pedidos", ?70,                              "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum Write ?70,                     "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaExibir(), 2:##class(estagio.exemplos.Produto).ChamaExibir(), 3:##class(estagio.exemplos.Pedido).ChamaExibir(), :##class(estagio.exemplos.Cadastro).Iniciar()) 
	Quit
}

ClassMethod AtualizarMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Atualizar Dados")
	Write !, "#", " Menu", ?70,                                                    "#"
	Write !, "#", " 1- Atualizar dados de clientes", ?70,                          "#"
	Write !, "#", " 2- Atualizar dados de produtos",?70,                           "#"
	Write !, "#", " 3- Atualizar dados de pedidos", ?70,                           "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum Write ?70,                     "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaAtualiza(), 2:##class(estagio.exemplos.Produto).ChamaAtualiza(), 3:##class(estagio.exemplos.Pedido).ChamaAtualiza(), :##class(estagio.exemplos.Cadastro).Iniciar()) 
	Quit
}

ClassMethod ExcluirMenu()
{
	Do ##class(estagio.exemplos.Cadastro).Cabecalho("Excluir Dados")
	Write !, "#", " Menu", ?70,                                                    "#"
	Write !, "#", " 1- Excluir dados de clientes", ?70,                            "#"
	Write !, "#", " 2- Excluir dados de produtos",?70,                             "#"
	Write !, "#", " 3- Excluir dados de pedidos", ?70,                             "#"
	Write !, "#", " 0- Sair", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Read !,  "# Entre com a opção desejada: ", tNum Write ?70,                     "#"
	Hang .25
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"

	Do $Case(tNum, 1:##class(estagio.exemplos.Cliente).ChamaApagar(), 2:##class(estagio.exemplos.Produto).ChamaApagar(), 3:##class(estagio.exemplos.Pedido).ChamaApagar(), :##class(estagio.exemplos.Cadastro).Iniciar()) // arrumar
	Quit
}

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
		Quit
	}
}

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
