exibirPedidos


inicio
 // Cabeçalho
	Set tralha = "#######################################################################"
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Pedidos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	

	Write !, "#", " 1- Exibir todos", ?70, "#"
	Write !, "#", " 2- Pesquisar por ID", ?70, "#"
	Write !, "#", " 3- Pesquisar por cliente", ?70, "#"
	Write !, "#", " 4- Pesquisar por produto", ?70, "#"
	Write !, "#", " 5- Pesquisar por quantidade", ?70, "#"
	Write !, "#", " 0- Sair", ?70, "#"
	Write !, "#", ?70, "#"
	
	Read !, "# Entre com a opção desejada: ", num
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
	
	Hang .25
 //
 
	
	Quit:'num
	Do $Case(num, 1:todos, 2:porID, 3:porCliente, 4:porProduto, 5:porQtd, :inicio)
	
	Quit
	
	
todos()
  // itera e printa todos no array
	Set count = $Order(^pedido(""), 1)
	// cabeçalho antes da iteração
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (count '= "") { 
	  // se nomes forem muito grandes corta o que vai aparecer no print
		Set cli = $Piece(^pedido(count), "^", 1), cliString = $Piece(^cliente(cli), "^", 1)
		Set prod = $Piece(^pedido(count), "^", 2), prodString = $Piece(^produto(prod), "^", 1)
		If $LENGTH(cliString) > 14 { Set $Extract(cliString,11, *) = "..."}
		If $LENGTH(prodString) > 14 { Set $Extract(prodString,10, *) = "..."}

	  // printa as informações
		Write !, "Pedido "_count_": "
		Write ?10, cliString_" ("_cli_")"
		Write ?28, prodString_" ("_prod_")"
		Write ?46, $Justify($Piece(^pedido(count), "^", 3), 14)
		
	  // próxima iteração
		Set count = $Order(^pedido(count), 1)
	}
	
   // ler infos completas
	Read !!, " Expandir informações de algum pedido? ", ans
	GOTO:('ans) inicio 
	
	If $Data(^pedido(ans)) {
		
		Set cli = $Piece(^pedido(ans), "^", 1), cliString = $Piece(^cliente(cli), "^", 1)
		Set prod = $Piece(^pedido(ans), "^", 2), prodString = $Piece(^produto(prod), "^", 1)
		
		Write !!, tralha
		Write !,"#", ?70, "#"
		Write !, "# Cliente......: ", cliString_" ("_cli_")", ?70, "#"
		Write !, "# Produto......: ", prodString_" ("_prod_")", ?70, "#"
		Write !, "# Quantidade...: ", $Piece(^pedido(ans), "^", 3), ?70, "#"
		Write !,"#", ?70, "#"
		Write !, tralha
	}
	 
	
	
	Read !, enter // espera interação do usuário antes de seguir
	GOTO inicio
	Quit


porID()
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Pedidos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o ID: ", num
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 
 // Print
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	GOTO:(num="") inicio // volta se o ID for nulo 
	If '$Data(^pedido(num)) { GOTO porID+28 }  // se o ID não corresponde a nenhum cliente mostra lista vazia

   // arruma tamanhos de strings
	Set cli = $Piece(^pedido(num), "^", 1), cliString = $Piece(^cliente(cli), "^", 1)
	Set prod = $Piece(^pedido(num), "^", 2), prodString = $Piece(^produto(prod), "^", 1)
	If $LENGTH(cliString) > 13 { Set $Extract(cliString,9, *) = "..."}
	If $LENGTH(prodString) > 14 { Set $Extract(prodString,10, *) = "..."}

   // mostra informações do cliente selecionado
	Write !, "Pedido "_num_": "
	Write ?10, cliString_" ("_cli_")"
	Write ?28, prodString_" ("_prod_")"
	Write ?46, $Justify($Piece(^pedido(num), "^", 3), 14)
 //
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	
	Quit

porCliente()
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Pedidos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o Cliente: ", cliente
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 // Print
	Set count = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (count '= "") {
		If $Zconvert($Piece(^cliente($Piece(^pedido(count), "^", 1)), "^", 1), "l")[$Zconvert(cliente, "l") { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings			
			Set cli = $Piece(^pedido(count), "^", 1), cliString = $Piece(^cliente(cli), "^", 1)
			Set prod = $Piece(^pedido(count), "^", 2), prodString = $Piece(^produto(prod), "^", 1)
			If $LENGTH(cliString) > 13 { Set $Extract(cliString,9, *) = "..."}
			If $LENGTH(prodString) > 14 { Set $Extract(prodString,10, *) = "..."}

		  // printa
			Write !, "Pedido "_count_": "
			Write ?10, cliString_" ("_cli_")"
			Write ?28, prodString_" ("_prod_")"
			Write ?46, $Justify($Piece(^pedido(count), "^", 3), 14)
		}
	  // próxima iteração
		Set count = $Order(^pedido(count), 1)
	}


	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	
	Quit



porProduto()
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Pedidos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o Produto: ", produto
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 
 // Print
	Set count = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (count '= "") {
		If $Zconvert($Piece(^produto($Piece(^pedido(count), "^", 2)), "^", 1), "l")[$Zconvert(produto, "l") { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings
			Set cli = $Piece(^pedido(count), "^", 1), cliString = $Piece(^cliente(cli), "^", 1)
			Set prod = $Piece(^pedido(count), "^", 2), prodString = $Piece(^produto(prod), "^", 1)
			If $LENGTH(cliString) > 13 { Set $Extract(cliString,9, *) = "..."}
			If $LENGTH(prodString) > 14 { Set $Extract(prodString,10, *) = "..."}

		  // print
			Write !, "Pedido "_count_": "
			Write ?10, cliString_" ("_cli_")"
			Write ?28, prodString_" ("_prod_")"
			Write ?46, $Justify($Piece(^pedido(count), "^", 3), 14)
		}
	  // pxm iteração
		Set count = $Order(^pedido(count), 1)	
	}


	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	
	Quit




porQtd()
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Pedidos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite a quantidade: ", qtdSearch
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
	

 // Print
	Set count = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (count '= "") {
	  // Define se vai procurar quantidades abaixo ou acima do selecionado
		If qtdSearch >= 0 { Set bool = $Piece(^pedido(count), "^", 3) '< qtdSearch }
		Elseif qtdSearch < 0 { Set bool = $Piece(^pedido(count), "^", 3) '> -qtdSearch }
		
		If bool {
		  // arruma tamanhos das strings
			Set cli = $Piece(^pedido(count), "^", 1), cliString = $Piece(^cliente(cli), "^", 1)
			Set prod = $Piece(^pedido(count), "^", 2), prodString = $Piece(^produto(prod), "^", 1)
			If $LENGTH(cliString) > 13 { Set $Extract(cliString,9, *) = "..."}
			If $LENGTH(prodString) > 14 { Set $Extract(prodString,10, *) = "..."}

		  // printa
			Write !, "Pedido "_count_": "
			Write ?10, cliString_" ("_cli_")"
			Write ?28, prodString_" ("_prod_")"
			Write ?46, $Justify($Piece(^pedido(count), "^", 3), 14)
		}
	  // pxm iteração
		Set count = $Order(^pedido(count), 1)
	}
	
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	
	Quit
