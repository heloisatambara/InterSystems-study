CADASTRO // aqui fiz estudo de variaveis locais publicas e privadas, utilizando new
	Quit
	
 // rotina pede nome, mas só pode pedir CPF se pedir o nome: PEDIRCPF é private e PEDIRNOME é public
PEDIRNOME() public 
	NEW resposta // var resposta n existira ao fim dessa func - private local
	While 1{
		Read !, "Digite seu nome: ", nome // ficara diponivel depois - public local
		Write !, "Seu nome é "_nome_"? "
		Read resposta
		IF resposta = "sim"{
			Write !, "Ok"
			Quit
		}
		Else{
		 Write !, "Misericórdia não sabe escrever o próprio nome e quer ser dev"	
		}
	}
	Do PEDIRCPF()
	Quit


 // variaveis de procedures sao privadas e variaveis de funcoes e subrotinas sao publicas - ao final a variavel CPF nao é acessavel, a nome fica salva e a resposta tambem some pq foi NEW.
PEDIRCPF() private {
	While 1 {
		Read !, "Digite seu CPF: ", CPF // public local
		Write !, "Seu CPF é "_CPF_"? "
		Read resposta, !
		If CPF'?3N1"."3N1"."3N1"-"2N {
			Write "Faz de novo e faz direito, tem que digitar bonitinho com os . e -"
		}
		Else{		
			If resposta = "sim" {
				Write "Parabéns! Você foi cadastrado como mesário voluntário nas eleições!"
				Quit
			}
			Else {
				Write "Então faz de novo e faz direito"
			}
		}
	}
	Quit
}


 // brincar com datas
PEDIRNASC() public
	Read "Digite sua data de nascimento: ", data
	Quit
	
