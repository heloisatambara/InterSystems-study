Class estagio.spotify.Musicas Extends %Persistent
{

Property Rank As %Integer [ Required, SqlColumnNumber = 2 ];

Index RankIndex On Rank [ IdKey ];

Property Artists As list Of %String [ Required, SqlColumnNumber = 3 ];

Property Name As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

Property Source As list Of %String(MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Property WeeksOnChart As %Integer [ Required, SqlColumnNumber = 6 ];

Property Streams As %Integer [ Required, SqlColumnNumber = 7 ];

/// Reads an CSV file (or with any other delimiter) and creates a table
ClassMethod ReadCSV(pDirectory As %String, pTitle As %Boolean = 1, pDelimit = ",") As %Status
{
	Do ##class(estagio.spotify.Musicas).%KillExtent() // Erase data AND its ID's
	
	// Read the file - each line one object for track - from the file to the table directly
	Set tSC = $SYSTEM.Status.OK() // default output
	
	Try 
	{
		Set tFile = ##class(%File).%New(pDirectory) // open the file
		Set tSC = tFile.Open("R")
		
		Throw:$$$ISERR(tSC)
	}
	Catch Error // if opening goes wrong
	{
		//Set tSC = Error.AsStatus()
		
		Write !!, "Reading error:", $SYSTEM.Status.DisplayError(tSC)
	}
	
	Set:pTitle tLine = tFile.ReadLine(,.tSC) // skips first line if it's title
	Set tLine = tFile.ReadLine(,.tSC)
	
	While 'tFile.AtEnd // reads lines
	{ 
		Throw:$$$ISERR(tSC) // if going to the next line goes wrong
	
		Set tTrack = ##class(estagio.spotify.Musicas).%New()
		Set tTrack.Rank = $PIECE(tLine, pDelimit, 1) 
		
		For i=3:1:9
		{
			Set tAux = $PIECE(tLine, pDelimit, i)
			If $FIND(tAux,"""", 2)
			{
				Set tArtists =  $LISTFROMSTRING($TRANSLATE($PIECE(tLine, pDelimit, 3, i), """", ""), ",") // remove quotes
				Set tNext = i
				
				For i=1:1:$LISTLENGTH(tArtists)
				{
					Do tTrack.Artists.Insert($LIST(tArtists, i)) // get a list of the artists
				}
				
				Quit
			}
		}
		
		// "Quevedo: Bzrp Music Sessions, Vol. 52" loses the end but since it's the only case, it makes more sense to change manually - the algorithm would be pretty much the same as in for artits
		Set tTrack.Name = $TRANSLATE($PIECE(tLine, pDelimit, *-5), """", "") // remove quotes
		
		Set tSource = $LISTFROMSTRING($TRANSLATE($PIECE(tLine, pDelimit, *-4), """", ""), "/") // remove quotes and get a list of the sources
		
		For i=1:1:$LISTLENGTH(tSource)
		{
			Do tTrack.Source.Insert($LIST(tSource, i)) // get a list of the sources
		}
		
		Set tTrack.WeeksOnChart = $PIECE(tLine, pDelimit, *-1)
		Set tTrack.Streams = $TRANSLATE($PIECE(tLine, pDelimit, *), """", "") // remove quotes
		
		Try // saves each track
		{
			Set tSC = tTrack.%Save()
			
			Throw:$$$ISERR(tSC)
		}
		Catch Error
		{
			Write !, "Saving error:"_$SYSTEM.Status.DisplayError(tSC)
		}
		
		Set tLine = tFile.ReadLine(,.tSC) // next line
	}
	Quit tSC
}

/// Analysis #1 - Tracks with over (pParameter) weeks on chart. Option to pass a File by argument, then the output is written into a file too.
ClassMethod ATracksOverWeeks(pParameter As %Integer = 0, pFile As %File = 0)
{
	// Analysis #1
	// // Tracks over pParameter on chart
	
	&sql(DECLARE search CURSOR FOR
			 SELECT Rank, Name, Artists, Source, WeeksOnChart, Streams
			 INTO :tRank, :tName, :tArtists, :tSource, :tWeeksOnChart, :tStreams
			 FROM estagio_spotify.Musicas
			 WHERE WeeksOnChart > :pParameter
			 ORDER BY WeeksOnChart Desc)
	&sql(OPEN search)
	&sql(FETCH search)

	While (SQLCODE = 0)
	{
		// write information
		Write !, "#"_tRank_" "_tName_" by "_$LISTTOSTRING(tArtists, ",")_" - "_$LISTTOSTRING(tSource, ","), !, "     "_tWeeksOnChart_" weeks on chart, "_tStreams_" streams", !
	
		Do:pFile pFile.WriteLine() // if creating a file, write the info into the file too
		Do:pFile pFile.WriteLine("#"_tRank_" "_tName_" by "_$LISTTOSTRING(tArtists, ",")_" - "_$LISTTOSTRING(tSource, ","))
		Do:pFile pFile.WriteLine("     "_tWeeksOnChart_" weeks on chart, "_tStreams_" streams")
		Do:pFile pFile.WriteLine()
		
		&sql(FETCH search)
	}

	&sql(CLOSE search)
}

/// Analysis #2 - Sources with most streams (and its tracks). Option to pass a File by argument, then the output is written into a file too.
ClassMethod ASourcesWMStreams(pFile As %File = 0)
{
	// TO DO: count collab sources too 
	// Analysis #2
	// // Sources with most streams
	
	&sql(DECLARE PrimarySearch CURSOR FOR 
			 SELECT SUM(Streams), Source
			 INTO :tSumStreams, :tMostPopularSource
			 FROM estagio_spotify.Musicas
			 GROUP BY Source
			 ORDER BY SUM(Streams) Desc)
	&sql(OPEN PrimarySearch)
	&sql(FETCH PrimarySearch)
	
	While (SQLCODE=0)
	{
		// write informations
		Write !!!, $LISTTOSTRING(tMostPopularSource, ",")_" - "_tSumStreams_" streams!"
		
		Do:pFile pFile.WriteLine()
		Do:pFile pFile.WriteLine() // if creating a file, write info into the file too
		Do:pFile pFile.WriteLine($LISTTOSTRING(tMostPopularSource, ",")_" - "_tSumStreams_" streams!")
		
		&sql(DECLARE SecondarySearch CURSOR FOR
			 SELECT Name, Artists, WeeksOnChart
			 INTO :tName, :tArtists, :tWeeks
			 FROM estagio_spotify.Musicas
			WHERE Source LIKE :tMostPopularSource)
		&sql(OPEN SecondarySearch)
		&sql(FETCH SecondarySearch)
		
		// for each source, write its tracks with its artists and weeks on chart
		While (SQLCODE=0)
		{
			// write informations
			Write !, "     "_tName_" by "_$LISTTOSTRING(tArtists, ",")_" - "_tWeeks_" weeks on chart"
			
			Do:pFile pFile.WriteLine("     "_tName_" by "_$LISTTOSTRING(tArtists, ",")_" - "_tWeeks_" weeks on chart") // if creating a file, write info into the file too
			
			&sql(FETCH SecondarySearch)
		} // close search for current source and start a new one
		
		&sql(CLOSE SecondarySearch)
		&sql(FETCH PrimarySearch)
	}
	
	&sql(CLOSE PrimarySearch)
}

/// Analysis #3 - Artists with most streams (and its tracks). Option to pass a File by argument, then the output is written into a file too.
ClassMethod AArtistsWMStreams(pFile As %File = 0)
{
	// Analysis #3
	// // Artists with most streams
	// TO DO: count colab artists too
	
	&sql(DECLARE PrimarySearch CURSOR FOR 
			 SELECT SUM(Streams), Artists
			 INTO :tSumStreams, :tMostPopularArtists
			 FROM estagio_spotify.Musicas
			 GROUP BY Artists
			 ORDER BY SUM(Streams) Desc)
	&sql(OPEN PrimarySearch)
	&sql(FETCH PrimarySearch)
	
	
	While (SQLCODE=0)
	{
		// write informations
		Write !!!, $LISTTOSTRING(tMostPopularArtists, ",")_" - "_tSumStreams_" streams!"
		
		Do:pFile pFile.WriteLine()
		Do:pFile pFile.WriteLine() // if creating a file, write info into the file too
		Do:pFile pFile.WriteLine($LISTTOSTRING(tMostPopularArtists, ",")_" - "_tSumStreams_" streams!")
		
		&sql(DECLARE SecondarySearch CURSOR FOR
			 SELECT Name, Source, WeeksOnChart
			 INTO :tName, :tSource, :tWeeks
			 FROM estagio_spotify.Musicas
			 WHERE Artists LIKE :tMostPopularArtists)
		&sql(OPEN SecondarySearch)
		&sql(FETCH SecondarySearch)
		
		// for each artist, write its tracks with its sources and weeks on chart
		While (SQLCODE=0)
		{
			// write informations
			Write !, "     "_tName_" by "_$LISTTOSTRING(tSource, ",")_" - "_tWeeks_" weeks on chart"
			
			Do:pFile pFile.WriteLine( "     "_tName_" by "_$LISTTOSTRING(tSource, ",")_" - "_tWeeks_" weeks on chart") // if creating a file, write info into the file too
			
			&sql(FETCH SecondarySearch)
		} // close search for current artist and start a new one
		
		&sql(CLOSE SecondarySearch)
		&sql(FETCH PrimarySearch)
	}
	
	&sql(CLOSE PrimarySearch)
}

///   Analysis #4 - Tracks over (pParameter) streams. Option to pass a File by argument, then the output is written into a file too.
ClassMethod ATracksOverStreams(pParameter As %Integer = 0, pFile As %File = 0)
{
	// Analysis #4
	// // Tracks over pParameter streams
	
	&sql(DECLARE search CURSOR FOR
			 SELECT Rank, Name, Artists, Source, WeeksOnChart, Streams
			 INTO :tRank, :tName, :tArtists, :tSource, :tWeeksOnChart, :tStreams
			 FROM estagio_spotify.Musicas
			 WHERE Streams > :pParameter
			 ORDER BY Streams Desc)
	&sql(OPEN search)
	&sql(FETCH search)

	While (SQLCODE = 0)
	{
		// write informations
		Write !, "#"_tRank_" "_tName_" by "_$LISTTOSTRING(tArtists, ",")_" - "_$LISTTOSTRING(tSource, ","), !, "     "_tWeeksOnChart_" weeks on chart, "_tStreams_" streams", !
		
		Do:pFile pFile.WriteLine() // if writing a file, write info into the file too
		Do:pFile pFile.WriteLine("#"_tRank_" "_tName_" by "_$LISTTOSTRING(tArtists, ",")_" - "_$LISTTOSTRING(tSource, ","))
		Do:pFile pFile.WriteLine("     "_tWeeksOnChart_" weeks on chart, "_tStreams_" streams")
		Do:pFile pFile.WriteLine()
		
		&sql(FETCH search)
	}

	&sql(CLOSE search)
	
	
	Quit
}

/// Writes user-readable files with outputs of the Analyze method, on the desired directory. Options to chose the Analysis, Parameter, whether or not to create a title based on which analysis will be made and directory with file name.
ClassMethod WriteTXT(pDirectory As %String, pTitle As %Boolean = 1, pType As %Integer, pParameter As %Integer = 0) As %Status
{
	Set tFile = ##class(%File).%New(pDirectory) // instanciate file
	Set tSC = $$$OK // default output
	
	Try
	{
		Set tSC = tFile.Open("WNS") // try to open it
		
		Throw:$$$ISERR(tSC)
	}
	Catch Error
	{
		Write !, "Failed to create file:"
		Write $SYSTEM.Status.DisplayError(Error.AsStatus())
	}
	
	// creates title
	Set:pTitle tAnalysis = $CASE(pType, 1:"Tracks over "_pParameter_" weeks on chart",
										2:"Sources with most streams",
										3:"Artists with most streams",
										4:"Tracks over "_pParameter_" streams",
										5:pParameter_"'s Streams")
	
	Do:pTitle tFile.WriteLine("Analysis #"_pType_": "_tAnalysis)
	Do $CASE(pType, 1:##class(estagio.spotify.Musicas).ATracksOverWeeks(pParameter, tFile),
					2:##class(estagio.spotify.Musicas).ASourcesWMStreams(tFile),
					3:##class(estagio.spotify.Musicas).AArtistsWMStreams(tFile),
					4:##class(estagio.spotify.Musicas).ATracksOverStreams(pParameter, tFile),
					5:##class(estagio.spotify.Musicas).AArtistStreams(tFile, pParameter)) // writes lines into the file
	Do tFile.Close()
	
	Quit tSC
}

/// Creates CSV file (or with any other delimiter) based on the current table.
ClassMethod WriteCSV(pDirectory As %String, pDelimiter As %String = ";") As %Status
{
	Set tDelimiter = $SELECT(pDelimiter'=$CHAR(59):$CHAR(59), pDelimiter'=$CHAR(44):$CHAR(44)) // sets diferent delimiter for lists
	Set tFile = ##class(%File).%New(pDirectory) // instanciate file
	Set tSC = $$$OK // default output
	
	Try
	{
		Set tSC = tFile.Open("WNS") // tries to create file
		
		Throw:$$$ISERR(tSC)
	}
	Catch Error
	{
		Write !, "Failed to create file:"
		Write $SYSTEM.Status.DisplayError(tSC)
	}
	
	&sql(DECLARE search CURSOR FOR
		 SELECT Rank, Artists, Name, Source, WeeksOnChart, Streams
		 INTO :tInfo()
		 FROM estagio_spotify.Musicas)
	&sql(OPEN search)
	&sql(FETCH search)
	
	While (SQLCODE=0)
	{
		Set tString = ""
		// writes all info 
		For i=2:1:7 
		{
			// stores every info into the string that will be written
			Try
			{
				// tries to store it in list (only artists and sources won't skip to catch)
				Set tString = tString_$LISTTOSTRING(tInfo(i), tDelimiter)_pDelimiter
			}
			Catch Error
			{
				// if it's not a list, store it raw
				Set tString = tString_tInfo(i)_pDelimiter
			}
		}
		
		Do tFile.WriteLine($PIECE(tString, pDelimiter, 1,6)) // writes the complete information on file (removing last delimiter)
		
		&sql(FETCH search)
	}
	
	&sql(CLOSE search)
	
	Do tFile.Close()
	
	Quit tSC
}

/* 
&sql(CREATE FUNCTION AltCount(IN search VARCHAR(50))
	RETURNS INTEGER
	LANGUAGE OBJECTSCRIPT
	{
		Set tStatement = ##class(%SQL.Statement).%New()
		
		&sql(DECLARE C1 CURSOR FOR
			 SELECT SUM(Streams) INTO :AltCount FROM estagio_spotify.Musicas WHERE :search %INLIST Artists)
		
	} 
	)
*/
ClassMethod AArtistStreams(pFile As %File = 0, pArtist As %String)
{
	
	
	&sql(DECLARE PrimarySearch CURSOR FOR
		 SELECT COUNT(%ID), SUM(STREAMS), Artists, Name, WeeksOnChart, Source
		 INTO :tCount, :tSumStreams, :tArtist, :tName, :tWeeks, :tSource
		 FROM estagio_spotify.Musicas
		 WHERE Artists LIKE '%'||:pArtist||'%')
	&sql(OPEN PrimarySearch)
	&sql(FETCH PrimarySearch)
	
	Write !!!, $LISTTOSTRING(tArtist, ",")_" - "_tSumStreams_" streams!"
	
	Do:pFile pFile.WriteLine()
	Do:pFile pFile.WriteLine() // if creating a file, write info into the file too
	Do:pFile pFile.WriteLine($LISTTOSTRING(tArtist, ",")_" - "_tSumStreams_" streams!")
	
	Write !!, tArtist_" has "_tCount_" tracks on global:", !
	
	Do:pFile pFile.WriteLine()
	Do:pFile pFile.WriteLine(tArtist_" has "_tCount_" tracks on global:")
	While (SQLCODE=0)
	{
		Write !, "     "_tName_" by "_$LISTTOSTRING(tSource, ",")_" - "_tWeeks_" weeks on chart"
			
		Do:pFile pFile.WriteLine( "     "_tName_" by "_$LISTTOSTRING(tSource, ",")_" - "_tWeeks_" weeks on chart")
		
		&sql(FETCH PrimarySearch)	
	}
	

	
	&sql(CLOSE PrimarySearch)
	
	Quit
}

Storage Default
{
<Data name="MusicasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Artists</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Source</Value>
</Value>
<Value name="5">
<Value>WeeksOnChart</Value>
</Value>
<Value name="6">
<Value>Streams</Value>
</Value>
</Data>
<DataLocation>^estagio.spotify.MusicasD</DataLocation>
<DefaultData>MusicasDefaultData</DefaultData>
<ExtentSize>67</ExtentSize>
<IdLocation>^estagio.spotify.MusicasD</IdLocation>
<IndexLocation>^estagio.spotify.MusicasI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb("3","14","21","35","45","72","93","113","122","133","142","157","166","178","190","199"),$lb(0,0,0,0,0,0,0,1,1,1,1,1,1,1,2),$lb(855638016,855638016,825491456,825491456,842072064,842072064,859111424,859111424,875888640,875888640,926023680,926023680,959643648,959643648,825307904,825425920,842137600,842137600,858980352,858980352,875692032,875692032,892796928,892796928,909508608,909508608,926416896,926416896,959447040,805306368,956301312,825833728))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="Artists">
<AverageFieldSize>12.67</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" ""ACRAZE"," ""BAD BUNNY"," ""BAD BUNNY"," ""BIZARRAP"," ""CALVIN HARRIS"," ""COOLIO"," ""DRAKE"," ""FUTURE"," ""JAX JONES"," ""LOST FREQUENCIES"," ""MEGAN THEE STALLION"," ""POST MALONE"," ""SHAE GILL"," ""TAYLOR SWIFT"""," ""THE WEEKND"," ""ZÃ© FELIPE"),$lb(3,13,4,3,4,3,3,3,3,3,3,3,3,4,3),$lb(539115843,1129464154,1094983746,0,0,1142964821,1514230354,1230651730,1095521865,1280723278,1330399567,1330596937,1380010821,1380010821,1431590226,1431590226,1096294474,1096294474,1330861088,1330861088,1162297678,1162297678,1330861088,1330861088,1212237088,1212237088,1096371279,1498173266,1159747397,1212489815,3282640966,539122371))</Histogram>
<Selectivity>2.0000%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>13.09</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("  21 SAVAGE""","  BAD BUNNY","  BOMBA ESTÃ©REO""","  CALUM SCOTT""","  DAFT PUNK""","  DRAKE","  ED SHEERAN""","  JHAY CORTEZ""","  KAROL G""","  MC MARI""","  OZUNA""","  RAUW ALEJANDRO""","  SZA""","  TIAGO PZK""","  WIZKID"," ""LOOSE CHANGE"""),$lb(2,3,2,2,3,2,2,2,2,2,2,2,2,2,1),$lb(538980913,842080339,1111573536,1094983746,1330463297,1112493378,1128352853,1128352853,1145128532,1095128096,1380010821,1146241355,1162092627,1162092627,1246249305,1246249305,1262572111,1262572111,1296244813,1296244813,1331320142,1331320142,1380013399,1380013399,1398423842,1398423842,1414086983,1414086983,1464425035,542591322,575426383,539118671))</Histogram>
<Selectivity>1.6667%</Selectivity>
</Property>
<Property name="Rank">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Source">
<AverageFieldSize>18.72</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("  ANITTA""","  GIVEON""","  PNAU"""," ""BAM BAM (FEAT. ED SHEERAN)"""," ""CALLAITA"""," ""DÃ"_$c(129)_"KITI"""," ""INDUSTRY BABY (FEAT. JACK HARLOW)"""," ""LA INOCENTE"""," ""LOST KIDS LLC."," ""MY UNIVERSE"""," ""ONE KISS (WITH DUA LIPA)"""," ""PASOORI"""," ""STAY (WITH JUSTIN BIEBER)"""," ""TAROT"""," ""ULTRA SOLO"""," ""X Ã"_$c(154)_"LTIMA VEZ"""),$lb(2,2,1,3,3,3,3,4,3,3,3,3,3,3,3),$lb(538984782,1095649620,1195988549,1195988549,1347305813,542133825,574767437,1095573570,1095519297,1095519297,3280030537,3280030537,1313101139,1313101139,1092634958,541675087,1398022219,1330861088,1495291214,1495291214,1313153099,1313153099,1095978831,1095978831,1413568800,1413568800,1095913300,1095913300,1280594497,1280594497,549689932,539121696))</Histogram>
<Selectivity>1.5385%</Selectivity>
</Property>
<Property name="Streams">
<AverageFieldSize>2.96</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-1,1,4,6,9,10,12,19,31,45,54,76,93,154,172,221),$lb(0,0,0,0,0,1,1,0,0,0,0,0,0,1,0),$lb(758185984,758185984,822083584,822083584,872415232,872415232,905969664,905969664,956301312,956301312,825229312,805306368,838860800,838860800,956301312,825819136,858849280,858849280,875888640,875888640,892600320,892600320,926285824,926285824,959643648,959643648,825570304,892600320,926023680,825700864,842150144,842150144))</Histogram>
<Selectivity>2.2727%</Selectivity>
</Property>
<Property name="WeeksOnChart">
<AverageFieldSize>2.96</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-1,3,9,14,25,37,54,79,85,100,116,137,146,153,177,195),$lb(0,0,0,0,0,0,0,0,0,1,1,1,1,1,1),$lb(758185984,758185984,855638016,855638016,956301312,956301312,825491456,825491456,842334208,842334208,859242496,859242496,892600320,892600320,926482432,926482432,942997504,942997504,825241600,808452096,825622528,825622528,859242496,859242496,875954176,875954176,892534784,892534784,926351360,926351360,959774720,825832704))</Histogram>
<Selectivity>1.6129%</Selectivity>
</Property>
<SQLMap name="RankIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.spotify.MusicasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
