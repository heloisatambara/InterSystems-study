cadastrarCliente
	Do inicio()

 // formato:
 // ^cliente(i)=nome^endereco^telefone^cpf^dataNascimento

inicio()
	NEW num
 // Cabeçalho
	Set tralha = "#######################################################################"
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70,                                       "#"
	Write !, "#", ?27, "Cadastrar Cliente", ?70,             "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70,                                       "#"
	
	Write !, "#", " 1- Cadastrar novo cliente", ?70,         "#"
	Write !, "#", " 2- Alterar cliente já cadastrado", ?70,  "#"
	Write !, "#", " 0- Sair", ?70,                           "#"
	Write !, "#", ?70,                                       "#"
	
	Read !, "# Entre com a opção desejada: ", num Write ?70, "#"
	Write !, "#", ?70,                                       "#"
	Write !, tralha

	Hang .25
 //	


	Quit:'num
	Do $Case(num, 1:novo, 2:alterar, :inicio)
	GOTO inicio+1
	
	Quit
	


novo() public
 // Cabeçalho
 	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70,                          "#"
	Write !, "#", ?27, "Cadastrar Cliente", ?70,"#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70,                          "#"
   //	
	

   // pede informações
	Read !, "# Nome.............: ", nome
	Write ?70, "#" Hang .25
	
	Read !, "# Endereço.........: ", end
	Write ?70, "#" Hang .25
	
	Read !, "# Telefone.........: ", tel
	Write ?70, "#" Hang .25
	
	Read !, "# CPF..............: ", cpf
	Write ?70, "#" Hang .25 
	
	Read !, "# Data Nascimento..: ", nasc
	Write ?70, "#"  Hang .25
	
	Write !, "#", ?70, "#"
	Write !, tralha, !
	Hang .25
 //

 // se nenhum campo for preenchido, volta para a tela inicial
	If ((nome = "") && (end = "") && (tel = "") && (cpf = "") && (nasc = "")) { Quit }
	
	
 // se os campos forem preenchidos, checa consistência dos dados e cadastra, se confirmados
 	// se não for confirmado ou se algum dado não for consistente, recomeça o cadastro
	Do consistencia()
	If ($DATA(nome) && $DATA(end) && $DATA(tel) && $DATA(cpf) && $DATA(nasc)) {
		Read !!, "Enter para confirmar ", enter
		GOTO:'(""[enter) novo+1
		Do cadastra()
		}
	Else { // recomeça o cadastro se algum campo não for preenchido ou se ofr inválido
		Write !, $Select('$Data(nome):"Nome inválido", '$Data(end):"Endereço inválido", '$Data(tel):"Telefone inválido", '$Data(cpf):"CPF inválido", '$Data(nasc):"Data de Nascimento inválida")
		GOTO novo+1
	}
	
	Quit



alterar() public
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Cadastrar Cliente", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
 //	
	
	
 // pede informações para o cadastro
	Read !, "# Qual cliente deseja alterar? ", cliNum
	If (cliNum = "")||'$DATA(^cliente(cliNum)) { Write !, tralha, !!, "Cliente inválido" Hang .5 GOTO alterar+1 }
		// recomeça se o subscript do cliente selecionado não existir
	Write " - ", $Piece(^cliente(cliNum), "^", 1), ?70, "#" Hang .25
		
		
	Read !, "# Qual informação deseja alterar? ", qinfo
	Write " - ", $Case(qinfo, 1:"Nome", 2:"Endereço", 3:"Telefone", 4:"CPF", 5:"Nascimento", :"Nada será alterado"), ?70, "#" Hang .25
	
	
	
 // aqui as informações para alteração serão recebidas e consistências checadas	
	If (qinfo = 3) { // info de telefone
		Read !, "# Digite a nova informação: +55 (",  ddd#2,") ", tel1#5, "-", tel2#4
		If '((ddd?2N) && (tel1?5N) && (tel2?4N)){ Write !, tralha, !, "Telefone inválido" GOTO alterar+1 }
		Set info = "("_ddd_") "_tel1_"-"_tel2
		Write ?70, "#" Hang .5
	}
		
	Elseif (qinfo = 4) { // info de cpf
		Read:(qinfo = 4) !, "# Digite a nova informação: ", dig1#3, ".", dig2#3, ".", dig3#3, "-", dig4#2
		If '((dig1?3N) && (dig2?3N) && (dig3?3N) && (dig4?2N)){ Write !, tralha, !, "CPF inválido" GOTO alterar+1 }
		Set:(qinfo = 4) info = dig1_"."_dig2_"."_dig3_"-"_dig4
		Write ?70, "#" Hang .5
	}
	
	Elseif (qinfo = 5) { // info de data
		Read:(qinfo = 5) !, "# Digite a nova informação: ", dia#2, "/", mes#2, "/", ano#4
		Set:(qinfo = 5) info = dia_"/"_mes_"/"_ano
		Try { Set aux = $Zdateh(info, 4) }
		Catch err { Write !, tralha, !, "Data inválida" GOTO alterar+1 }
		Write ?70, "#" Hang .5
	}
		
	Else { // outras info
		Read !, "# Digite a nova informação: ", info
		Write ?70, "#" Hang .5	
	}
	
	
	Write !, "#", ?70, "#"
	Write !, tralha, !
 //
 
 
 // volta para tela inicial se alguma entrada não for preenchida
	If (cliNum = "")||(info = "")||(qinfo = "") { Quit }
	
	
 // caso desista, salva a informação antes de alterar
	Set aux = $Piece(^cliente(cliNum), "^", qinfo)
 	Set $Piece(^cliente(cliNum), "^", qinfo) = info
	
	
 // mostrar alteração
	Write !!, "|   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
	Set nome = $Piece(^cliente(cliNum), "^", 1)
	Set end = $Piece(^cliente(cliNum), "^", 2)
	If $LENGTH(nome) > 10 { Set $Extract(nome,7, *) = "..."}
	If $LENGTH(end) > 18 { Set $Extract(end,15, *) = "..."}
	Write !, ?1, nome, ?12, end, ?32, $Piece(^cliente(cliNum), "^", 3), ?49, $Piece(^cliente(cliNum), "^", 4), ?65, $Piece(^cliente(cliNum), "^", 5)
	
	
	Read !!, "Enter para confirmar ", enter 
	If '(""[enter) {
		Set $Piece(^cliente(cliNum), "^", qinfo) = aux
		GOTO alterar+1
	}
	
	Quit
	
	



cadastra() public
	Set ID = $Order(^cliente(""), -1)
	Do $Increment(ID)
	Set ^cliente(ID) = nome_"^"_end_"^"_tel_"^"_cpf_"^"_nasc
	
	Quit
	

consistencia() public
  // arrumar formatos
   // telefone 
	Set tel = $Translate($Get(tel), " -()", "") 
	Set:$DATA(tel) tel = "("_$Extract(tel, 1,2)_") "_$Extract(tel, 3,7)_"-"_$Extract(tel, 8,11)
	
   // CPF
	If $Get(cpf)?11N { Set cpf = $Extract(cpf,1,3)_"."_$Extract(cpf,4,6)_"."_$Extract(cpf,7,9)_"-"_$Extract(cpf,10,11)  }
	
   // Data de Nascimento
	If $Piece($Get(nasc), "/", 1)?1N { Set nasc = "0"_nasc }
	If $Piece($Get(nasc), "/", 2)?1N { Set $Piece(nasc, "/", 2) = "0"_$Piece($Get(nasc), "/", 2) }
	
	Try { Set aux = $Zdateh(nasc, 4) }
	Catch err { Kill nasc }
	
	Kill:'(nome?1.ACP) nome
	Kill:'(end?1.APN) end
	Kill:'(tel?1(1"("2N1") ",2N1" ",2N)1(5N1"-"4N,5N1" "4N,9N)) tel
	Kill:'(cpf?1(3N1"."3N1"."3N1"-"2N,11N)) cpf
