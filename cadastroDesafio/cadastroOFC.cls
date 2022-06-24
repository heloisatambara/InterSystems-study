cadastroOFC

Inicio
	NEW hora, num
 // cabeçalho
	Set tralha = "#######################################################################"
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!!, tralha
	Write !, "#", ?70,                                       "#"
	Write !, "#", ?25 ,"Solicitação de Pedido", ?70,         "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", " Menu", ?70,                              "#"
	Write !, "#", " 1- Cadastrar Cliente", ?70,              "#"
	Write !, "#", " 2- Cadastrar Produto",?70,               "#"
	Write !, "#", " 3- Realizar Pedido", ?70,                "#"
	Write !, "#", " 4- Exibir dados", ?70,                   "#"
	Write !, "#", " 5- Atualizar dados", ?70,                "#"
	Write !, "#", " 6- Apagar dados", ?70,                   "#"
	Write !, "#", " 0- Sair", ?70,                           "#"
	Write !, "#", ?70,                                       "#"
	
	Read !, "# Entre com a opção desejada: ", num Write ?70, "#"
	
	Write !, "#", ?70,                                       "#"
	Write !, tralha

	Hang .25
 //	
 
	
	Set:'num $Halt = "sairHalt^cadastroOFC"
	Halt:'num
	Do $Case(num, 1:cadastrarCliente, 2:cadastrarProduto, 3:realizarPedido, 4:exibirDados, 5:atualizarDados,6:apagarDados, :Inicio)
	
	Quit
	
	
 // chamadas das rotinas ou do halt
cadastrarCliente
	Do ^cadastrarCliente
	GOTO Inicio
	Quit
	
cadastrarProduto
	Do ^cadastrarProduto
	GOTO Inicio
	Quit
	
realizarPedido
	Do ^realizarPedido
	GOTO Inicio
	Quit

exibirDados
	NEW hora, num
 // cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!!, tralha
	Write !, "#", ?70,                                       "#"
	Write !, "#", ?25 ,"Solicitação de Pedido", ?70,         "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", " Menu", ?70,                              "#"
	Write !, "#", " 1- Exibir dados de clientes", ?70,       "#"
	Write !, "#", " 2- Exibir dados de produtos",?70,        "#"
	Write !, "#", " 3- Exibir dados de pedidos", ?70,        "#"
	Write !, "#", " 0- Sair", ?70,                           "#"
	Write !, "#", ?70,                                       "#"
	
	Read !, "# Entre com a opção desejada: ", num Write ?70, "#"
	
	Write !, "#", ?70,                                       "#"
	Write !, tralha
	
	
	Do $Case(num, 1:exibirClientes, 2:exibirProdutos, 3:exibirPedidos, :Inicio)
	Quit
	
exibirClientes
	Do ^exibirClientes
	GOTO Inicio
	Quit
	
exibirProdutos
	Do ^exibirProdutos
	GOTO Inicio
	Quit
	
exibirPedidos
	Do ^exibirPedidos
	GOTO Inicio
	Quit



atualizarDados
	Do ^atualizarDados
	GOTO Inicio
	Quit


apagarDados
	Do ^apagarDados
	GOTO Inicio
	Quit


sairHalt
	NEW ans
	Read !!, "Tem certeza que deseja sair? ", ans
	If "SIMsimSim"[ans { Write !, "Ok" Hang .25 HALT }
	Else { GOTO Inicio }
	Quit
