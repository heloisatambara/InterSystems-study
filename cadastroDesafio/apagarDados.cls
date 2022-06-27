apagarDados

inicio
	NEW num
	Do cabecalho^cadastroOFC("Apagar Dados")
	Write !, "#", ?70,                                       "#"
	Write !, "#", " 1- Deletar dados de cliente", ?70,       "#"
	Write !, "#", " 2- Deletar dados de produto", ?70,       "#"
	Write !, "#", " 3- Deletar dados de pedido", ?70,        "#"
	Write !, "#", " 0- Sair", ?70,                           "#"
	Write !, "#", ?70,                                       "#"
	Read !, "# Entre com a opção desejada: ", num Write ?70, "#"
	Write !, "#", ?70,                                       "#"
	Write !, tralha
	Hang .25
 
	Quit:'num
	Do $Case(num, 1:deletar("Clientes"), 2:deletar("Produtos"), 3:deletar("Pedidos"), :inicio)
	GOTO inicio
	Quit
    
deletar(CPP) // Cliente, Produto ou Pedido 
	NEW exibirTudo, exibirPorID, aux, num, ans
	Set exibirTudo = "exibirTudo^exibir"_CPP // escolhe se vai exibir de Cliente, Produto ou Pedido (CPP)
	
    // Exibe os clientes e pergunta qual apagar
    Hang .25
    Do @exibirTudo
    Hang .25
   
    Write !!, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    IF 'num { Write !, "#", ?70, "#", !, tralha Quit}
    Set exibirPorID = $Case(CPP, "Clientes":"exibirPorID^exibirClientes(num)", "Produtos":"exibirPorID^exibirProdutos(num)", "Pedidos":"exibirPorID^exibirPedidos(num)")
    Set bool = $Case(CPP, "Clientes":$DATA(^cliente(num)), "Produtos":$DATA(^produto(num)), "Pedidos":$DATA(^pedido(num)))
  	If 'bool { Write !, "# ID inválido", ?70, "#", !, tralha Hang .5 Quit}
  	
    // Exibe o selecionado e pergunta se tem certeza
	Do @exibirPorID
	Write !, tralha
			   
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	If CPP="Clientes" {Kill ^cliente(num)}
	   	If CPP="Produtos" {Kill ^produto(num)}
	   	IF CPP="Pedidos"  {Kill ^pedido(num) }
   		Write !, " Dados apagados."}
   	Else { Write !, " Operação cancelada." }
   	
	Hang 1
    Do @exibirTudo
    Hang .5
    Quit
