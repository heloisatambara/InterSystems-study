CPRODUTO // versao em variaveis: estudo de variaveis globais 
	Quit

pedirnome() Public {
	Kill ^sale
	Read "Digite o nome do produto: ", ^nome
	Set ^codigo = $$gerarnum()
	Write !, "O produto foi cadastrado como ", ^nome, " com código ", ^codigo
	Do pedirvalor()
	Quit
}



pedirvalor() private {
	While 1 {
		Read !, "Qual o valor do produto? ", ^valor
		If ^valor'?.N1"."2N  {
			Write !, "Digite novamente o valor"
		}
		Else { 
			Quit	
		}
		
	}
	Write !, "O produto "_^nome_" custa "_^valor_" reais."
	Do pedirqtd()
	Quit
}



pedirqtd() private {
	Read !, "Quantos estão disponíveis? ", ^qtd
	Write !, "Há "_^qtd_" "_^nome_"(s) por "_^valor_" reais cada."
	Quit	
}




aplicarsale() public {
	While 1 {
		Read !, "Porcentagem do desconto: ", ^sale
		If '(1 > ^sale > 0) {
			Write !, "Digite um valor entre 0 e 1"
		}
		Else {
			Quit
		}
	}
	Set ^valor = (1 - ^sale) * ^valor
	Write !, "Há "_^qtd_" "_^nome_"(s) por "_^valor_" reais cada."
	Quit	
}

 // ver como vai fz isso aqui kkkk
retirarsale(produto) public {
	Set ^valor = ^valor / (1 - ^sale)
	Kill ^sale
	Write !, "Promoção retirada"
	Quit
}


gerarnum() private {
	Set code = $RANDOM(1000000)
	Quit code
}


 // consistência para qtd < 0
registrarcompra() public {
	Read !, "Quantos deseja comprar? ", comprados
	If comprados > ^qtd {
		Write !, "Foram comprados apenas "_^qtd_" "_^nome_"(s)." 
		Set ^qtd = 0
	}

	Else {
		Set ^qtd = ^qtd - comprados
	}
	
	Write !, "Agora há "_^qtd_" "_^nome_"(s) restantes."
	Quit
}



 // por serem variáveis globais, o write e kill sem parâmetros não funcionam, portanto crio um procedimento que escreve/mata todos relacionados a esta rotina.
reiniciar() public {
	Kill ^nome, ^valor, ^qtd, ^sale, ^codigo
	Quit	
}

escrever() public {
	Write !, ^nome, !, ^valor, !, ^qtd,!, ^codigo
	If $DATA(^sale) {
		Write !, ^sale	
	}
	Quit
}
