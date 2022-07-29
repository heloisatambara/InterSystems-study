Class estagio.livraria.Interface [ Abstract ]
{

// TO DO:

// // tratamento para alugar/deletar/inserir livros com mesmo nome

// // testar

/// Menu de início: em loop até input de saída
ClassMethod Iniciar()
{
	Do
	{
		Set tOp = ..Menu("Já tenho conta", "Quero me cadastrar")
		// 1- Já tenho conta
		// 2- Quero me cadastrar
		
		Do $CASE(tOp, 1:..Login(),
					  2:..Cadastrar(),
					   :..Sair(.tOp)) // método Sair() modifica tOp para sair do loop e quitar Iniciar()
	}
	While tOp

	Quit
}

/// Menu de cadastro
ClassMethod Cadastrar()
{
	Set tOp = ..Menu("Sou Cliente", "Sou Funcionário")
	// 1- Sou Cliente
	// 2- Sou Funcionário
	
	/* CADASTRO */
	Set tSC = $CASE(tOp, 1:##class(estagio.livraria.Cadastro).Cadastrar("C", .tID, .tFidelidade),
						 2:##class(estagio.livraria.Cadastro).Cadastrar("F", .tID, .tFidelidade),
						  :..Sair(.tOp))
	
	// erro no cadastro retorna para início
	Do:'$$$ISERR(tSC) $CASE(tOp, 1:..Cliente(tID, tFidelidade),
								 2:..Funcionario(),
								  :..Sair(.tOp))
	
	Quit
}

/// Menu de Login - não permite Login de cliente na aba de funcionários, mas o contrário é possível.
ClassMethod Login()
{
	Set tSC = 0
	
	Set tOp = ..Menu("Sou Cliente", "Sou Funcionário")
	// 1 - Sou Cliente
	// 2 - Sou Funcionário
	
	/* LOGIN */
	Set:((tOp=1)||(tOp=2)) tSC = ##class(estagio.livraria.Cadastro).Login(.tID, .tFidelidade, .tTipo)
	
	// conta de cliente usada para entrar na aba de funcionários: força erro
	If (tOp=2)&&(tTipo="C")
	{
		Write !!, "ACESSO NEGADO.", !!
		
		Set tSC = 0
	}
	
	// erro no login retorna para início - tipo de login define a qual aba vai
	Do:'$$$ISERR(tSC) $CASE(tOp, 1:..Cliente(tID, tFidelidade),
								 2:..Funcionario(),
								  :..Sair(.tOp))
	
	Quit
}

/// Menu com funções de funcionário
ClassMethod Funcionario()
{
	Do
	{
		Set tOp = ..Menu("Exibir Livros", "Exibir Aluguéis", "Exibir Lucros", "Cadastrar Livro", "Registrar Devolução", "Apagar Livros", "Editar Cadastros")
		// 1- Exibir Livros
		// 2- Exibir Aluguéis
		// 3- Exibir Lucros
		// 4- Cadastrar Livro
		// 5- Registrar Devolução
		// 6- Apagar Livros
		// 7- Editar Cadastros
	
		Do $CASE(tOp, 1:##class(estagio.livraria.Livro).Exibir(),
					  2:##class(estagio.livraria.Aluguel).Exibir(),
					  3:##class(estagio.livraria.Lucro).Exibir(),
					  4:##class(estagio.livraria.Livro).Cadastrar(),
					  5:##class(estagio.livraria.Aluguel).Devolver(),
					  6:##class(estagio.livraria.Livro).Apagar(),
					  7:##class(estagio.livraria.Cadastro).Editar(),
					   :..Sair(.tOp))
	}
	While tOp // retorna para esse menu após cada função, a não ser a função de saída
	
	Quit
}

/// Menu com funções de cliente
ClassMethod Cliente(pCliente As %Integer, pFidelidade As %Boolean)
{
	// Id do cliente e se tem fidelidade é passado após login/cadastro para chamada das funções *
	Do
	{
		Set tOp = ..Menu("Ver livro disponíveis", "Exibir seus aluguéis", "Alugar livro", "Editar meu cadastro")
		// 1- Ver livro disponíveis
		// 2- Exibir seus aluguéis
		// 3- Alugar livro
		// 4- Editar meu cadastro

		Do $CASE(tOp, 1:##class(estagio.livraria.Livro).Exibir("D"), // *exibe somente livros disponíveis para clientes
					  2:##class(estagio.livraria.Aluguel).Exibir(pCliente), // *exibe somente alugueis do cliente logado
					  3:##class(estagio.livraria.Aluguel).Alugar(pCliente, pFidelidade), // *aluga para cliente logado, passa sua fidelidade para calcular o valor automaticamente
					  4:##class(estagio.livraria.Cadastro).Editar(pCliente), // *edita cadastro do cliente logado
					  :..Sair(.tOp))
	}
	While tOp // retorna para esse menu após cada função, a não ser a função de saída 
	
	Quit
}

/// Saída genérica
ClassMethod Sair(ByRef pOp) As %Status
{
	Set pOp = 0
	Quit $$$OK
}

/// Cria menu de display com opções passadas por argumento e retorna opção digitada pelo usuário
ClassMethod Menu(pOpcao... As %String) As %Integer
{
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "#                        Livraria da Lolo                            #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	
	// contagem e escrita das opções passadas como argumento
	Set args = $GET(pOpcao, 0)

	For i = 1:1:args
	{	
		Write !, "# "_i_"- "_pOpcao(i), ?69,                                      "#"
	}
	
	Write !, "#", " 0- Sair", ?69,                                                "#"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
		
	Read !, ">>> Opção: ", tOp, !
	
	Quit tOp
}

}
