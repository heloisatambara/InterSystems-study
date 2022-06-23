exibirPedidos


inicio
 // Cabeçalho
 //	Set tralha = "#######################################################################"
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
	Set subs = $Order(^pedido(""), 1)
	// cabeçalho antes da iteração
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (subs '= "") { 
	  // se nomes forem muito grandes corta o que vai aparecer no print
		Set cli = $Piece(^pedido(subs), "^", 1)
		Set prod = $Piece(^pedido(subs), "^", 2)
		If $LENGTH(cli) > 17 { Set $Extract(cli,15, *) = "..."}
		If $LENGTH(prod) > 17 { Set $Extract(prod,15, *) = "..."}

	  // printa as informações
		Write !, "Pedido "_subs_": "
		Write ?10, cli
		Write ?28, prod
		Write ?46, $Justify($Piece(^pedido(subs), "^", 3), 14)
		
	  // próxima iteração
		Set subs = $Order(^pedido(subs), 1)
	}
	
   // ler infos completas
	Read !!, " Expandir informações de algum pedido? ", ans
	Quit:('ans)
	
	If $Data(^pedido(ans)) {
		Write !!, tralha
		Write !,"#", ?70, "#"
		Write !, "# Cliente......: ", $Piece(^pedido(ans), "^", 1), ?70, "#"
		Write !, "# Produto......: ", $Piece(^pedido(ans), "^", 2), ?70, "#"
		Write !, "# Quantidade...: ", $Piece(^pedido(ans), "^", 3), ?70, "#"
		Write !,"#", ?70, "#"
		Write !, tralha
	}
	 
	
	
	Read !, enter // espera interação do usuário antes de seguir
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
	Set cli = $Piece(^pedido(num), "^", 1)
	Set prod = $Piece(^pedido(num), "^", 2)
	If $LENGTH(cli) > 17 { Set $Extract(cli,15, *) = "..."}
	If $LENGTH(prod) > 17 { Set $Extract(prod,15, *) = "..."}

   // mostra informações do cliente selecionado
	Write !, "Pedido "_num_": "
	Write ?10, cli
	Write ?28, prod
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
	Set subs = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (subs '= "") {
		If $Zconvert($Piece(^pedido(subs), "^", 1), "l")[$Zconvert(cliente, "l") { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings			
			Set cli = $Piece(^pedido(subs), "^", 1)
			Set prod = $Piece(^pedido(subs), "^", 2)
			If $LENGTH(cli) > 17 { Set $Extract(cli,15, *) = "..."}
			If $LENGTH(prod) > 17 { Set $Extract(prod,15, *) = "..."}

		  // printa
			Write !, "Pedido "_subs_": "
			Write ?10, cli
			Write ?28, prod
			Write ?46, $Justify($Piece(^pedido(subs), "^", 3), 14)
		}
	  // próxima iteração
		Set subs = $Order(^pedido(subs), 1)
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
	Set subs = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (subs '= "") {
		If $Zconvert($Piece(^pedido(subs), "^", 2), "l")[$Zconvert(produto, "l") { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings
			Set cli = $Piece(^pedido(subs), "^", 1)
			Set prod = $Piece(^pedido(subs), "^", 2)
			If $LENGTH(cli) > 17 { Set $Extract(cli,15, *) = "..."}
			If $LENGTH(prod) > 17 { Set $Extract(prod,15, *) = "..."}

		  // print
			Write !, "Pedido "_subs_": "
			Write ?10, cli
			Write ?28, prod
			Write ?46, $Justify($Piece(^pedido(subs), "^", 3), 14)
		}
	  // pxm iteração
		Set subs = $Order(^pedido(subs), 1)	
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
	Set subs = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	
	While (subs '= "") {
	  // Define se vai procurar quantidades abaixo ou acima do selecionado
		If qtdSearch >= 0 { Set bool = $Piece(^pedido(subs), "^", 3) '< qtdSearch }
		Elseif qtdSearch < 0 { Set bool = $Piece(^pedido(subs), "^", 3) '> -qtdSearch }
		
		If bool {
		  // arruma tamanhos das strings
			Set cli = $Piece(^pedido(subs), "^", 1)
			Set prod = $Piece(^pedido(subs), "^", 2)
			If $LENGTH(cli) > 17 { Set $Extract(cli,15, *) = "..."}
			If $LENGTH(prod) > 17 { Set $Extract(prod,15, *) = "..."}

		  // printa
			Write !, "Pedido "_subs_": "
			Write ?10, cli
			Write ?28, prod
			Write ?46, $Justify($Piece(^pedido(subs), "^", 3), 14)
		}
	  // pxm iteração
		Set subs = $Order(^pedido(subs), 1)
	}
	
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	
	Quit
