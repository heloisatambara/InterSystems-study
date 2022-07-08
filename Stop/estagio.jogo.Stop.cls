Class estagio.jogo.Stop Extends %Persistent
{

// TO DO:

// // Tentar fazer cronometro

// // Arrumar propriedade horario - ta guadando só a data

Relationship Jogador As estagio.jogo.Jogador [ Cardinality = one, Inverse = Jogo, OnDelete = cascade ];

Index JogadorIndex On Jogador;

Property Horario As %Date [ Required ];

Property Pontuacao As %Integer [ Required ];

ClassMethod Iniciar()
{
	// Pega pontuacao máxima para exibir
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tQuery = "SELECT Nome, PontuacaoMax FROM estagio_jogo.Jogador ORDER BY PontuacaoMax Desc"
	Set tStatus = tStatement.%Prepare(tQuery)
	Set tResSet = tStatement.%Execute()
	Do tResSet.%Next()
	Set tMaxPontos = tResSet.%Get("PontuacaoMax")
	Set tRecordeBy = tResSet.%Get("Nome")

	// Cria nova instância de jogo
	Set tNovoJogo = ##class(estagio.jogo.Stop).%New()
	Set tHorario = $ZDATETIME($HOROLOG, 2, 2), tNovoJogo.Horario = +$HOROLOG
	
	Write !, "#######################################################################"
	Write !, "# Bem vindo ao stop!", ?70,                                          "#"
	Write !, "#", $Justify(tHorario, 68),                                         " #"
	Write !, "#", $Justify("Pontuação máxima: "_tMaxPontos_" - "_tRecordeBy, 68), " #"
	Write !, "#######################################################################"
	Write !, "#", ?70,                                                             "#"
	Write !, "# LEADERBOARD", ?70,                                                 "#"
	Write !, "#", ?70,                                                             "#"
	Do ##class(estagio.jogo.Stop).MostrarJogadores()
	Write !, "#", ?70,                                                             "#"
	Write !, "#######################################################################"



	Read !!, " Você é algum desses jogadores? ", tResposta
	Set tID = 0
	Read:("SimsimSIM"[tResposta) !, " Qual? ", tID
	
	Set:(tID) tJogador =  ##class(estagio.jogo.Jogador).%OpenId(tID)
	Set:('tID) tJogador = ##class(estagio.jogo.Stop).Cadastrar()
	
	Set tNovoJogo.Jogador = tJogador	
	
	Set tPontuacao = ##class(estagio.jogo.Stop).Jogo(tJogador)
	Set:(tPontuacao >= tJogador.PontuacaoMax) tJogador.PontuacaoMax = tPontuacao
	
	Set tNovoJogo.Pontuacao = tPontuacao
	
	Set sc = tNovoJogo.%Save()
	//Write !, $System.Status.DisplayError(sc)
	
	Set sc = tJogador.%Save()
	//Write !, $System.Status.DisplayError(sc)
	
	Read !, " Jogar de novo? ", tDnv
	Do:("SimSIMsim"[tDnv) ##class(estagio.jogo.Stop).Iniciar()
	
	Quit
}

Query Pontuacao() As %SQLQuery [ SqlProc ]
{
	SELECT Nome, PontuacaoMax FROM estagio_jogo.Jogador
	ORDER BY PontuacaoMax Desc
}

Query Jogadores() As %SQLQuery [ SqlProc ]
{
	SELECT ID, Nome, PontuacaoMax FROM estagio_jogo.Jogador
	ORDER BY PontuacaoMax Desc
}

ClassMethod MostrarJogadores()
{
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tStatus = tStatement.%PrepareClassQuery("estagio.jogo.Stop", "Jogadores")
	Set tResSet = tStatement.%Execute()
	
	Set tCount = 0
	
	While (tResSet.%Next())
	{
		Write !, "# "_$INCREMENT(tCount)_"- "_tResSet.%Get("Nome")_" #"_tResSet.%Get("ID"), ?70, "#"
		Write !, "#   Recorde: "_tResSet.%Get("PontuacaoMax"), ?70, "#"
	}
}

ClassMethod Cadastrar() As estagio.jogo.Jogador
{
	Write !!, "#############################################"
	Write !,  "# Cadastrar novo jogador:                   #"
	Write !,  "#                                           #"
	Read !,   "# Nickname...: ", tNome, ?44,              "#"
	Read !,   "# Idade......: ", tIdade, ?44,             "#"
	Write !,  "#                                           #"
	Write !,  "#############################################"
	
	If ('$ISVALIDNUM(tIdade))
	{
		Write !!, "Idade inserida inválida."
	}
	Else
	{
		Set tNovoJogador = ##class(estagio.jogo.Jogador).%New()
		Set tNovoJogador.Nome = tNome
		Set tNovoJogador.Idade = tIdade
		Set tNovoJogador.PontuacaoMax = 0
		Do tNovoJogador.%Save()
	}
	
	Quit tNovoJogador
}

ClassMethod Jogo(pJogador As estagio.jogo.Jogador)
{
	Set tJogo("animal")="", tJogo("cep")="", tJogo("comida")="", tJogo("cor")="", tJogo("mse")="", tJogo("nome")=""
	
	Set tSorteio = $CHAR($RANDOM(25) + 65) // de 65 a 90
	Write !!, "A letra sorteada é "_tSorteio_"!"	
	Hang 3
	Set tTime = $Piece($Horolog, ",", 2)
	Set tTimeLeft = 60
	
	
	For {
		Set tTimeLeft = 60 - ($Piece($Horolog, ",", 2) - tTime)
 		Write !, "Corre! Você ainda tem "_tTimeLeft_" segundos."
 		
 		
		Write !!, "|  Animal  |   CEP   |  Comida  |   Cor   |   MSE   |   Nome   |", !
		Write !, " # Animal.........: "_tJogo("animal")
		Write !, " # CEP............: "_tJogo("cep")
		Write !, " # Comida.........: "_tJogo("comida")
		Write !, " # Cor............: "_tJogo("cor")
		Write !, " # Minha sogra é..: "_tJogo("mse")
		Write !, " # Nome...........: "_tJogo("nome")
		
		Read !!, tTema:5, !
		Quit:(tTema="stop"||(tTimeLeft < 0))
		Continue:(tTema="")
		Set tTema = $Translate(tTema, "ACDEFILMNOPRST ´[~^`{}?]/;\!@#$%¨&*()", "acdefilmnoprst")
		
		Read:("nome1"[tTema) !,   " Nome: ",         tJogo("nome"):10
		Read:("comida2"[tTema) !, " Comida: ",       tJogo("comida"):10
		Read:("cor3"[tTema) !,    " Cor: ",          tJogo("cor"):10
		Read:("mse4"[tTema) !,    " Minha sogra é ", tJogo("mse"):10
		Read:("animal5"[tTema) !, " Animal: ",       tJogo("animal"):10
		Read:("cep4"[tTema) !,    " CEP: ",          tJogo("cep"):10				
	}
	
	Write:(tTema="stop") !!, "Parabéns! Você terminou com "_tTimeLeft_" segundos sobrando."
	
	Set tPontuacao = pJogador.Pontuacao(tJogo("animal"), tJogo("cep"), tJogo("comida"), tJogo("cor"), tJogo("mse"), tJogo("nome") , tSorteio, tTimeLeft)
	Quit tPontuacao
}

Storage Default
{
<Data name="StopDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Jogador</Value>
</Value>
<Value name="3">
<Value>Horario</Value>
</Value>
<Value name="4">
<Value>Pontuacao</Value>
</Value>
</Data>
<DataLocation>^estagio.jogo.StopD</DataLocation>
<DefaultData>StopDefaultData</DefaultData>
<ExtentSize>0</ExtentSize>
<IdLocation>^estagio.jogo.StopD</IdLocation>
<IndexLocation>^estagio.jogo.StopI</IndexLocation>
<StreamLocation>^estagio.jogo.StopS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
