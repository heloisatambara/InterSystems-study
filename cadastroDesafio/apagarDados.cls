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

deletarCliente()
 // Exibe os clientes e pergunta qual apagar
    Hang .25
    Do todos^exibirClientes
    Hang .25
   
    Write !, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    Write !, "#", ?70, "#"
    Write !, tralha
    
    GOTO:'num inicio+1
  	If '$Data(^cliente(num)) { Write !, "ID inválido" Hang .5 GOTO deletarCliente+1}
  	
 // Exibe o selecionado e pergunta se tem certeza
 	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	Set nome = $Piece(^cliente(num), "^", 1)
	Set end = $Piece(^cliente(num), "^", 2)
	If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
	If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
	Write !, num, ?2, nome, ?13, end, ?33, $Piece(^cliente(num), "^", 3), ?50, $Piece(^cliente(num), "^", 4), ?66, $Piece(^cliente(num), "^", 5)
	   
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	Kill ^cliente(num)
   		Write !, " Dados apagados."
   	}
   	Else { Write !, " Operação cancelada." }
   	
	Hang .5
    Do todos^exibirClientes
    Hang .25
    
    Quit


deletarProduto()
 // Exibe os produtos e pergunta qual apagar
    Hang .25
    Do todos^exibirProdutos
    Hang .25
   
    Write !, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    Write !, "#", ?70, "#"
    Write !, tralha
    
    GOTO:'num inicio+1
  	If '$Data(^produto(num)) { Write !, "ID inválido" Hang .5 GOTO deletarProduto+1}
 // Exibe o selecionado e pergunta se tem certeza
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)

   // arruma tamanhos de strings
	Set nome = $Piece(^produto(num), "^", 1)
	Set desc = $Piece(^produto(num), "^", 2)
	If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
	If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}

   // mostra informações do cliente selecionado
	Write !, "Produto "_num_": "
		Write ?10, nome
		Write ?26, desc
		Write ?60, $Justify($Piece(^produto(num), "^", 3), 9)  
		
		
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	Kill ^produto(num)
   		Write !, " Dados apagados."
   	}
   	Else { Write !, " Operação cancelada." }
   	
	Hang .5
    Do todos^exibirProdutos
    Hang .25
    
    Quit
    
    
deletarPedido()
 // Exibe os produtos e pergunta qual apagar
    Hang .25
    Do todos^exibirPedidos
    Hang .25
   
    Write !, tralha
    Write !, "#", ?70, "#"
    Read !, "# Quais dados deseja deletar? ", num, ?70, "#"
    Write !, "#", ?70, "#"
    Write !, tralha
    
    GOTO:'num inicio+1
  	If '$Data(^pedido(num)) { Write !, "ID inválido" Hang .5 GOTO deletarPedido+1}
 // Exibe o selecionado e pergunta se tem certeza
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"

   // arruma tamanhos de strings
	Set cli = $Piece(^pedido(num), "^", 1)
	Set prod = $Piece(^pedido(num), "^", 2)
	If $LENGTH(cli) > 13 { Set $Extract(cli,9, *) = "..."}
	If $LENGTH(prod) > 14 { Set $Extract(prod,10, *) = "..."}

   // mostra informações do cliente selecionado
	Write !, "Pedido "_num_": "
	Write ?10, cli
	Write ?28, prod
	Write ?46, $Justify($Piece(^pedido(num), "^", 3), 14)
	
	  
   	Read !!, " Tem certeza que deseja apagar esses dados? ", ans
   	If "SimSIMsim"[ans {
	   	Kill ^pedido(num)
   		Write !, " Dados apagados."
   	}
   	Else { Write !, " Operação cancelada." }
   	
	Hang .5
    Do todos^exibirPedidos
    Hang .25
    
    Quit
