realizarPedido

 // formatos:
 // ^pedido(1)=cliente^produto^quantidade
 
	Do inicio()

inicio()
 // Cabeçalho
 //	Set tralha = "#######################################################################"
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?28, "Realizar Pedido", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
   //
 
 
   // pede informações para cadastro	
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
		}
	Else { // recomeça o cadastro se algum campo não for preenchido ou se for inválido
		Write !, $Select('$Data(cli):"Cliente inválido", '$Data(prod):"Produto inválido", '$Data(qtd):"Quantidade inválida")
		GOTO inicio+1
	}
	
	Quit
	
	
cadastra() public
	Set cliString = $Piece(^cliente(cli), "^", 1)
	Set prodString = $Piece(^produto(prod), "^", 1)
	Set ID = $Order(^pedido(""), -1)
	Do $Increment(ID)
	Set ^pedido(ID) = "("_cli_") "_cliString_"^"_"("_prod_") "_prodString_"^"_qtd
	
	Quit
	
	
consistencia() public
	Kill:((cli="")||'$DATA(^cliente(cli))) cli
	Kill:((prod="")||'$DATA(^produto(prod))) prod
	Kill:('(qtd?.N)||(qtd < 0)||(qtd="")) qtd
	
	Quit
