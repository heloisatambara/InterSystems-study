exibirProdutos


inicio
	NEW hora, num
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70,                                 "#"
	Write !, "#", ?27, "Exibir Produtos", ?70,         "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70,                                 "#"

	Write !, "#", " 1- Exibir todos", ?70,             "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,         "#"
	Write !, "#", " 3- Pesquisar por nome", ?70,       "#"
	Write !, "#", " 4- Pesquisar por preço", ?70,      "#"
	Write !, "#", " 0- Sair", ?70,                     "#"
	Write !, "#", ?70,                                 "#"
	
	Read !, "# Entre com a opção desejada: ", num,?70, "#"
	Write !, "#",?70,                                  "#"
	Write !, tralha
	
	Hang .25
 //

	
	Quit:'num
	Do $Case(num, 1:todos, 2:porID, 3:porNome, 4:porPreco, :inicio)
	Quit


todos
	NEW ans, enter
 	Do exibirTudo()
   // ler infos completas
	Read !!, " Expandir informações de algum produto? ", ans
	GOTO:('ans) inicio
	
	If $Data(^produto(ans)) {
		Write !!, tralha
		Do exibirPorID(ans)
		Write !, tralha
	}
	 
	Read !, enter // espera interação do usuário antes de seguir
	GOTO inicio 
	Quit

exibirTudo() public
	NEW subs, nome, desc
 // itera e printa todos no array
	Set subs = $Order(^produto(""), 1)
	// cabeçalho antes da iteração
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	While (subs '= "") {
	  // se nome e descrição forem muito grandes corta o que vai aparecer no print
		Set nome = $Piece(^produto(subs), "^", 1)
		Set desc = $Piece(^produto(subs), "^", 2)
		If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
		If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}
		
		
	  // printa as informações
		Write !, "Produto "_subs_": "
		Write ?10, nome
		Write ?26, desc
		Write ?60, $Justify($Piece(^produto(subs), "^", 3), 9)
		
	  // próxima iteração
		Set subs = $Order(^produto(subs), 1)
	}
	Quit


porID
	NEW hora, ID, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Produtos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o ID: ", ID
	Write ?70, "#"
	Write !, "#", ?70, "#"
 //
 
 // Print
	IF (ID="") { Write !, tralha Hang .25 GOTO inicio } // volta se o ID for nulo 
	If '$Data(^produto(ID)) { Write !, tralha, !, "ID não cadastrado" }
	Else { Do exibirPorID(ID) Write !, tralha}	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	Quit
	
exibirPorID(ID) public
		Write !,"#", ?70, "#"
		Write !, "# Nome........: ", $Piece(^produto(ID), "^", 1), ?70, "#"
		Write !, "# Descrição...: ", $Piece(^produto(ID), "^", 2), ?70, "#"
		Write !, "# Preço.......: ", $Piece(^produto(ID), "^", 3), ?70, "#"
		Write !,"#", ?70, "#"
		Quit
	
	

porNome()
	NEW hora, nameSearcj, subs, nome, desc, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Produtos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o nome: ", nameSearch
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //



 // Print
	Set subs = $Order(^produto(""), 1)
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	While (subs '= "") {
		
		If $Zconvert($Piece(^produto(subs), "^", 1), "l")[$Zconvert(nameSearch, "l") { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings	
			Set nome = $Piece(^produto(subs), "^", 1)
			Set desc = $Piece(^produto(subs), "^", 2)
			If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
			If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}
		
		  // printa
			Write !, "Produto "_subs_": "
			Write ?10, nome
			Write ?26, desc
			Write ?60, $Justify($Piece(^produto(subs), "^", 3), 9)
		}
	  // próxima iteração
		Set subs = $Order(^produto(subs), 1)
	}
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit



porPreco()
	NEW hora, priceSearch, subs, bool, nome, desc, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Produtos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o preço: ", priceSearch
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
	
	
 // Print
	Set subs = $Order(^produto(""), 1)
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	While (subs '= "") {
	  // Define se vai procurar preços abaixo ou acima do selecionado
		If priceSearch >= 0 { Set bool = $Piece(^produto(subs), "^", 3) '< priceSearch }
		Elseif priceSearch < 0 { Set bool = $Piece(^produto(subs), "^", 3) '> -priceSearch }
		
		If bool {
		  // arruma tamanhos das strings
			Set nome = $Piece(^produto(subs), "^", 1)
			Set desc = $Piece(^produto(subs), "^", 2)
			If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
			If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}
			
		  // printa
			Write !, "Produto "_subs_": "
			Write ?10, nome
			Write ?26, desc
			Write ?60, $Justify($Piece(^produto(subs), "^", 3), 9)
		}
	  // pxm iteração
		Set subs = $Order(^produto(subs), 1)
	}
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit

