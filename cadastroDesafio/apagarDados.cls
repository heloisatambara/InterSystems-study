apagarDados

inicio
	NEW hora, num
 // Cabeçalho
	// Set tralha = "#######################################################################"
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70,                                       "#"
	Write !, "#", ?30, "Apagar Dados", ?70,                  "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
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
 //	
	Quit:'num
	Do $Case(num, 1:deletarCliente, 2:deletarProduto, 3:deletarPedido, :inicio)
	GOTO inicio
	Quit


deletarCliente()
 // Exibe os clientes e pergunta qual apagar
    Hang .25
    Do exibirTudo^exibirClientes
    Hang .25
   
    Write !!, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    IF 'num { Write !, "#", ?70, "#", !, tralha Quit}
  	If '$Data(^cliente(num)) { Write !, "# ID inválido", ?70, "#", !, tralha Hang .5 GOTO deletarCliente+1}
 // Exibe o selecionado e pergunta se tem certeza
	Do exibirPorID^exibirClientes(num)
	Write !, tralha
			   
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	Kill ^cliente(num)
   		Write !, " Dados apagados."
   	}
   	Else { Write !, " Operação cancelada." }
   	
	Hang 1
    Do exibirTudo^exibirClientes
    Hang .5
    
    Quit


deletarProduto()
 // Exibe os produtos e pergunta qual apagar
    Hang .25
    Do exibirTudo^exibirProdutos
    Hang .25
   
    Write !!, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    IF 'num { Write !, "#", ?70, "#", !, tralha Quit}
  	If '$Data(^produto(num)) { Write !, "# ID inválido", ?70, "#", !, tralha Hang .5 GOTO deletarProduto+1}
 // Exibe o selecionado e pergunta se tem certeza
	Do exibirPorID^exibirProdutos(num)
	Write !, tralha 
		
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	Kill ^produto(num)
   		Write !, " Dados apagados."
   	}
   	Else { Write !, " Operação cancelada." }
   	
	Hang 1
    Do exibirTudo^exibirProdutos
    Hang .5
    
    Quit
    
    
deletarPedido()
 // Exibe os produtos e pergunta qual apagar
    Hang .25
    Do exibirTudo^exibirPedidos
    Hang .25
   
    Write !!, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    IF 'num { Write !, "#", ?70, "#", !, tralha Quit}
  	If '$Data(^pedido(num)) { Write !, "# ID inválido", ?70, "#", !, tralha Hang .5 GOTO deletarPedido+1}
 // Exibe o selecionado e pergunta se tem certeza
	Do exibirPorID^exibirPedidos(num)
	Write !, tralha
	  
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	Kill ^pedido(num)
   		Write !, " Dados apagados."
   	}
   	Else { Write !, " Operação cancelada." }
   	
	Hang 1
    Do exibirTudo^exibirPedidos
    Hang .5
    
    Quit
