Class estagio.livraria.Interface [ Abstract ]
{

// TO DO:

// // otimizar - revisar e reduzir código

/// Menu de início: em loop até input de saída
ClassMethod Iniciar()
{
	Do
	{
		Write !, "######################################################################"
		Write !, "#                                                                    #"
		Write !, "#                        Livraria da Lolo                            #"
		Write !, "#                                                                    #"
		Write !, "######################################################################"
		Write !, "#                                                                    #"
		Write !, "# 1- Já tenho conta                                                  #"
		Write !, "# 2- Quero me cadastrar                                              #"
		Write !, "# 0- Sair                                                            #"
		Write !, "#                                                                    #"
		Write !, "######################################################################"
		
		Read !, ">>> Opção: ", tOp, !
		
		Do $CASE(tOp, 1:..Login(), 2:..Cadastrar(), :..Sair(.tOp)) // método Sair() modifica tOp para sair do loop e quitar Iniciar()
	}
	While tOp

	Quit
}

/// Menu de cadastro
ClassMethod Cadastrar()
{
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "#                        Livraria da Lolo                            #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "# Cadastro                                                           #"
	Write !, "# 1- Sou Cliente                                                     #"
	Write !, "# 2- Sou Funcionário                                                 #"
	Write !, "# 0- Voltar                                                          #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	
	Read !, ">>> Opção: ", tOp, !
	
	// Cadastro de cliente ou funcionário, devolve ID e se tem Fidelidade
	Set tSC = $CASE(tOp, 1:##class(estagio.livraria.Cadastro).Cadastrar("C", .tID, .tFidelidade), 2:##class(estagio.livraria.Cadastro).Cadastrar("F", .tID, .tFidelidade), :..Sair(.tOp))
	
	// Se der erro no cadastro retorna para início
	Do:'$$$ISERR(tSC) $CASE(tOp, 1:..Cliente(tID, tFidelidade), 2:..Funcionario(), :..Sair(.tOp))
	
	Quit
}

/// Menu de Login - não permite Login de cliente na aba de funcionários, mas o contrário é possível.
ClassMethod Login()
{
	Set tSC = 0
	
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "#                        Livraria da Lolo                            #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "# Login                                                              #"
	Write !, "# 1- Sou Cliente                                                     #"
	Write !, "# 2- Sou Funcionário                                                 #"
	Write !, "# 0- Voltar                                                          #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	
	Read !, ">>> Opção: ", tOp, !
	
	// Login igual para ambas as opções - devolve ID, Fidelidade e se foi funcionário ou cliente que entrou
	Set:((tOp=1)||(tOp=2)) tSC = ##class(estagio.livraria.Cadastro).Login(.tID, .tFidelidade, .tTipo)
	
	// Se conta de cliente foi usada para entrar na aba de funcionários, força erro no login
	If (tOp=2)&&(tTipo="C")
	{
		Write !!, "ACESSO NEGADO.", !!
		
		Set tSC = 0
	}
	
	// se der erro no login retorna para início
	Do:'$$$ISERR(tSC) $CASE(tOp, 1:..Cliente(tID, tFidelidade), 2:..Funcionario(), :..Sair(.tOp))
	
	Quit
}

/// Menu com funções de funcionário
ClassMethod Funcionario()
{
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "#                        Livraria da Lolo                            #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "# 1- Exibir Livros                                                   #"
	Write !, "# 2- Exibir Aluguéis                                                 #"
	Write !, "# 3- Exibir Lucros                                                   #"
	Write !, "# 4- Cadastrar Livro                                                 #"
	Write !, "# 5- Registrar Devolução                                             #"
	Write !, "# 6- Apagar Livros                                                   #"
	Write !, "# 7- Editar Cadastros                                                #"
	Write !, "# 0- Voltar                                                          #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	
	Read !, ">>> Opção: ", tOp, !
	
	Do $CASE(tOp, 1:##class(estagio.livraria.Livro).Exibir(),
				  2:##class(estagio.livraria.Aluguel).Exibir(),
				  3:##class(estagio.livraria.Lucro).Exibir(),
				  4:##class(estagio.livraria.Livro).Cadastrar(),
				  5:##class(estagio.livraria.Aluguel).Devolver(),
				  6:##class(estagio.livraria.Livro).Apagar(),
				  7:##class(estagio.livraria.Cadastro).Editar(),
				  :..Sair(.tOp))
	Do:tOp ..Funcionario() // retorna para esse menu após cada função, a não ser a função de saída
	
	Quit
}

/// Menu com funções de cliente
ClassMethod Cliente(pCliente As %Integer, pFidelidade As %Boolean)
{
	// Id do cliente e se tem fidelidade é passado após login/cadastro para chamada das funções
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "#                        Livraria da Lolo                            #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	Write !, "#                                                                    #"
	Write !, "# 1- Ver livros disponíveis                                          #"
	Write !, "# 2- Exibir seus aluguéis                                            #"
	Write !, "# 3- Alugar livro                                                    #"
	Write !, "# 4- Editar cadastro                                                 #"
	Write !, "# 0- Voltar                                                          #"
	Write !, "#                                                                    #"
	Write !, "######################################################################"
	
	Read !, ">>> Opção: ", tOp, !
	
	Do $CASE(tOp, 1:##class(estagio.livraria.Livro).Exibir("D"), // exibe somente livros disponíveis para clientes
				  2:##class(estagio.livraria.Aluguel).Exibir(pCliente), // exibe somente alugueis do cliente logado
				  3:##class(estagio.livraria.Aluguel).Alugar(pCliente, pFidelidade), // aluga para cliente logado, passa sua fidelidade para calcular o valor automaticamente
				  4:##class(estagio.livraria.Cadastro).Editar(pCliente), // edita cadastro do cliente logado
				  :..Sair(.tOp))
	Do:tOp ..Cliente(pCliente,pFidelidade) // retorna para esse menu após cada função, a não ser a função de saída
	
	Quit
}

/// Saída genérica
ClassMethod Sair(ByRef pOp)
{
	Set pOp = 0
	Quit
}

}
