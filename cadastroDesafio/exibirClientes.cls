exibirClientes

inicio
	NEW num
	Do cabecalho^cadastroOFC("Exibir Clientes")
	Write !, "#", " 1- Exibir todos", ?70,               "#"
	Write !, "#", " 2- Pesquisar por ID", ?70,           "#"
	Write !, "#", " 3- Pesquisar por nome", ?70,         "#"
	Write !, "#", " 4- Pesquisar por CPF", ?70,          "#"
	Write !, "#", " 5- Pesquisar por idade", ?70,        "#"
	Write !, "#", " 0- Sair", ?70,                       "#"
	Write !, "#", ?70,                                   "#"
	Read !,  "# Entre com a opção desejada: ", num, ?70, "#"
	Write !, "#", ?70,                                   "#"
	Write !, tralha
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
	NEW subs, nome, end, cliente
    // itera e printa todos no array
	Set subs = $Order(^cliente(""), 1)
	// cabeçalho antes da iteração
	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (subs '= "") {
		Set cliente = ^cliente(subs)
	    // se nome e endereço forem muito grandes corta o que vai aparecer no print
		Set nome = $Piece(cliente, "^", 1)
		If $LENGTH(nome) > 11 {
			Set $Extract(nome,8, *) = "..."}
		Set end = $Piece(cliente, "^", 2)
		If $LENGTH(end) > 19 {
			Set $Extract(end,16, *) = "..."}
	    // printa as informações
		Write !, subs, ?2, nome, ?13, end, ?33, $Piece(cliente, "^", 3), ?50, $Piece(cliente, "^", 4), ?66, $Piece(cliente, "^", 5)
        // próxima iteração
		Set subs = $Order(^cliente(subs), 1) }
	Quit
	
	
	
porID
	NEW ID, enter
	Do cabecalho^cadastroOFC("Exibir Clientes")
	Write !, "#", ?70,                   "#"
	Read !,  "# Digite o ID: ", ID, ?70, "#"
	Write !, "#", ?70,                   "#"
	
	If (ID="") {
		Write !, tralha
		Hang .25 GOTO inicio } // volta se o ID for nulo 
	If '$Data(^cliente(ID)) {
		Write !, tralha, !, "ID não cadastrado" }
 	Else {
	 	Do exibirPorID(ID)
	 	Write !, tralha }
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit

exibirPorID(ID) public
	If (ID?.N) {
		Set cliente = ^cliente(ID) }
	Else {  // passar valor direto da var, ou id
		Set cliente = ID }
	Write !, "#", ?70,                                              "#"
	Write !, "# Nome.............: ", $Piece(cliente, "^", 1), ?70, "#"
	Write !, "# Endereço.........: ", $Piece(cliente, "^", 2), ?70, "#"
	Write !, "# Telefone.........: ", $Piece(cliente, "^", 3), ?70, "#"
	Write !, "# CPF..............: ", $Piece(cliente, "^", 4), ?70, "#" 
	Write !, "# Data Nascimento..: ", $Piece(cliente, "^", 5), ?70, "#"
	Write !, "#", ?70,                                              "#"
	Quit



porNome
	NEW nameSearch, enter
	Do cabecalho^cadastroOFC("Exibir Clientes")
	Write !, "#", ?70,                             "#"
	Read !,  "# Digite o Nome: ", nameSearch, ?70, "#"
	Write !, "#", ?70,                             "#"
	Write !, tralha

	Do printClientes(nameSearch, 1)
	
	Read !, enter // espera interação do usuário para seguir
 	GOTO inicio
	Quit
	


porCPF
	NEW cpfSearch, enter
	Do cabecalho^cadastroOFC("Exibir Clientes")
	Write !, "#", ?70,                          "#"
	Read !,  "# Digite o CPF: ",cpfSearch, ?70, "#"
	Write !, "#", ?70,                          "#"
	Write !, tralha
 	
	Do printClientes(cpfSearch, 4)
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit



porIdade
	NEW ageSearch, enter
	Do cabecalho^cadastroOFC("Exibir Clientes")
	Write !, "#", ?70,                             "#"
	Read !,  "# Digite a Idade: ", ageSearch, ?70, "#"
	Write !, "#", ?70,                             "#"
	Write !, tralha
	
	Do printClientes(ageSearch, 2)
	
	Read !, enter // espera interação do usuário para seguir
	GOTO inicio
	Quit

printClientes(search, type)
	NEW subs, bool, nome, end, idade, cliente
	Set subs = $Order(^cliente(""), 1)
	Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	While (subs '= "") {
		Set cliente = ^cliente(subs)
		If type=2 {
			Set idade = (+$Horolog - $Zdateh($Piece(cliente, "^", 5),4)) / 365 // calcula a idade
			If ageSearch >= 0 {
				Set bool = idade '< search } // se a entrada for positiva, aceita todas as idades acima da escolhida
			Elseif ageSearch < 0 {
				Set bool = idade '> -search } } // se a entrada for negativa, aceita todas as idades abaixo da escolhida
		Else {
			Set bool = $Zconvert($Piece(cliente, "^", type), "l")[$Zconvert(search, "l") }
		If bool {
		    // arruma tamanhos de strings
			Set nome = $Piece(cliente, "^", 1)
			If $LENGTH(nome) > 11 {
				Set $Extract(nome,8, *) = "..."}
			Set end = $Piece(cliente, "^", 2)
			If $LENGTH(end) > 19 {
				Set $Extract(end,16, *) = "..."}
            // printa
			Write !, subs, ?2, nome, ?13, end, ?33, $Piece(cliente, "^", 3), ?50, $Piece(cliente, "^", 4), ?66, $Piece(cliente, "^", 5)
		}
	    // pxm iteração
		Set subs = $Order(^cliente(subs), 1) }
	Quit
		
		
