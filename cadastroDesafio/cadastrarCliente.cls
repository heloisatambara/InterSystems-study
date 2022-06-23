cadastrarCliente
inicio
	NEW hora, num
 // Cabeçalho
	// Set tralha = "#######################################################################"
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
	
	Quit
	





novo() public
	NEW hora, nome, end, tel, cpf, nasc, enter
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
 
	Quit:(nome_end_tel_cpf_nasc = "") // nenhum valor retorna p inicio
	
	
	Read !!, "Enter para confirmar ", enter
	  
	Set bool = $$consistencia(nome, end, tel, cpf, nasc)
	
	If 'bool { Write !!, "Dados inválidos" }
	Else {
		Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
		Set nome = $Piece(^cliente(bool), "^", 1)
		Set end = $Piece(^cliente(bool), "^", 2)
		If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
		If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
		Write !, bool, ?2, nome, ?13, end, ?33, $Piece(^cliente(bool), "^", 3), ?50, $Piece(^cliente(bool), "^", 4), ?66, $Piece(^cliente(bool), "^", 5)
		Write !!, " Dados adicionados."
	}
	
	Hang .5
	
  
	Quit



alterar() public
	NEW hora, num, qinfo, aux, nome, end, enter
 // Cabeçalho
	Set hora = $Zdatetime($Horolog, 4, 2) 
	
	Write !!, tralha
	Write !, "#", ?70, "#"
	Write !, "#", ?27, "Cadastrar Cliente", ?70, "#"
	Write !, "#", $Justify(hora_" #", 70)
	Write !, tralha
	Write !, "#", ?70, "#"
 //	
	
	
 // informações para a alteração
	Read !, "# Qual cliente deseja alterar? ", num
	If (num = "")||'$DATA(^cliente(num)) { Write !, tralha, !!, "Cliente inválido" Hang .5 GOTO alterar+1 } // consistencia
	Write " - ", $Piece(^cliente(num), "^", 1), ?70, "#" Hang .25	
		
	Read !, "# Qual informação deseja alterar? ", qinfo
	Write " - ", $Case(qinfo, 1:"Nome", 2:"Endereço", 3:"Telefone", 4:"CPF", 5:"Nascimento", :"Nada será alterado"), ?70, "#" Hang .25
	
	Read !, "# Digite a nova informação: ", info
	Write ?70, "#" Hang .5
	
	
	Write !, "#", ?70, "#"
	Write !, tralha, !
 //
 
 	Quit:(info = "")||(qinfo = "") // campos vazios retornam ao inicio
  
  
  // consistencia
	Set bool = $$consistencia2(info, qinfo)
	If (bool=1) { Write !, "Dados inválidos" }
	
	Else {
	 // salva a info antiga antes de alterar
		Set aux = $Piece(^cliente(num), "^", qinfo)
	 	Set $Piece(^cliente(num), "^", qinfo) = bool
	 	
	 // mostrar alteração
		Write !!, " |   Nome   |     Endereço     |    Telefone    |      CPF      | Nascimento |"
		Set nome = $Piece(^cliente(num), "^", 1)
		Set end = $Piece(^cliente(num), "^", 2)
		If $LENGTH(nome) > 11 { Set $Extract(nome,8, *) = "..."}
		If $LENGTH(end) > 19 { Set $Extract(end,16, *) = "..."}
		Write !, num, ?2, nome, ?13, end, ?33, $Piece(^cliente(num), "^", 3), ?50, $Piece(^cliente(num), "^", 4), ?66, $Piece(^cliente(num), "^", 5)
		
		
		Read !!, "Enter para confirmar ", enter 
		If '(""[enter) {
			Set $Piece(^cliente(num), "^", qinfo) = aux
			GOTO alterar+1
		}
		Else { Write !!, " Dados alterados." Hang .5}
	}
	
	Quit
	
	

consistencia(nome, end, tel, cpf, nasc)
	Set tel = $Translate($Get(tel), " -()", "") 
	If ($Get(tel)?11N) { Set tel = "("_$Extract(tel, 1,2)_") "_$Extract(tel, 3,7)_"-"_$Extract(tel, 8,11) }
	Else { Set tel = "" }
	
	Set cpf = $Translate($Get(cpf), " .-", "")
	If ($Get(cpf)?11N) { Set cpf = $Extract(cpf,1,3)_"."_$Extract(cpf,4,6)_"."_$Extract(cpf,7,9)_"-"_$Extract(cpf,10,11) }
	Else { Set cpf = "" }
 
 	If $Piece($Get(nasc), "/", 1)?1N { Set nasc = "0"_nasc }
	If $Piece($Get(nasc), "/", 2)?1N { Set $Piece(nasc, "/", 2) = "0"_$Piece($Get(nasc), "/", 2) }
	Try { Set aux = $Zdateh(nasc, 4) }
	Catch { Set nasc = "" }
	
	Set cliente = "^"_$Get(nome)_"^"_$Get(end)_"^"_$Get(tel)_"^"_$Get(cpf)_"^"_$Get(nasc)_"^"
	Quit:$Find(cliente, "^^") 0
	
	
	Set ID = $Order(^cliente(""), -1)
	Do $Increment(ID)
	Set ^cliente(ID) = $Piece(cliente, "^", 2, 6)
	Quit ID

consistencia2(info, qinfo)
	If (qinfo>3) { Quit:(info="") 1 }
	
	If (qinfo=3) {
		Set info = $Translate($Get(info), " -()", "") 
		If ($Get(info)?11N) { Set info = "("_$Extract(info, 1,2)_") "_$Extract(info, 3,7)_"-"_$Extract(info, 8,11) }
		Else { Quit 1 }
	}

	If (qinfo=4) {
		Set info = $Translate($Get(info), " .-", "")
		If ($Get(info)?11N) { Set info = $Extract(info,1,3)_"."_$Extract(info,4,6)_"."_$Extract(info,7,9)_"-"_$Extract(info,10,11) }
		Else { Quit 1 }
	}


 	If (qinfo=5) { 
	 	If $Piece($Get(info), "/", 1)?1N { Set info = "0"_info }
		If $Piece($Get(info), "/", 2)?1N { Set $Piece(info, "/", 2) = "0"_$Piece($Get(info), "/", 2) }
		Try { Set aux = $Zdateh(info, 4) } Catch err { Set info = 1 }
	}
	
	If (qinfo>5) { Set info = 1 }
	
	Quit info
