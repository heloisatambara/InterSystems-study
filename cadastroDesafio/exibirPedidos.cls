exibirPedidos

inicio
	NEW hora, num
 // Cabeçalho
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
	
	Read !, "# Entre com a opção desejada: ", num, ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
	
	Hang .25
 //
	
	Quit:'num
	Do $Case(num, 1:todos, 2:porID, 3:porCliente, 4:porProduto, 5:porQtd, :inicio)
	Quit
	
	
todos
	NEW ans, enter
	Do exibirTudo()
   // ler infos completas
	Read !!, " Expandir informações de algum pedido? ", ans
	GOTO:('ans) inicio
	
	If $Data(^pedido(ans)) {
		Write !!, tralha
		Do exibirPorID(ans)
		Write !, tralha
	}	
	Read !, enter // espera interação do usuário antes de seguir
	GOTO inicio
	Quit

exibirTudo()
	NEW subs, cli, prod
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
	Quit


porID
	NEW hora, ID, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Pedidos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o ID: ", ID, ?70, "#"
	Write !, "#", ?70, "#"
 //
 
 // Print
	IF (ID="") { Write !, tralha Hang .25 GOTO inicio } // volta se o ID for nulo 
	If '$Data(^pedido(ID)) { Write !, tralha, !, "ID não cadastrado" }
	Else { Do exibirPorID(ID) Write !, tralha}	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	Quit

	
exibirPorID(ID) public
	Write !,"#", ?70, "#"
	Write !, "# Cliente......: ", $Piece(^pedido(ID), "^", 1), ?70, "#"
	Write !, "# Produto......: ", $Piece(^pedido(ID), "^", 2), ?70, "#"
	Write !, "# Quantidade...: ", $Piece(^pedido(ID), "^", 3), ?70, "#"
	Write !,"#", ?70, "#"
	Quit
	
	
	

porCliente
	NEW hora, cliente, subs, cli, prod, enter
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



porProduto
	NEW hora, produto, subs, cli, prod, enter
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




porQtd
	NEW hora, qtdSearch, subs, bool, cli, prod, enter
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
