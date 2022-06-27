exibirPedidos

inicio
	NEW num
	Do cabecalho^cadastroOFC("Exibir Pedidos")
	Write !, "#", ?70,                                  "#"
	Write !, "#", " 1- Exibir todos", ?70,              "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,          "#"
	Write !, "#", " 3- Pesquisar por cliente", ?70,     "#"
	Write !, "#", " 4- Pesquisar por produto", ?70,     "#"
	Write !, "#", " 5- Pesquisar por quantidade", ?70,  "#"
	Write !, "#", " 0- Sair", ?70,                      "#"
	Write !, "#", ?70,                                  "#"
	Read !, "# Entre com a opção desejada: ", num, ?70, "#"
	Write !, "#", ?70,                                  "#"
	Write !, tralha
	Hang .25
 
	Quit:'num
	Do $Case(num, 1:todos, 2:porID, 3:porCliente, 4:porProduto, 5:porQtd, :inicio)
	Quit
	
	
	
todos
	NEW ans, enter
	Do exibirTudo()
    // ler infos completas
	Read !!, " Expandir informações de algum pedido? ", ans
	GOTO:('ans) inicio
	
	If $Data(^pedido(ans)) { // retorna a tela anterior
		Write !!, tralha
		Do exibirPorID(ans)
		Write !, tralha }	
		
	Read !, enter // espera interação do usuário antes de seguir
	GOTO inicio
	Quit

exibirTudo()
	NEW subs, cli, prod, pedido
    // itera e printa todos no array
	Set subs = $Order(^pedido(""), 1)
	// cabeçalho antes da iteração
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	While (subs '= "") { 
		Set pedido = ^pedido(subs)
	  // se nomes forem muito grandes corta o que vai aparecer no print
		Set cli = $Piece(pedido, "^", 1)
		If $LENGTH(cli) > 17 {
			Set $Extract(cli,15, *) = "..."}
		Set prod = $Piece(pedido, "^", 2)
		If $LENGTH(prod) > 17 {
			Set $Extract(prod,15, *) = "..."}
			
	    // printa
		Write !, "Pedido "_subs_": ", ?10, cli, ?28, prod, ?46, $Justify($Piece(pedido, "^", 3), 14)
	    // próxima iteração
		Set subs = $Order(^pedido(subs), 1) }
	Quit



porID
	NEW ID, enter
	Do cabecalho^cadastroOFC("Exibir Pedidos")
	Write !, "#", ?70, "#"
	Read !, "# Digite o ID: ", ID, ?70, "#"
	Write !, "#", ?70, "#"

 // Print
	IF (ID="") {
		Write !, tralha
		Hang .25
		GOTO inicio } // volta se o ID for nulo 
	If '$Data(^pedido(ID)) {
		Write !, tralha, !, "ID não cadastrado" }
	Else {
		Do exibirPorID(ID)
		Write !, tralha}	
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	Quit

exibirPorID(ID) public
	If (ID?.N) {
		Set pedido = ^pedido(ID) }
	Else { // passar valor direto da var, ou id
		Set pedido = ID }
	Write !, "#", ?70,                                         "#"
	Write !, "# Cliente......: ", $Piece(pedido, "^", 1), ?70, "#"
	Write !, "# Produto......: ", $Piece(pedido, "^", 2), ?70, "#"
	Write !, "# Quantidade...: ", $Piece(pedido, "^", 3), ?70, "#"
	Write !, "#", ?70,                                         "#"
	Quit
	
	

porCliente
	NEW cliente, enter
	Do cabecalho^cadastroOFC("Exibir Pedidos")
	Write !, "#", ?70, "#"
	Read !, "# Digite o Cliente: ", cliente, ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
	
	Do printPedidos(cliente, 1)
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	Quit



porProduto
	NEW produto, enter
	Do cabecalho^cadastroOFC("Exibir Pedidos")
	Write !, "#", ?70, "#"
	Read !, "# Digite o Produto: ", produto, ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha

	Do printPedidos(produto, 2)
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit



porQtd
	NEW qtdSearch, enter
	Do cabecalho^cadastroOFC("Exibir Pedidos")
	Write !, "#", ?70, "#"
	Read !, "# Digite a quantidade: ", qtdSearch, ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 	
	Do printPedidos(qtdSearch, 3)
		
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit

printPedidos(search, type) // type é o tipo de comparação que será feita 
	NEW subs, bool, cli, prod, pedido 
	Set subs = $Order(^pedido(""), 1)
	Write !!, ?9, "|     Cliente     |     Produto     |  Quantidade  |"
	While (subs '= "") {
		Set pedido = ^pedido(subs)
		// seleciona a comparacao
		If type=3 {
			If qtdSearch >= 0 {
				Set bool = $Piece(pedido, "^", 3) '< search }
			Elseif qtdSearch < 0 {
				Set bool = $Piece(pedido, "^", 3) '> -search }}
		Else {
			Set bool = $Zconvert($Piece(pedido, "^", type), "l")[$Zconvert(search, "l") }
		// print dos selecionados
		If bool {
		    // arruma tamanhos das strings
			Set cli = $Piece(pedido, "^", 1)
			If $LENGTH(cli) > 17 {
				Set $Extract(cli,15, *) = "..."}
			Set prod = $Piece(pedido, "^", 2) 
			If $LENGTH(prod) > 17 {
				Set $Extract(prod,15, *) = "..."}
		    // print
			Write !, "Pedido "_subs_": ", ?10, cli, ?28, prod, ?46, $Justify($Piece(pedido, "^", 3), 14) }
	    // pxm iteração
		Set subs = $Order(^pedido(subs), 1) }
	Quit
