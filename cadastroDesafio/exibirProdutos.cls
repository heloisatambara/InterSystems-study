exibirProdutos

inicio
	NEW num
	Do cabecalho^cadastroOFC("Exibir Produtos")
	Write !, "#", ?70,                                  "#"
	Write !, "#", " 1- Exibir todos", ?70,              "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,          "#"
	Write !, "#", " 3- Pesquisar por nome", ?70,        "#"
	Write !, "#", " 4- Pesquisar por preço", ?70,       "#"
	Write !, "#", " 0- Sair", ?70,                      "#"
	Write !, "#", ?70,                                  "#"
	Read !,  "# Entre com a opção desejada: ", num,?70, "#"
	Write !, "#",?70,                                   "#"
	Write !, tralha
	Hang .25

	Quit:'num
	Do $Case(num, 1:todos, 2:porID, 3:porNome, 4:porPreco, :inicio)
	Quit



todos
	NEW ans, enter
 	Do exibirTudo()
    // ler infos completas
	Read !!, " Expandir informações de algum produto? ", ans
	
	GOTO:('ans) inicio // retorna a tela anterior
	If $Data(^produto(ans)) {
		Write !!, tralha
		Do exibirPorID(ans)
		Write !, tralha }
		
	Read !, enter // espera interação do usuário antes de seguir
	GOTO inicio 
	Quit

exibirTudo() public
	NEW subs, nome, desc, produto
 	// itera e printa todos no array
	Set subs = $Order(^produto(""), 1)
	// cabeçalho antes da iteração
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	While (subs '= "") {
		Set produto = ^produto(subs)
	    // se nome e descrição forem muito grandes corta o que vai aparecer no print
		Set nome = $Piece(produto, "^", 1)
		If $LENGTH(nome) > 15 {
			Set $Extract(nome,12, *) = "..."}
		Set desc = $Piece(produto, "^", 2)
		If $LENGTH(desc) > 34 {
			Set $Extract(desc,31, *) = "..."}
	    // printa
		Write !, "Produto "_subs_": ", ?10, nome, ?26, desc, ?60, $Justify($Piece(produto, "^", 3), 9)
	    // próxima iteração
		Set subs = $Order(produto, 1) }
	Quit



porID
	NEW ID, enter
	Do cabecalho^cadastroOFC("Exibir Produtos")
	Write !, "#", ?70,                   "#"
	Read !,  "# Digite o ID: ", ID, ?70, "#"
	Write !, "#", ?70,                   "#"
	
   // Print
	IF (ID="") {
		Write !, tralha
		Hang .25
		GOTO inicio } // volta se o ID for nulo 
	If '$Data(^produto(ID)) {
		Write !, tralha, !, "ID não cadastrado" }
	Else {
		Do exibirPorID(ID)
		Write !, tralha}	
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	Quit
	
exibirPorID(ID) public
	If (ID?.N) {
		Set produto = ^produto(ID) }
	Else { // passar valor direto da var, ou id
		Set produto = ID }
	Write !,"#", ?70,                                          "#"
	Write !, "# Nome........: ", $Piece(produto, "^", 1), ?70, "#"
	Write !, "# Descrição...: ", $Piece(produto, "^", 2), ?70, "#"
	Write !, "# Preço.......: ", $Piece(produto, "^", 3), ?70, "#"
	Write !,"#", ?70,                                          "#"
	Quit
	
	
	
porNome
	NEW nameSearch, subs, nome, desc, enter
	Do cabecalho^cadastroOFC("Exibir Produtos")
	Write !, "#", ?70,                             "#"
	Read !,  "# Digite o nome: ", nameSearch, ?70, "#"
	Write !, "#", ?70,                             "#"
	Write !, tralha

	Do printProdutos(nameSearch, 1)
		
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit



porPreco
	NEW priceSearch, subs, bool, nome, desc, enter
	Do cabecalho^cadastroOFC("Exibir Produtos")
	Write !, "#", ?70,                               "#"
	Read !,  "# Digite o preço: ", priceSearch, ?70, "#"
	Write !, "#", ?70,                               "#"
	Write !, tralha 
	
	Do printProdutos(priceSearch, 2)
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit

printProdutos(search, type)
	NEW subs, bool, nome, desc, produto
	Set subs = $Order(^produto(""), 1)
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	While (subs '= "") {
		Set produto = ^produto(subs)
		If type=1 {
			Set bool = $Zconvert($Piece(produto, "^", 1), "l")[$Zconvert(search, "l") } // só entra para o print se tiver o nome ou a parte pesquisada
		If type=2 {
			If priceSearch >= 0 {
				Set bool = $Piece(produto, "^", 3) '< search }
			Elseif priceSearch < 0 {
				Set bool = $Piece(produto, "^", 3) '> -search } }     
		If bool {    
		    // arruma tamanhos de strings	
			Set nome = $Piece(produto, "^", 1)
			If $LENGTH(nome) > 15 {
				Set $Extract(nome,12, *) = "..."}
			Set desc = $Piece(produto, "^", 2)
			If $LENGTH(desc) > 34 {
				Set $Extract(desc,31, *) = "..."}
		    // printa
			Write !, "Produto "_subs_": ", ?10, nome, ?26, desc, ?60, $Justify($Piece(produto, "^", 3), 9) }
        // próxima iteração
		Set subs = $Order(produto, 1) }
	Quit

