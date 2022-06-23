cadastrarProduto
 // formato:
 // ^produto(i)=nome^descricao^preco
 
 	Do inicio()
 	
inicio()
 // Cabeçalho
 //	Set tralha = "#######################################################################"
	Set hora = $Zdatetime($Horolog, 4, 2) 

	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?26, "Cadastrar Produto", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#",?70, "#"
   //


   // pede informações para cadastro
	Read !, "# Nome.............: ", nome
	Write ?70, "#"
	Read !, "# Descrição........: ", desc
	Write ?70, "#"
	Read !, "# Preço............: ", preco
	Write ?70, "#"

	Write !, "#", ?70, "#"
	Write !, tralha Hang .5
 //
 	
	
 // volta para tela inicial se nenhuma entrada for preenchida
	If ((nome = "") && (desc = "") && (preco = "")) { Quit }
	
	
 // se os campos forem preenchidos, checa consistência dos dados e cadastra
	Do consistencia()
	If ($DATA(nome) && $DATA(desc) && $DATA(preco)) {
		Do cadastra()
		}
	Else { // recomeça o cadastro se algum campo não for preenchido ou se for inválido
		Write !, $Select('$Data(nome):"Nome inválido", '$Data(desc):"Descrição inválida", '$Data(preco):"Preço inválido")
		GOTO inicio+1
	}
	
	Quit





cadastra() public
	Set ID = $Order(^produto(""), -1)
	Do $Increment(ID)
	Set ^produto(ID) = nome_"^"_desc_"^"_preco
	
	Quit
	
	
	
	
consistencia() public	
	Kill:(nome="") nome
	If '(preco?.NP) || (preco < 0) || (preco = "") { Kill preco }
	Else { Set preco = $FNUMBER(preco, "L", 2) } // arruma o formato do preço
	
	Quit
