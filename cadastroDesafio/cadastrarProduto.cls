cadastrarProduto
	
inicio
	NEW nome, desc, preco, ID, ans
 	Do cabecalho^cadastroOFC("Cadastrar Produto")
	Write !, "#",?70,                            "#"
    Read !, "# ID ..............: ", ID
    If (ID'="")&&($DATA(^produto(ID))) { // mostra o cliente cadastrado sobre o ID
	    Write " - ID já cadastrado", ?70, "#" Hang .25
		Do exibirPorID^exibirProdutos(ID) Hang 1
		Read !, "# Deseja sobrescrever os dados? ", ans, ?70, "#"
		If '("SIMsimSim"[ans) { GOTO inicio }
		Else { Write !, "#", ?70, "#" } }
	Else {Write ?70,"#" Hang .25}
	Read !,  "# Nome.............: ", nome, ?70,  "#"
	Read !,  "# Descrição........: ", desc, ?70,  "#"
	Read !,  "# Preço............: ", preco, ?70, "#"
	Write !, "#", ?70,                            "#"
	Write !, tralha Hang .5
 	
    // volta para tela inicial se nenhuma entrada for preenchida
	If ((nome = "") && (desc = "") && (preco = "")) { Quit }
	
    // checa consistência e cadastra
	Do consistencia()
	If ($DATA(nome) && $DATA(desc) && $DATA(preco)) {
		Do cadastra()
		Write !, " Dados cadastrados." Hang .5 }
	Else { // recomeça o cadastro 
		Write !, $Select('$Data(nome):" Nome inválido", '$Data(desc):" Descrição inválida", '$Data(preco):" Preço inválido")
		GOTO inicio	}
	Quit

cadastra() public
	If (ID = "") { // se nenhum ID foi digitado, cria novo
		Set ID = $Order(^produto(""), -1)
		Do $Increment(ID)}
	Set ^produto(ID) = nome_"^"_desc_"^"_preco
	Quit
	
consistencia() public	
	Kill:(nome="") nome // checa existencia
	If '(preco?.NP) || (preco < 0) || (preco = "") { Kill preco } // checa se é numérico e maior que 0
	Else { Set preco = $FNUMBER(preco, "L", 2) } // arruma o formato do preço 10.00
	Quit
