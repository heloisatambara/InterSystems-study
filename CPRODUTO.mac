CPRODUTO // versao em arrays
	Quit

 // tentar armazenar em array depois com $order(a(""),-1)
pedirnome() Public {
	Read "Digite o nome do produto: ", ^produto("nome")
	Set ^produto("nome", "codigo") = $$gerarnum()
	Write !, "O produto foi cadastrado como ", ^produto("nome"), " com código ", ^produto("nome", "codigo")
	Do pedirvalor()
	Quit
}

 // tentar colocar consistência para valor no formato x.xx
pedirvalor() public {
	Read !, "Qual o valor do produto? ", ^produto("nome", "valor")
	Write !, "O produto "_^produto("nome")_" custa "_^produto("nome", "valor")_" reais."
	Do pedirqtd()
	Quit
}

pedirqtd() public {
	Read !, "Quantos estão disponíveis? ", ^produto("nome", "qtd")
	Write !, "Há "_^produto("nome", "qtd")_" "_^produto("nome")_"(s) por "_^produto("nome", "valor")_" reais cada."
	Quit	
}


 // escolher para qual produto vai aplicar
 // arrumar consistencia
aplicarsale() public {
	Read !, "Porcentagem do desconto: ", ^produto("nome", "sale")
	Set ^produto("nome", "valor") = (1 - ^produto("nome", "sale")) * ^produto("nome", "valor")
	Write !, "Há "_^produto("nome", "qtd")_" "_^produto("nome")_"(s) por "_^produto("nome", "valor")_" reais cada."
	
	Quit	
}

 // ver como vai fz isso aqui kkkk
retirarsale(produto) public {
	
	Quit
}


gerarnum() private {
	Set code = $RANDOM(1000000)
	Quit code
}


 // consistência para qtd < 0
registrarcompra() public {
	Read !, "Quantos deseja comprar? ", comprados
	If comprados > ^produto("nome", "qtd") {
		Write !, "Foram comprados apenas "_^produto("nome", "qtd")_" "_^produto("nome")_"(s)." 
		Set ^produto("nome", "qtd") = 0
		
	}

	Else {
		Set ^produto("nome", "qtd") = ^produto("nome", "qtd") - comprados
	}
	
	Write !, "Agora há "_^produto("nome", "qtd")_" "_^produto("nome")_"(s) restantes."
	Quit
}
