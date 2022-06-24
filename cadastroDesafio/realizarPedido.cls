realizarPedido

inicio
 // Cabeçalho
	NEW hora, ID, ans, cli, prod, qtd
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?28, "Realizar Pedido", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
   //
 
   // pede informações para cadastro
    Read !, "# ID ..............: ", ID
    If (ID'="")&&($DATA(^pedido(ID))) { // mostra o cliente cadastrado sobre o ID
	    Write " - ID já cadastrado", ?70, "#" Hang .25
		Do exibirPorID^exibirPedidos(ID) Hang 1
		Read !, "# Deseja sobrescrever os dados? ", ans, ?70, "#"
		If '("SIMsimSim"[ans) { GOTO inicio }
		Else { Write !, "#", ?70, "#" }
	    }
	Else {Write ?70,"#" Hang .25}
	
	Read !, "# Cliente..........: ", cli
	If ((cli '= "")&&$DATA(^cliente(cli))) { Write " - ", $Piece(^cliente(cli), "^", 1)}
	Write ?70, "#"
	Read !, "# Produto..........: ", prod
	If ((prod '= "")&&$DATA(^produto(prod))) { Write " - ", $Piece(^produto(prod), "^", 1)}
	Write ?70, "#"
	Read !, "# Quantidade.......: ", qtd
	Write ?70, "#"
	
	Write !, "#", ?70, "#"
	Write !, tralha Hang .5
 //
	
	
 // volta para tela inicial se nenhuma entrada for preenchida
	If ((cli = "") && (prod = "") && (qtd = "")) { Quit }
	
	
 // se os campos forem preenchidos, checa consistência dos dados e cadastra
	Do consistencia()
	If ($DATA(cli) && $DATA(prod) && $DATA(qtd)) {
		Do cadastra()
		Write !, " Dados cadastrados." Hang .5
		}
	Else { // recomeça o cadastro se algum campo não for preenchido ou se for inválido
		Write !, $Select('$Data(cli):" Cliente inválido", '$Data(prod):" Produto inválido", '$Data(qtd):" Quantidade inválida")
		GOTO inicio
		}
	Quit
	
	
cadastra() public
	NEW cliString, prodString
	Set cliString = $Piece(^cliente(cli), "^", 1)
	Set prodString = $Piece(^produto(prod), "^", 1)
	If (ID = "") {
		Set ID = $Order(^pedido(""), -1)
		Do $Increment(ID)
	}
	Set ^pedido(ID) = "("_cli_") "_cliString_"^"_"("_prod_") "_prodString_"^"_qtd
	Quit
	
	
	
consistencia() public
	Kill:((cli="")||'$DATA(^cliente(cli))) cli
	Kill:((prod="")||'$DATA(^produto(prod))) prod
	Kill:('(qtd?.N)||(qtd < 0)||(qtd="")) qtd
	Quit
