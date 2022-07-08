Class estagio.exemplos.Teste [ Abstract ]
{

// Observações:

// // Antes de criar o mapping para a database dos samples para classe, nem rodava - não achava estagio.jogo.Stop

// // Após criar ele roda, mas não vê os dados da tabela, pois são armazenados em globais que não estão mapeadas.

// // Se rodar esse mesmo método no namespace SAMPLE2, mostra todos os dados da tabla, pois ele tem o mesmo database de SAMPLE

// Dúvidas:

// // Qual a diferença dos namespaces com mesmas databases?

ClassMethod Teste()
{
	Write !,  "             - Todos os jogadores - " 
	Set tMedia = ##class(estagio.exemplos.Teste).EscreveQuery("SelecionaTudo")
	Write !!, " Média de pontuação: ",  tMedia
	
	Write !!, "          - Jogadores acima da média - " 
	Do ##class(estagio.exemplos.Teste).EscreveQuery("SelecionaMedia", tMedia)
}

Query SelecionaTudo(pEmpty) As %SQLQuery [ SqlProc ]
{
	SELECT ID, Jogador->Nome, Pontuacao FROM estagio_jogo.Stop
}

Query SelecionaMedia(pMedia) As %SQLQuery [ SqlProc ]
{
	SELECT ID, Jogador->Nome, Pontuacao FROM estagio_jogo.Stop
	WHERE Pontuacao > :pMedia
}

ClassMethod EscreveQuery(pQuery As %String, pMedia As %Decimal = 0)
{
	Set tMedia = 0, tCount = 0
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tStatus = tStatement.%PrepareClassQuery("estagio.exemplos.Teste", pQuery)
	Set tResultSet = tStatement.%Execute(pMedia)
	While tResultSet.%Next()
	{
		Do $INCREMENT(tCount)
		Do $INCREMENT(tMedia,  tResultSet.%Get("Pontuacao"))
		Write !, " #"_tResultSet.%Get("ID")_" "_tResultSet.%Get("Nome"), ?25, $JUSTIFY(tResultSet.%Get("Pontuacao"), 20)
		// Do tResultSet.%Print()
	}
	
	Quit tMedia/ tCount
}

}
