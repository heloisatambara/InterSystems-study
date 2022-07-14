Class estagio.bike.Estacao1 Extends %Persistent
{

Property Localizacao As %ListOfDataTypes [ Required ];

Property Nome As %String [ Required ];

Property Station As %Decimal;

Index StationIndex On Station [ IdKey ];

Storage Default
{
<Data name="Estacao1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Localizacao</Value>
</Value>
<Value name="3">
<Value>Nome</Value>
</Value>
</Data>
<DataLocation>^estagio.bike.Estacao1D</DataLocation>
<DefaultData>Estacao1DefaultData</DefaultData>
<ExtentSize>0</ExtentSize>
<IdLocation>^estagio.bike.Estacao1D</IdLocation>
<IndexLocation>^estagio.bike.Estacao1I</IndexLocation>
<StreamLocation>^estagio.bike.Estacao1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
