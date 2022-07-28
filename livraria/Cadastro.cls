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
		Do
		{
			// Pede nome de usuário
			Read !, ">>> Usuário: ", tUser
			
			// query para testar se o nome já está sendo utilizado
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("SELECT Usuario FROM estagio_livraria.Cadastro WHERE Usuario = ?") // comparação exata
			
			Throw:$$$ISERR(tSC)

			Set tRset = tSt.%Execute(tUser)
			
			While tRset.%Next()
			{
				/* contar linhas */
			}
			
			Write:(tRset.%ROWCOUNT '= 0) !, "Nome de Usuário já existente."
		}
		While (tRset.%ROWCOUNT '= 0) // se achar alguma linha o nome existe
		
		// pede criação de senha e pergunta se desja fidelidade
		Read !, ">>> Senha: ", tSenha 
		Read:(pTipo="C") !, ">>> Assinar fidelidade? ", tFidelidade
		
		// se for cadastro de funcionário, associa fidelidade automaticamente
		Set:(pTipo="F") tFidelidade = 1
		
		// prepara insert
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare("INSERT INTO estagio_livraria.Cadastro (Usuario, Senha, Tipo, Fidelidade) VALUES (?,?,?,?)")
		
		Throw:$$$ISERR(tSC)
		
		Set tRset = tSt.%Execute(tUser, tSenha, pTipo, tFidelidade)
		Set pID = tRset.%ROWID
		Set pFidelidade = tFidelidade
		// retorna ID criado e se tem fidelidade
		
	}
	Catch EXC
	{
		Write !, "Erro no cadastro"
		Write:$$$ISERR(tSC) !, "A", $SYSTEM.Status.DisplayError(tSC)
		Write !, "B", $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit tSC
}

/// Login - retorna ID do logado, se tem fidelidade e se foi cliente ou funcionário que logou.
ClassMethod Login(Output pId As %Integer, Output pFidelidade As %Boolean, Output pTipo As %String) As %Status
{
	Set tSC = $$$OK
	
	Try
	{
		Do
		{
			// pede nome de usuário até que exista
			Read !, ">>> Usuário: ", tUser
			
			Set tSt = ##class(%SQL.Statement).%New()
			Set tSC = tSt.%Prepare("SELECT ID, Fidelidade, Senha, Tipo FROM estagio_livraria.Cadastro WHERE Usuario = ?") // comparação exata (non case-sensitive)
			
			Throw:$$$ISERR(tSC)

			Set tRset = tSt.%Execute(tUser)
			
			While tRset.%Next()
			{
				/* contar linhas */
			}
			
			Write:(tRset.%ROWCOUNT '= 1) !, " Nome de Usuário não existente."
		}
		While (tRset.%ROWCOUNT '= 1) //se não achar linhas o nome foi digitado errado - não existe
		
		
		Do
		{
			Read !, ">>> Senha: ", tSenha
		
			Write:(tSenha '= tRset.%Get("Senha")) !, "Senha inválida, digite novamente." // comparação exata da senha cadastrada com a digitada (case-sensitive)
		}
		While (tSenha '= tRset.%Get("Senha")) // pede de novo até a senha ser digitada corretamente
		
		Set pId = tRset.%Get("ID")
		Set pFidelidade = tRset.%Get("Fidelidade")
		Set pTipo = tRset.%Get("Tipo")
		// retorna o ID logado, se tem fidelidade e se foi de cliente ou funcionário
		
	}
	Catch EXC
	{
		Write !, "Erro no Login"
		Write:$$$ISERR(tSC) !, $SYSTEM.Status.DisplayError(tSC)
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
		If pCliente = 0 // se a edição foi chamada a partir do menu de funcionário
		{
			Do
			{   
				// Confere nome de usuário igual no Login
				Read !, ">>> Usuário: ", tUser
				
				Set tSt = ##class(%SQL.Statement).%New()
				Set tSC = tSt.%Prepare("SELECT ID FROM estagio_livraria.Cadastro WHERE Usuario = ?")
				
				Throw:$$$ISERR(tSC)

				Set tRset = tSt.%Execute(tUser)
				
				While tRset.%Next()
				{
					/* contar linhas */
				}
				
				Write:(tRset.%ROWCOUNT '= 1) !, " Nome de Usuário não existente."
			}
			While (tRset.%ROWCOUNT '= 1)
			
			Set tID = tRset.%Get("ID")
		}
		Else
		{
			// se  a edição foi chamada a partir do menu de cliente, passa o ID do cliente logado
			Set tID = pCliente
		}
		
		// pede dados a ser alterados
		Read !, ">>> Alterar Senha: ", tSenha
		Read !, ">>> Fidelidade: ", tFidelidade
		
		// cria e prepara o UPDATE conforme dados que foram passados para alteração - os deixados em branco são ignorados
		Set tQuery = "UPDATE estagio_livraria.Cadastro SET "
		Set:(tSenha'="") tQuery = tQuery_"Senha = ?"
		Set:((tSenha'="")&&(tFidelidade'="")) tQuery = tQuery_","
		Set:(tFidelidade'="") tQuery = tQuery_" Fidelidade = ?"
		Set tQuery = tQuery_" WHERE ID = "_tID
		Set tSt = ##class(%SQL.Statement).%New()
		Set tSC = tSt.%Prepare(tQuery)
		
		Throw:$$$ISERR(tSC)
		
		// executa segundo dados que foram digitados - ignora dados deixados em branco
		Set tRset = $SELECT((tSenha=""):tSt.%Execute(tFidelidade), (tFidelidade=""):tSt.%Execute(tSenha), 1:tSt.%Execute(tSenha, tFidelidade))
		
		Throw:(tRset.%SQLCODE<0) // erro de update
	}
	Catch EXC
	{
		Write !, "Erro de Edição"
		Write:($DATA(tRset)&&(tRset.%SQLCODE<0)) !!, tRset.%Message
		Write:$$$ISERR(tSC) !, $SYSTEM.Status.DisplayError(tSC)
		Write $SYSTEM.Status.DisplayError(EXC.AsStatus())
	}
	
	Quit tSC
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
