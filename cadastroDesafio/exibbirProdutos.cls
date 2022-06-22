exibirProdutos


inicio
 // Cabeçalho
	Set tralha = "#######################################################################"
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



todos()
  // itera e printa todos no array
	Set count = $Order(^produto(""), 1)
	// cabeçalho antes da iteração
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	While (count '= "") {
	  // se nome e descrição forem muito grandes corta o que vai aparecer no print
		Set nome = $Piece(^produto(count), "^", 1)
		Set desc = $Piece(^produto(count), "^", 2)
		If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
		If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}
		
		
	  // printa as informações
		Write !, "Produto "_count_": "
		Write ?10, nome
		Write ?26, desc
		Write ?60, $Justify($Piece(^produto(count), "^", 3), 9)
		
	  // próxima iteração
		Set count = $Order(^produto(count), 1)
	}
	
   // ler infos completas
	Read !!, " Expandir informações de algum produto? ", ans
	GOTO:('ans) inicio 
	
	If $Data(^produto(ans)) {
		Write !!, tralha
		Write !,"#", ?70, "#"
		Write !, "# Nome........: ", $Piece(^produto(ans), "^", 1), ?70, "#"
		Write !, "# Descrição...: ", $Piece(^produto(ans), "^", 2), ?70, "#"
		Write !, "# Preço.......: ", $Piece(^produto(ans), "^", 3), ?70, "#"
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
	Write !, "#", ?27, "Exibir Produtos", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o ID: ", num
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 
 // Print
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	GOTO:(num="") inicio // volta se o ID for nulo 
	If '$Data(^produto(num)) { GOTO porID+28 }  // se o ID não corresponde a nenhum cliente mostra lista vazia

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
 //
 
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	
	Quit

porNome()
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
	Set count = $Order(^produto(""), 1)
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	While (count '= "") {
		
		If $Zconvert($Piece(^produto(count), "^", 1), "l")[$Zconvert(nameSearch, "l") { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings	
			Set nome = $Piece(^produto(count), "^", 1)
			Set desc = $Piece(^produto(count), "^", 2)
			If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
			If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}
		
		  // printa
			Write !, "Produto "_count_": "
			Write ?10, nome
			Write ?26, desc
			Write ?60, $Justify($Piece(^produto(count), "^", 3), 9)
		}
	  // próxima iteração
		Set count = $Order(^produto(count), 1)
	}
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit



porPreco()
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
	Set count = $Order(^produto(""), 1)
	Write !!, $Justify("|     Nome     |            Descrição            |  Preço  |", 70)
	
	While (count '= "") {
	  // Define se vai procurar preços abaixo ou acima do selecionado
		If priceSearch >= 0 { Set bool = $Piece(^produto(count), "^", 3) '< priceSearch }
		Elseif priceSearch < 0 { Set bool = $Piece(^produto(count), "^", 3) '> -priceSearch }
		
		If bool {
		  // arruma tamanhos das strings
			Set nome = $Piece(^produto(count), "^", 1)
			Set desc = $Piece(^produto(count), "^", 2)
			If $LENGTH(nome) > 15 { Set $Extract(nome,12, *) = "..."}
			If $LENGTH(desc) > 34 { Set $Extract(desc,31, *) = "..."}
			
		  // printa
			Write !, "Produto "_count_": "
			Write ?10, nome
			Write ?26, desc
			Write ?60, $Justify($Piece(^produto(count), "^", 3), 9)
		}
	  // pxm iteração
		Set count = $Order(^produto(count), 1)
	}
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit
