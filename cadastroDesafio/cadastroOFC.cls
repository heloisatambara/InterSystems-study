cadastroOFC

inicio
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
	Write !, "#", " 4- Exibir Clientes", ?70,                "#"
	Write !, "#", " 5- Exibir Produtos", ?70,                "#"
	Write !, "#", " 6- Exibir Pedidos", ?70,                 "#"
	Write !, "#", " 0- Sair", ?70,                           "#"
	Write !, "#", ?70,                                       "#"
	
	Read !, "# Entre com a opção desejada: ", num Write ?70, "#"
	
	Write !, "#", ?70,                                       "#"
	Write !, tralha

	Hang .25
 //	
 
	
	Set:'num $Halt = "sairHalt^cadastroOFC"
	Halt:'num
	Do $Case(num, 1:cadastrarCliente, 2:cadastrarProduto, 3:realizarPedido, 4:exibirClientes, 5:exibirProdutos, 6:exibirPedidos, :inicio)
	
	Quit
	
	
 // chamadas das rotinas ou do halt
cadastrarCliente
	Do ^cadastrarCliente
	GOTO inicio
	Quit
	
cadastrarProduto
	Do ^cadastrarProduto
	GOTO inicio
	Quit
	
realizarPedido
	Do ^realizarPedido
	GOTO inicio
	Quit


exibirClientes
	Do ^exibirClientes
	GOTO inicio
	Quit
	
exibirProdutos
	Do ^exibirProdutos
	GOTO inicio
	Quit
	
exibirPedidos
	Do ^exibirPedidos
	GOTO inicio
	Quit



sairHalt
	Read !!, "Tem certeza que deseja sair? ", ans
	If "SIMsimSim"[ans { Write !, "Ok" Hang .25 HALT }
	Else { GOTO inicio }
	Quit
