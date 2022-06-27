atualizarDados

inicio
	NEW num
	Do cabecalho^cadastroOFC("Atualizar Dados")
	Write !, "#", " Menu", ?70,                              "#"
	Write !, "#", " 1- Atualizar dados de clientes", ?70,    "#"
	Write !, "#", " 2- Atualizar dados de produtos",?70,     "#"
	Write !, "#", " 3- Atualizar dados de pedidos", ?70,     "#"
	Write !, "#", " 0- Sair", ?70,                           "#"
	Write !, "#", ?70,                                       "#"
	Read !, "# Entre com a opção desejada: ", num Write ?70, "#"
	Write !, "#", ?70,                                       "#"
	Write !, tralha
	
	Do $Case(num, 1:atualizarCliente, 2:atualizarProduto, 3:atualizarPedido, :inicio)
	Quit



atualizarCliente
	NEW num, qinfo, aux, nome, end, enter
	Do cabecalho^cadastroOFC("Atualizar Cliente")
	// informações para a alteração
	Read !, "# Qual cliente deseja alterar? ", num
	If (num = "")||'$DATA(^cliente(num)) {
		Write ?70, "#", !, "#", ?70, "#", !, tralha, !!, " Cliente inválido"
		Hang .5
		GOTO atualizarCliente+1 } // consistencia
	Else {
		Set cliente = ^cliente(num)
		Write " - ", $Piece(cliente, "^", 1), ?70, "#"
		Hang .25 }
		
	Read !, "# Qual informação deseja alterar? ", qinfo
	Write " - ", $Case(qinfo, 1:"Nome", 2:"Endereço", 3:"Telefone", 4:"CPF", 5:"Nascimento", :"Nada será alterado"), ?70, "#"
	Hang .25
	
	Read !, "# Digite a nova informação: ", info, ?70, "#"
	Hang .5
	Write !, "#", ?70, "#"
	Write !, tralha, !
 
 	Quit:(info = "")||(qinfo = "") // campos vazios retornam ao inicio
  
    // consistencia
	Set bool = $$consistenciaCl(info, qinfo)
	If (bool=1) {
		Write !, " Dados inválidos"
		Hang 1 }
	Else {
	 	Set $Piece(cliente, "^", qinfo) = bool
	    // mostrar alteração
	 	Write !, tralha
		Do exibirPorID^exibirClientes(cliente)		
		Write !, tralha
		
		Read !!, " Enter para confirmar ", enter 
		If '(""[enter) {
			GOTO atualizarCliente }
		Else {
			Set ^cliente(num) = cliente
			Write !!, " Dados alterados."
			Hang 1} }
	Quit

consistenciaCl(info, qinfo)
	If (qinfo>3) {
		Quit:(info="") 1 } // checa se houve input no nome e endereço
	If (qinfo=3) { // checa validade e arruma formato do telefone
		Set info = $Translate($Get(info), " -()", "") 
		If ($Get(info)?11N) {
			Set info = "("_$Extract(info, 1,2)_") "_$Extract(info, 3,7)_"-"_$Extract(info, 8,11) }
		Else {
			Quit 1 } }
	If (qinfo=4) { // checa validade e arruma formato do cpf
		Set info = $Translate($Get(info), " .-", "")
		If ($Get(info)?11N) {
			Set info = $Extract(info,1,3)_"."_$Extract(info,4,6)_"."_$Extract(info,7,9)_"-"_$Extract(info,10,11) }
		Else {
			Quit 1 } }
 	If (qinfo=5) { // checa validade e arruma formato da data
	 	If $Piece($Get(info), "/", 1)?1N {
		 	Set info = "0"_info }
		If $Piece($Get(info), "/", 2)?1N {
			Set $Piece(info, "/", 2) = "0"_$Piece($Get(info), "/", 2) }
		Try {
			Set aux = $Zdateh(info, 4) }
		Catch err {
			Set info = 1 } }	
	If (qinfo>5) {
		Set info = 1 }
	Quit info

	
	
atualizarProduto
	NEW num, qinfo, aux, nome, end, enter
	Do cabecalho^cadastroOFC("Atualizar Produto")
    // informações para a alteração
	Read !, "# Qual produto deseja alterar? ", num
   	If (num = "")||'$DATA(^produto(num)) {
	   	Write ?70, "#", !, "#", ?70, "#", !, tralha, !!, "Produto inválido"
	   	Hang .5
	   	GOTO atualizarProduto+1 } // consistencia
	Else {
		Set produto = ^produto(num)
		Write " - ", $Piece(produto, "^", 1), ?70, "#"
		Hang .25 }	
		
	Read !, "# Qual informação deseja alterar? ", qinfo
	Write " - ", $Case(qinfo, 1:"Nome", 2:"Descrição", 3:"Preço", :"Nada será alterado"), ?70, "#"
	Hang .25
	
	Read !, "# Digite a nova informação: ", info, ?70, "#"
	Hang .5
	Write !, "#", ?70, "#"
	Write !, tralha, !
	
 	// consistencia
 	Quit:(info = "")||(qinfo = "") // campos vazios retornam ao inicio
 	
 	Set bool = $$consistenciaPr(info, qinfo)
	If (bool=1) { Write !, " Dados inválidos"
	Hang 1 }
	Else {
	 	Set $Piece(produto, "^", qinfo) = bool
	    // mostrar alteração
		Write !, tralha
		Do exibirPorID^exibirProdutos(produto)
		Write !, tralha
		
		Read !!, " Enter para confirmar ", enter 
		If '(""[enter) {
			GOTO atualizarProduto }
		Else {
			Set ^produto(num) = produto
			Write !!, " Dados alterados."
			Hang 1} }
	Quit
  
consistenciaPr(info, qinfo)
	If (qinfo=1) {
		Set:(info="") info = 1 } // checa se há entrada no nome
	If (qinfo=3) { // checa se preço é válido
		If '(info?.NP) || (info < 0) || (info = "") {
			Set info = 1 }
		Else {
			Set info = $FNUMBER(info, "L", 2) } }  // arruma o formato do preço
	Quit info
	
	
	
atualizarPedido
	NEW num, qinfo, aux, enter
	Do cabecalho^cadastroOFC("Atualizar Pedido")
	Write !, "#", ?70, "#"
    // informações para a alteração
	Read !, "# Qual pedido deseja alterar? ", num
	If (num = "")||'$DATA(^pedido(num)) {
		Write ?70, "#", !, "#", ?70, "#", !, tralha, !!, "Pedido inválido"
		Hang .5
		GOTO atualizarPedido+1 } // consistencia
	Else {
		Set pedido = ^pedido(num)
		Write " - ", $Piece(pedido, "^", 1), ?70, "#"
		Hang .25	 }
		
	Read !, "# Qual informação deseja alterar? ", qinfo
	Write " - ", $Case(qinfo, 1:"Cliente", 2:"Produto", 3:"Quantidade", :"Nada será alterado"), ?70, "#"
	Hang .25
	
	Read !,  "# Digite a nova informação: ", info, ?70, "#"
	Hang .5
	Write !, "#", ?70, "#"
	Write !, tralha, !
	
 	// consistencia
 	Quit:(info = "")||(qinfo = "") // campos vazios retornam ao inicio
 	
 	Set bool = $$consistenciaPe(info, qinfo)
	If (bool=1) {
		Write !, " Dados inválidos"
		Hang 1 }
	Else {
	 	Set $Piece(pedido, "^", qinfo) = bool	
	    // mostra alteração
		Write !, tralha
		Do exibirPorID^exibirPedidos(pedido)
		Write !, tralha
		
		Read !!, " Enter para confirmar ", enter 
		If '(""[enter) {
			GOTO atualizarPedido }
		Else {
			Set ^pedido(num) = pedido
			Write !!, " Dados alterados."
			Hang 1} }
	Quit

consistenciaPe(info, qinfo)
	If (qinfo=1) { // checa se o cliente existe
		Quit:((info="")||'$DATA(^cliente(info))) 1
		Set info = "("_info_") "_$Piece(^cliente(info), "^", 1) }
	If (qinfo=2) { // checa se o produto existe
		Quit:((info="")||'$DATA(^produto(info))) 1
		Set info = "("_info_") "_$Piece(^produto(info), "^", 1) }
	If (qinfo=3) {
		Set:('(info?.N)||(info < 0)||(info="")) info = 1 } // checa se é quantidade válida
	Quit info
