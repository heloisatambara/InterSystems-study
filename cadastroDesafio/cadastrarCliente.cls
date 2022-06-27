cadastrarCliente

inicio
	NEW nome, end, tel, cpf, nasc, enter, ans, ID
 	Do cabecalho^cadastroOFC("Cadastrar Cliente")
	Write !, "#", ?70, "#"

    Read !, "# ID ..............: ", ID
    If (ID'="")&&($DATA(^cliente(ID))) { // mostra o cliente cadastrado sobre o ID
	    Write " - ID já cadastrado", ?70, "#" Hang .25
		Do exibirPorID^exibirClientes(ID) Hang 1
		Read !, "# Deseja sobrescrever os dados? ", ans, ?70, "#"
		If '("SIMsimSim"[ans) { GOTO inicio }
		Else { Write !, "#", ?70, "#" }
	    }
	Else {Write ?70,"#" Hang .25}
	Read !,  "# Nome.............: ", nome, ?70, "#" Hang .25
	Read !,  "# Endereço.........: ", end, ?70,  "#" Hang .25
	Read !,  "# Telefone.........: ", tel, ?70,  "#" Hang .25
	Read !,  "# CPF..............: ", cpf, ?70,  "#" Hang .25
	Read !,  "# Data Nascimento..: ", nasc, ?70, "#" Hang .25
	Write !, "#", ?70,                           "#"
	Write !, tralha, !
	Hang .25

	Quit:(nome_end_tel_cpf_nasc = "") // nenhum valor retorna p inicio
	
	Read !!, " Enter para confirmar ", enter
  
	Set bool = $$consistencia(nome, end, tel, cpf, nasc, ID)
	If 'bool { Write !!, " Dados inválidos" }
	Else { Write !!, " Dados adicionados." }
	Hang 1
	Quit


consistencia(nome, end, tel, cpf, nasc, ID)
	Set tel = $Translate($Get(tel), " -()", "") // checa se é telefone válido
	If ($Get(tel)?11N) { Set tel = "("_$Extract(tel, 1,2)_") "_$Extract(tel, 3,7)_"-"_$Extract(tel, 8,11) } // formato do telefone (NN) NNNNN-NNNN
	Else { Set tel = "" }
	
	Set cpf = $Translate($Get(cpf), " .-", "") // checa se é cpf valido e arruma formato
	If ($Get(cpf)?11N) { Set cpf = $Extract(cpf,1,3)_"."_$Extract(cpf,4,6)_"."_$Extract(cpf,7,9)_"-"_$Extract(cpf,10,11) } // formato do cpf NNN.NNN.NNN-NN
	Else { Set cpf = "" }
 
 	If $Piece($Get(nasc), "/", 1)?1N { Set nasc = "0"_nasc }
	If $Piece($Get(nasc), "/", 2)?1N { Set $Piece(nasc, "/", 2) = "0"_$Piece($Get(nasc), "/", 2) } // formato da data DD/MM/AAAA
	Try { Set aux = $Zdateh(nasc, 4) } // checa se é uma data possível
	Catch { Set nasc = "" }
	
	Set cliente = "^"_$Get(nome)_"^"_$Get(end)_"^"_$Get(tel)_"^"_$Get(cpf)_"^"_$Get(nasc)_"^"
	Quit:$Find(cliente, "^^") 0 // se algum dado não foi inserido, não é consistente

	
	// se chegou até aqui sem quitar, cadastra
	If (ID = "") { // cria ID novo se nenhum foi inserido
		Set ID = $Order(^cliente(""), -1)
		Do $Increment(ID)}
	Set ^cliente(ID) = $Piece(cliente, "^", 2, 6)
	Quit ID

