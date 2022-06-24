exibirClientes

inicio
	NEW hora, num
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Clientes", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	

	Write !, "#", " 1- Exibir todos", ?70, "#"
	Write !, "#", " 2- Pesquisar por ID", ?70, "#"
	Write !, "#", " 3- Pesquisar por nome", ?70, "#"
	Write !, "#", " 4- Pesquisar por CPF", ?70, "#"
	Write !, "#", " 5- Pesquisar por idade", ?70, "#"
	Write !, "#", " 0- Sair", ?70, "#"
	Write !, "#", ?70, "#"
	
	Read !, "# Entre com a opção desejada: ", num
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
	Hang .25
	
	Quit:'num
	Do $Case(num, 1:todos, 2:porID, 3:porNome, 4:porCPF, 5:porIdade, :inicio)
	
	Quit






todos
	NEW ans, enter
	Do exibirTudo()
	
   // ler infos completas
	Read !!, " Expandir informações de algum cliente? ", ans
	GOTO:('ans) inicio+1
	
	If $Data(^cliente(ans)) {
		Write !!, tralha
		Do exibirPorID(ans)
		Write !, tralha
	}
	Read !, enter // espera interação do usuário antes de seguir 
	GOTO inicio
	Quit
	
exibirTudo() public
	NEW subs, nome, end
 // itera e printa todos no array
	Set subs = $Order(^cliente(""), 1)
	// cabeçalho antes da iteração
	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	
	While (subs '= "") {
	  // se nome e endereço forem muito grandes corta o que vai aparecer no print
		Set nome = $Piece(^cliente(subs), "^", 1)
		Set end = $Piece(^cliente(subs), "^", 2)
		If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
		If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
		
	  // printa as informações
		Write !, subs, ?2, nome, ?13, end, ?33, $Piece(^cliente(subs), "^", 3), ?50, $Piece(^cliente(subs), "^", 4), ?66, $Piece(^cliente(subs), "^", 5)
	  
	  // próxima iteração
		Set subs = $Order(^cliente(subs), 1)
	}
	Quit
	
	
porID
	NEW hora, ID, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Clientes", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o ID: ", ID
	Write ?70, "#"
	Write !, "#", ?70, "#"
 //
	
	If (ID="") { Write !, tralha Hang .25 GOTO inicio } // volta se o ID for nulo 
	If '$Data(^cliente(ID)) { Write !, tralha, !, "ID não cadastrado" }
 	Else { Do exibirPorID(ID) Write !, tralha }
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	
	Quit

exibirPorID(ID) public	   	
	Write !,"#", ?70, "#"
	Write !, "# Nome.............: ", $Piece(^cliente(ID), "^", 1), ?70, "#"
	Write !, "# Endereço.........: ", $Piece(^cliente(ID), "^", 2), ?70, "#"
	Write !, "# Telefone.........: ", $Piece(^cliente(ID), "^", 3), ?70, "#"
	Write !, "# CPF..............: ", $Piece(^cliente(ID), "^", 4), ?70, "#" 
	Write !, "# Data Nascimento..: ", $Piece(^cliente(ID), "^", 5), ?70, "#"
	Write !,"#", ?70, "#"
	Quit




porNome
	NEW hora, nameSearch, subs, nome, end, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2)
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Clientes", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o Nome: ", nameSearch
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //

 // Print
	Set subs = $Order(^cliente(""), 1)
	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (subs '= "") {
		
		If $Piece(^cliente(subs), "^", 1)[nameSearch { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings
			Set nome = $Piece(^cliente(subs), "^", 1)
			Set end = $Piece(^cliente(subs), "^", 2)
			If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
			If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
		  
		  // printa
			Write !, subs, ?2, nome, ?13, end, ?33, $Piece(^cliente(subs), "^", 3), ?50, $Piece(^cliente(subs), "^", 4), ?66, $Piece(^cliente(subs), "^", 5)
		}
	  // próxima iteração
		Set subs = $Order(^cliente(subs), 1)
		
	}
	Read !, enter // espera interação do usuário para seguir
 	GOTO inicio+1
	Quit
	


porCPF
	NEW hora, cpfSearch, subs, nome, end, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Clientes", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o CPF: ",cpfSearch
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 // Print 	
	Set subs = $Order(^cliente(""), 1)
	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (subs '= "") {
		
		If $Piece(^cliente(subs), "^", 4)[cpfSearch { // só entra para o print se tiver o CPF ou a parte pesquisada
		  // arruma tamanhos
			Set nome = $Piece(^cliente(subs), "^", 1)
			Set end = $Piece(^cliente(subs), "^", 2)
			If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
			If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
			
		  // printa	
			Write !, subs, ?2, nome, ?13, end, ?33, $Piece(^cliente(subs), "^", 3), ?50, $Piece(^cliente(subs), "^", 4), ?66, $Piece(^cliente(subs), "^", 5)
		}
	  // pxm iteração
		Set subs = $Order(^cliente(subs), 1)
		
	}
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit






porIdade
	NEW hora, ageSearch, subs, idade, bool, nome, end, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Exibir Clientes", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite a Idade: ", ageSearch
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 // Print	
	Set subs = $Order(^cliente(""), 1)
	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (subs '= "") {
		
		Set idade = (+$Horolog - $Zdateh($Piece(^cliente(subs), "^", 5),4)) / 365 // calcula a idade
		If ageSearch >= 0 { Set bool = idade '< ageSearch } // se a entrada for positiva, aceita todas as idades acima da escolhida
		Elseif ageSearch < 0 { Set bool = idade '> -ageSearch } // se a entrada for negativa, aceita todas as idades abaixo da escolhida
		
		If bool { // só entra no print idades escolhidas
		  // arruma tamanhos de strings
			Set nome = $Piece(^cliente(subs), "^", 1)
			Set end = $Piece(^cliente(subs), "^", 2)
			If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
			If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
			
		  // printa
			Write !, subs, ?2, nome, ?13, end, ?33, $Piece(^cliente(subs), "^", 3), ?50, $Piece(^cliente(subs), "^", 4), ?66, $Piece(^cliente(subs), "^", 5)
		}
	  // pxm iteração
		Set subs = $Order(^cliente(subs), 1)
		
	}
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit
