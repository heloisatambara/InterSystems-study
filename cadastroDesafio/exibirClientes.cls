exibirClientes

inicio
 // Cabeçalho
	Set tralha = "#######################################################################"
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






todos()
 // itera e printa todos no array
	Set count = $Order(^cliente(""), 1)
	// cabeçalho antes da iteração
	Write !!, "|   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	
	While (count '= "") {
	  // se nome e endereço forem muito grandes corta o que vai aparecer no print
		Set nome = $Piece(^cliente(count), "^", 1)
		Set end = $Piece(^cliente(count), "^", 2)
		If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
		If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
		
	  // printa as informações
		Write !, ?1, nome
		Write ?12, end
		Write ?32, $Piece(^cliente(count), "^", 3)
		Write ?49, $Piece(^cliente(count), "^", 4)
		Write ?65, $Piece(^cliente(count), "^", 5)
	  
	  // próxima iteração
		Set count = $Order(^cliente(count), 1)
	}
	
	
   // ler infos completas
	Read !!, " Expandir informações de algum cliente? ", ans
	GOTO:('ans) inicio 
	
	If $Data(^cliente(ans)) {
		Write !!, tralha
		Write !,"#", ?70, "#"
		Write !, "# Nome.............: ", $Piece(^cliente(ans), "^", 1), ?70, "#"
		Write !, "# Endereço.........: ", $Piece(^cliente(ans), "^", 2), ?70, "#"
		Write !, "# Telefone.........: ", $Piece(^cliente(ans), "^", 3), ?70, "#"
		Write !, "# CPF..............: ", $Piece(^cliente(ans), "^", 4), ?70, "#" 
		Write !, "# Data Nascimento..: ", $Piece(^cliente(ans), "^", 5), ?70, "#"
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
	Write !, "#", ?27, "Exibir Clientes", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
	
	Read !, "# Digite o ID: ", num
	Write ?70, "#"
	Write !, "#", ?70, "#"
	Write !, tralha
 //
 
 
 // Print
	Write !!, "|   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	
	GOTO:(num="") inicio // volta se o ID for nulo 
	If '$Data(^cliente(num)) { GOTO porID+30 } // se o ID não corresponde a nenhum cliente mostra lista vazia
	
   // arruma tamanhos de strings
	Set nome = $Piece(^cliente(num), "^", 1)
	Set end = $Piece(^cliente(num), "^", 2)
	If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
	If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}

   // mostra informações do cliente selecionado
	Write !, ?1, nome
	Write ?12, end
	Write ?32, $Piece(^cliente(num), "^", 3)
	Write ?49, $Piece(^cliente(num), "^", 4)
	Write ?65, $Piece(^cliente(num), "^", 5)
 //
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio	
	
	Quit





porNome()
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
	Set count = $Order(^cliente(""), 1)
	Write !!, "|   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (count '= "") {
		
		If $Piece(^cliente(count), "^", 1)[nameSearch { // só entra para o print se tiver o nome ou a parte pesquisada
		  // arruma tamanhos de strings
			Set nome = $Piece(^cliente(count), "^", 1)
			Set end = $Piece(^cliente(count), "^", 2)
			If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
			If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
		  
		  // printa
			Write !, ?1, nome
			Write ?12, end
			Write ?32, $Piece(^cliente(count), "^", 3)
			Write ?49, $Piece(^cliente(count), "^", 4)
			Write ?65, $Piece(^cliente(count), "^", 5)
		}
	  // próxima iteração
		Set count = $Order(^cliente(count), 1)
		
	}
	
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit
	







porCPF()
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
	Set count = $Order(^cliente(""), 1)
	Write !!, "|   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (count '= "") {
		
		If $Piece(^cliente(count), "^", 4)[cpfSearch { // só entra para o print se tiver o CPF ou a parte pesquisada
		  // arruma tamanhos
			Set nome = $Piece(^cliente(count), "^", 1)
			Set end = $Piece(^cliente(count), "^", 2)
			If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
			If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
			
		  // printa	
			Write !, ?1, nome
			Write ?12, end
			Write ?32, $Piece(^cliente(count), "^", 3)
			Write ?49, $Piece(^cliente(count), "^", 4)
			Write ?65, $Piece(^cliente(count), "^", 5)
		}
	  // pxm iteração
		Set count = $Order(^cliente(count), 1)
		
	}
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit






porIdade()
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
	Set count = $Order(^cliente(""), 1)
	Write !!, "|   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (count '= "") {
		
		Set idade = (+$Horolog - $Zdateh($Piece(^cliente(count), "^", 5),4)) / 365 // calcula a idade
		If ageSearch >= 0 { Set bool = idade '< ageSearch } // se a entrada for positiva, aceita todas as idades acima da escolhida
		Elseif ageSearch < 0 { Set bool = idade '> -ageSearch } // se a entrada for negativa, aceita todas as idades abaixo da escolhida
		
		If bool { // só entra no print idades escolhidas
		  // arruma tamanhos de strings
			Set nome = $Piece(^cliente(count), "^", 1)
			Set end = $Piece(^cliente(count), "^", 2)
			If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
			If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
			
		  // printa
			Write !, ?1, nome
			Write ?12, end
			Write ?32, $Piece(^cliente(count), "^", 3)
			Write ?49, $Piece(^cliente(count), "^", 4)
			Write ?65, $Piece(^cliente(count), "^", 5)
		}
	  // pxm iteração
		Set count = $Order(^cliente(count), 1)
		
	}
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit
