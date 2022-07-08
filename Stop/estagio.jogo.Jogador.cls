Class estagio.jogo.Jogador Extends %Persistent
{

Relationship Jogo As estagio.jogo.Stop [ Cardinality = many, Inverse = Jogador ];

Property Nome As %String [ Required, SqlColumnNumber = 2 ];

Property Idade As %Integer [ Required, SqlColumnNumber = 3 ];

Property PontuacaoMax As %Integer [ Required, SqlColumnNumber = 4 ];

Method Pontuacao(pAnimal As %String, pCEP As %String, pComida As %String, pCor As %String, pMSE As %String, pNome As %String, pLetra As %String, pTime As %Integer) As %Integer
{
	Set tPontos = 0
	Set tResp = $LISTBUILD(pAnimal, pCEP, pComida, pCor, pMSE, pNome)
	Set tKey = $LISTBUILD("Animal", "CEP", "Comida", "Cor", "Minha sogra é", "Nome")
	
	// se a primeira letra for a sorteada (convertida para uppercase) e for uma palavra, pontua 
	For i = 1:1:6
	{
		If ((pLetra = $ZCONVERT($EXTRACT($LIST(tResp, i), 1), "U"))&&($LENGTH(tResp) > 1))
		{
			Write !, $LIST(tKey, i)_": "_$LIST(tResp, i)_" é válida? " 
			Read tAns
			Do:("SIMsimSim"[tAns) $INCREMENT(tPontos, 1)
		}
		Else
		{
			Write !, $LIST(tKey, i)_": "_$LIST(tResp, i)_" não é válida." 
			Hang .5
		}
	}
	
	
	
	Set:(pTime>0) tPontos = pTime**tPontos
	
	
	Write !!," # Pontuação final: "_tPontos
	Write !, " # Animal.........: "_pAnimal
	Write !, " # CEP............: "_pCEP
	Write !, " # Comida.........: "_pComida
	Write !, " # Cor............: "_pCor
	Write !, " # Minha sogra é..: "_pMSE
	Write !, " # Nome...........: "_pNome
	
	Quit tPontos
}

Storage Default
{
<Data name="JogadorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nome</Value>
</Value>
<Value name="3">
<Value>Idade</Value>
</Value>
<Value name="4">
<Value>PontuacaoMax</Value>
</Value>
</Data>
<DataLocation>^estagio.jogo.JogadorD</DataLocation>
<DefaultData>JogadorDefaultData</DefaultData>
<ExtentSize>2</ExtentSize>
<IdLocation>^estagio.jogo.JogadorD</IdLocation>
<IndexLocation>^estagio.jogo.JogadorI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Idade">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Nome">
<AverageFieldSize>7.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PontuacaoMax">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.jogo.JogadorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
