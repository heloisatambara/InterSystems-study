realizarPedido

inicio
 	NEW ID, ans, cli, prod, qtd
	Do cabecalho^cadastroOFC("realizarPedido")

   // pede informações para cadastro
    Read !, "# ID ..............: ", ID
    If (ID'="")&&($DATA(^pedido(ID))) { // mostra o cliente cadastrado sobre o ID
	    Write " - ID já cadastrado", ?70, "#" Hang .25
		Do exibirPorID^exibirPedidos(ID) Hang 1
		Read !, "# Deseja sobrescrever os dados? ", ans, ?70, "#"
		If '("SIMsimSim"[ans) { GOTO inicio }
		Else { Write !, "#", ?70, "#" } }
	Else {Write ?70,"#" Hang .25}
	
	Read !, "# Cliente..........: ", cli
	If ((cli '= "")&&$DATA(^cliente(cli))) { Write " - ", $Piece(^cliente(cli), "^", 1)} // consistencia
	Write ?70, "#"
	
	Read !, "# Produto..........: ", prod
	If ((prod '= "")&&$DATA(^produto(prod))) { Write " - ", $Piece(^produto(prod), "^", 1)} // consistencia
	Write ?70, "#"
	
	Read !, "# Quantidade.......: ", qtd, ?70, "#"
	
	Write !, "#", ?70, "#"
	Write !, tralha Hang .5
 
    // volta para tela inicial se nenhuma entrada for preenchida
	If ((cli = "") && (prod = "") && (qtd = "")) { Quit }
	
    // checa consistência e cadastra
	Do consistencia()
	If ($DATA(cli) && $DATA(prod) && $DATA(qtd)) {
		Do cadastra()
		Write !, " Dados cadastrados." Hang .5 }
	Else { // recomeça o cadastro 
		Write !, $Select('$Data(cli):" Cliente inválido", '$Data(prod):" Produto inválido", '$Data(qtd):" Quantidade inválida")
		GOTO inicio	}
		
	Quit
	
	
cadastra() public
	NEW cliString, prodString
	Set cliString = $Piece(^cliente(cli), "^", 1) // guarda nome do cliente escolhido
	Set prodString = $Piece(^produto(prod), "^", 1) // guarda nome do produto escolhido
	If (ID = "") { // cria ID se não foi escolhido
		Set ID = $Order(^pedido(""), -1)
		Do $Increment(ID)}
	Set ^pedido(ID) = "("_cli_") "_cliString_"^"_"("_prod_") "_prodString_"^"_qtd
	Quit
	
consistencia() public
	Kill:((cli="")||'$DATA(^cliente(cli))) cli // checa existencia
	Kill:((prod="")||'$DATA(^produto(prod))) prod // checa exitencia
	Kill:('(qtd?.N)||(qtd < 0)||(qtd="")) qtd // checa se é numéricoe se é maior que 0
	Quit
