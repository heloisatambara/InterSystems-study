Stop
	Set $Halt = "haltRoutine^Stop"
	Lock ^jogador

inicio
	Write !, "Bem vindo ao stop!"
	Read !, "Gostaria de um tutorial? ", ans
	Goto:("SIMsimSim"[ans) tutorial
	
	Set iniMsg = "Último jogo: "_^lastPlayed
	Write !, $Justify(iniMsg, 70)
	Write !, $Justify("Pontuação máxima: "_^maxpontos, 70) 
	Write !, $Justify("Antes de começar, vamos precisar de algumas informações.", 70) Hang 4
	
	Read !!, "Que dia é hoje? ", dia
	Read " Certo, e mês? ", mes
	
	Set $Piece(^lastPlayed, "/", 1) = dia, $Piece(^lastPlayed, "/", 2) = mes
	Set agora = $Piece($Horolog, ",", 2)
	Set $Piece(^lastPlayed, " ", 2) =  $Ztime(agora)
	Write !, $Justify("Novo jogo: "_^lastPlayed, 70)
	
	Do jogadores()
	Goto novoOuHalt
	
	Quit





jogadores() public
	Set count = $Order(^jogador(0), 1), counts = 0
	While (count '= "") {
		
		set counts = count // caso tenha que adicionar jogador novo, guarda o último contador
		Write !, "Jogador "_count_": "_^jogador(count, "nome")_", "_^jogador(count, "idade")_" anos, recorde: "_^jogador(count,"pontos")
		Set count = $Order(^jogador(count), 1)
		
	}
	
	For {
		Read !, "Você é algum desses jogadores? ", resposta
		Quit:("SIMsimSimNAOnaoNao"[resposta)
	}
	Do jajogou():("SIMsimSim"[resposta), naojogou():("NAOnaoNao"[resposta)
	
	Quit

	
jajogou() public 
	Read !, "Qual? (Digite o número) ", numJog
	
	Do jogo()
	
	Quit

	
	
naojogou() public 
	Read !, "Qual é seu nome? ", nome
	set numJog = counts + 1
	Set ^jogador(numJog, "nome") = nome
	
	Read !, "Sua idade? ", age
	Set ^jogador(numJog, "idade") = age, ^jogador(numJog, "pontos") = 0
	
	Do jogo()
	
	Quit






jogo()
	Kill jogo
	Set sorteio = $Char($Random(25) + 65) // de 65 a 90
	Write !!, "A letra sorteada é "_sorteio_"!"
	Hang 3
	Set time = $Piece($Horolog, ",", 2)
	Set timeLeft = 60
	
	For {
		Set timeLeft = 60 - ($Piece($Horolog, ",", 2) - time)
 		Write !, "Corre! Você ainda tem "_timeLeft_" segundos."
 		
 		
		Write !!, "|  Animal  |   CEP   |  Comida  |   Cor   |   MSE   |   Nome   |", !
		Write:$DATA(jogo("animal")) !,"Animal: "_jogo("animal")
		Write:$DATA(jogo("cep")) !, "CEP: "_jogo("cep")
		Write:$DATA(jogo("comida")) !, "Comida: "_jogo("comida")
		Write:$DATA(jogo("cor")) !, "Cor: "_jogo("cor")
		Write:$DATA(jogo("mse")) !, "Minha sogra é "_jogo("mse")
		Write:$DATA(jogo("nome")) !, "Nome: "_jogo("nome")
		
		Read !, tema:5, !
		Quit:(tema="stop"||(timeLeft < 0))
		Continue:(tema="")
		Set tema = $Translate(tema, "ACDEFILMNOPRST ´[~^`{}?]/;\!@#$%¨&*()", "acdefilmnoprst")
		
		Read:("nome1"[tema) !, "Nome: ", jogo("nome"):10
		Read:("comida2"[tema) !, "Comida: ", jogo("comida"):10
		Read:("cor3"[tema) !, "Cor: ", jogo("cor"):10
		Read:("mse4"[tema) !, "Minha sogra é ", jogo("mse"):10
		Read:("animal5"[tema) !, "Animal: ", jogo("animal"):10
		Read:("cep4"[tema) !, "CEP: ", jogo("cep"):10		
	}
	
	Write:(tema="stop") !!, "Parabéns! Você terminou com "_timeLeft_" segundos sobrando."
	Goto pontuacao
	Quit
	
	




 

pontuacao
	Set pontos = 0
	Set key = $Order(jogo(-1), 1, resp)
	Do { // se a primeira letra for a sorteada (convertida para uppercase) e for uma palavra, pontua 
		If ((sorteio = $Zconvert($Extract(resp, 1), "U"))&&($Length(resp) > 1)){
			Write !, key_": "_resp_" é válida? " 
			Read ans
			Do:("SIMsimSim"[ans) $Increment(pontos, 1)
		}
		Else {
			Write !, key_": "_resp_" não é válida." 
		}
		Set key = $Order(jogo(key), 1, resp)
	} While (key '= "")

	Set:(timeLeft>0) pontos = pontos*timeLeft
	
	Write !!, "Pontuação final: "_pontos
	Write:$DATA(jogo("animal")) !,"Animal: "_jogo("animal")
	Write:$DATA(jogo("cep")) !, "CEP: "_jogo("cep")
	Write:$DATA(jogo("comida")) !, "Comida: "_jogo("comida")
	Write:$DATA(jogo("cor")) !, "Cor: "_jogo("cor")
	Write:$DATA(jogo("mse")) !, "Minha sogra é "_jogo("mse")
	Write:$DATA(jogo("nome")) !, "Nome: "_jogo("nome")
			
	Set:(pontos>^jogador(numJog, "pontos")) ^jogador(numJog, "pontos") = pontos
	
	Set:(pontos>^maxpontos) ^maxpontos = pontos_" de "_^jogador(numJog, "nome")
	 

	Quit
	
	
	


tutorial
	NEW animal, cep, comida, cor, mse, nome
	Write !, $Justify("Bem vindo ao stop!", 70) Hang 2
	Write !, $Justify("Nunca jogou? É bem simples!", 70) Hang 2
	Write !, $Justify("Vem comigo, eu vou te ensinar.", 70) Hang 2
	
	Write !, $Justify("Primeiro, será sorteada uma letra, por exemplo:", 70) Hang 3
	
	Write !!, "A letra sorteada é B!" Hang 3
	Write !, "Corre! Você ainda tem 100 segundos" 
	Write !!, "|  Animal  |   CEP   |  Comida  |   Cor   |   MSE   |   Nome   |", ! Hang 3
		
	
	Write !, $Justify("Relaxa, aqui no tutorial o tempo não está contando.", 70) Hang 3
	Write !, $Justify("O que apareceu ali são os temas.", 70) Hang 3
	Write !, $Justify("Você pode selecionar um digitando o nome do tema ou parte dele.", 70) Hang 3
	Write !, $Justify("Lembre-se: CEP é Cidade, Estado ou País", 70) Hang 3
	Write !, $Justify("e MSE é Minha sogra é (aqui vale qualquer adjetivo)", 70) Hang 3
	Write !, $Justify("Tente selecionar um tema e escrever algo nele:", 70) Hang 3
	
	For {
 		Write !!, "Corre! Você ainda tem 100 segundos."
	 	Write !, $Justify("Relaxa, aqui no tutorial o tempo não está contando.", 70)
		Write !, $Justify("O jogo só para quando você digitar stop no lugar dos temas.", 70)
 		
		Write !!, "|  Animal  |   CEP   |  Comida  |   Cor   |   MSE   |   Nome   |", !
		Write:$DATA(animal) !,"Animal: "_animal
		Write:$DATA(cep) !, "CEP: "_cep
		Write:$DATA(comida) !, "Comida: "_comida
		Write:$DATA(cor) !, "Cor: "_cor
		Write:$DATA(mse) !, "Minha sogra é "_mse
		Write:$DATA(nome) !, "Nome: "_nome
		
		Read !, tema, !
		Quit:(tema="stop")
		Continue:(tema="")
		Set tema = $Translate(tema, "ACDEFILMNOPRST ´[~^`{}?]/;\!@#$%¨&*()", "acdefilmnoprst")
		
		Read:("nome1"[tema) !, "Nome: ", nome
		Read:("comida2"[tema) !, "Comida: ", comida
		Read:("cor3"[tema) !, "Cor: ", cor
		Read:("mse4"[tema) !, "Minha sogra é ", mse
		Read:("animal5"[tema) !, "Animal: ", animal
		Read:("cep4"[tema) !, "CEP: ", cep	
	}



	Write !, $Justify("A pontuação final é dada pelo número de respostas válidas.", 70) Hang 3
	Write !, $Justify("Se tiver terminado antes do tempo,", 70) Hang 2
	Write !, $Justify("são multiplicadas pelo tempo restante.", 70), ! Hang 3
	
	
	Goto inicio
	Quit
	


	
	
novoOuHalt
	Write !!, "Placar:"
	Set count = $Order(^jogador(0), 1), counts = 0
	While (count '= "") {
		
		set counts = count // caso tenha que adicionar jogador novo, guarda o último contador
		Write !, "Jogador "_count_": "_^jogador(count, "nome")_", "_^jogador(count, "idade")_" anos, recorde: "_^jogador(count,"pontos")
		Set count = $Order(^jogador(count), 1)
		
	}
	

	Read !!, "Quer jogar de novo? ", ans
	Goto:("SimSIMsim"[ans) inicio
	Halt
	Quit

haltRoutine
	Read !, "Tem certeza? ", ans
	Goto:'("SimSIMsim"[ans) inicio
	
	Write !, "Ok. Foi bom jogar com você! Até mais!"
	Hang 4
	Halt
	
	
