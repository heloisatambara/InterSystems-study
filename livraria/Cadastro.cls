Class estagio.livraria.Cadastro Extends %Persistent
{

Property Tipo As %String(DISPLAYLIST = ",Cliente,Funcionário", VALUELIST = ",C,F") [ Required ];

Property Usuario As %String [ Required ];

Property Fidelidade As %Boolean;

Property Senha As %String [ Required ];

/// Cadastro - pTipo define se é funcionário ou cliente, devolve ID e se tem Fidelidade
ClassMethod Cadastrar(pTipo As %String, Output pID As %Integer, Output pFidelidade As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		/* INPUT - pede nome de usuário até ser digitado um novo */
		Do
		{
			Read !, ">>> Usuário: ", tUser
			
			Set tROWCOUNT = ..ProcuraNome(tUser, .tFidelidade, .tTipo, .tID)
			
			Write:(tROWCOUNT '= 0) !, "Nome de Usuário já existente." // se achar alguma linha o nome existe
		}
		While (tROWCOUNT '= 0)
		
		
		/* INPUT - pede senha e fidelidade */
		Read !, ">>> Senha: ", tSenha 
		Read:(pTipo="C") !, ">>> Assinar fidelidade? ", tFidelidade
		Set:(pTipo="F") tFidelidade = 1 // funcionário automaticamente tem fidelidade
		
		
		/* CADASTRO */
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Cadastro (Usuario, Senha, Tipo, Fidelidade) VALUES (?,?,?,?)")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tUser, tSenha, pTipo, tFidelidade)
		
		Throw:(tRset.%SQLCODE<0)
		
		
		/* OUTPUT - retorna ID criado e se tem fidelidade */
		Set pID = tRset.%ROWID
		Set pFidelidade = tFidelidade
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro no cadastro"
		Write:$$$ISERR(tSC) !, "Erro no %Prepare:", $SYSTEM.Status.DisplayError(tSC)
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !, "Erro no INSERT:", tRset.%Message
		Write !, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit tSC
}

/// Login - retorna ID do logado, se tem fidelidade e se foi cliente ou funcionário que logou.
ClassMethod Login(Output pId As %Integer, Output pFidelidade As %Boolean, Output pTipo As %String) As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		/* INPUT - pede nome de usuário até que exista */
		Do
		{
			Read !, ">>> Usuário: ", tUser
			
			Set tROWCOUNT = ..ProcuraNome(tUser, .tFidelidade, .tTipo, .tID, .tSenha)
			
			Write:(tROWCOUNT '= 1) !, " Nome de Usuário não existente." //se não achar linhas o nome foi digitado errado - não existe
		}
		While (tROWCOUNT '= 1) 
		
		
		/* INPUT - pede senha até ser digitada corretamente */
		Do
		{
			Read !, ">>> Senha: ", tSenhaI
		
			Write:(tSenhaI '= tSenha) !, "Senha inválida, digite novamente." // comparação exata da senha cadastrada com a digitada (case-sensitive)
		}
		While (tSenhaI '= tSenha)

		
		/* OUTPUT - retorna o ID logado, se tem fidelidade e se foi de cliente ou funcionário */
		Set pId = tID
		Set pFidelidade = tFidelidade
		Set pTipo = tTipo
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro no Login"
		Write:$$$ISERR(tSC) !, "Erro ao procurar usuário digitado:", $SYSTEM.Status.DisplayError(tSC)
		Write $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit tSC
}

/// Edita cadastro de cliente - permite edição de senha e fidelidade. Se passado o ID do cliente, não pergunta qual usuário será alterado.
ClassMethod Editar(pCliente As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		/* INPUT - pega Id do cliente a ser modificado */
		If pCliente = 0 // se a edição foi chamada a partir do menu de funcionário
		{
			Do
			{   
				// procura nome de usuário igual no Login
				Read !, ">>> Usuário: ", tUser
				
				Set tROWCOUNT = ..ProcuraNome(tUser, .tFidelidade, .tTipo, .tID, .tSenha)
				
				Write:(tROWCOUNT '= 1) !, " Nome de Usuário não existente." //se não achar linhas o nome foi digitado errado - não existe
			}
			While (tROWCOUNT '= 1)
		}
		Else // se  a edição foi chamada a partir do menu de cliente - passa o ID do cliente logado
		{
			Set tID = pCliente
		}
		
		/* INPUT - pede dados a ser alterados */
		Read !, ">>> Alterar Senha: ", tSenha
		Read !, ">>> Fidelidade: ", tFidelidade
		
		/* ATUALIZAÇÃO - cria e prepara o UPDATE conforme dados que foram passados para alteração - os deixados em branco são ignorados */
		// UPDATE estagio_livraria.Cadastro SET (Senha = ?) (,) (Fidelidade = ?) WHERE ID = ID
		Set tQuery = "UPDATE estagio_livraria.Cadastro SET "
		Set:(tSenha'="") tQuery = tQuery_"Senha = ?"
		Set:((tSenha'="")&&(tFidelidade'="")) tQuery = tQuery_","
		Set:(tFidelidade'="") tQuery = tQuery_" Fidelidade = ?"
		Set tQuery = tQuery_" WHERE ID = "_tID
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare(tQuery)
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = $SELECT((tSenha=""):tSt.%Execute(tFidelidade), // escolhe os parâmetros a ser passados
							(tFidelidade=""):tSt.%Execute(tSenha), // conforme os dados digitados
							 1:tSt.%Execute(tSenha, tFidelidade))
		
		Throw:(tRset.%SQLCODE<0) // erro de update
	}
	Catch EXC
	{
		/* tratamento de erros */
		Write !, "Erro de Edição"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !, "Erro no UPDATE", tRset.%Message
		Write:$$$ISERR(tSC) !, "Erro no %Prepare", $SYSTEM.Status.DisplayError(tSC)
		Write $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit tSC
}

/// Procura nome digitado e retorna %ROWCOUNT, Fidelidade, Tipo (funcionário ou cliente) e ID
ClassMethod ProcuraNome(pUsuario As %String, Output pFidelidade As %Boolean, Output pTipo As %String, Output pID As %Integer, Output pSenha As %String) As %Integer
{
	Set tSC = $$$OK
	
	Try
	{
		/* QUERY - procura nome inserido */
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("SELECT ID, Fidelidade, Senha, Tipo FROM estagio_livraria.Cadastro WHERE Usuario = ?") // comparação exata (non case-sensitive)
			
		Throw:$$$ISERR(tSC)

		Set tRset = tSt.%Execute(pUsuario)
			
		While tRset.%Next()
		{
			/* contar linhas */
		}
		
		/* OUTPUT - retornos desejados */
		Set pFidelidade = tRset.%Get("Fidelidade"), pTipo = tRset.%Get("Tipo"), pID = tRset.%Get("ID"), pSenha = tRset.%Get("Senha")
	}
	Catch EXC
	{
		/* Tratamento de erros */
		Write !, "Erro ao procurar usuário digitado"
		Write:$$$ISERR(tSC) !, "Erro no %Prepare:", $SYSTEM.Status.DisplayError(tSC) 
		Write !, $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit tRset.%ROWCOUNT
}

Storage Default
{
<Data name="CadastroDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Tipo</Value>
</Value>
<Value name="3">
<Value>Senha</Value>
</Value>
<Value name="4">
<Value>Fidelidade</Value>
</Value>
<Value name="5">
<Value>Usuario</Value>
</Value>
</Data>
<DataLocation>^estagio.livraria.CadastroD</DataLocation>
<DefaultData>CadastroDefaultData</DefaultData>
<ExtentSize>0</ExtentSize>
<IdLocation>^estagio.livraria.CadastroD</IdLocation>
<IndexLocation>^estagio.livraria.CadastroI</IndexLocation>
<StreamLocation>^estagio.livraria.CadastroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
