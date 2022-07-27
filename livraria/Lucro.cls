Class estagio.livraria.Lucro Extends %Persistent
{

Property Aluguel As estagio.livraria.Aluguel;

Property Valor As %Decimal(SCALE = 2) [ Required ];

Property Data As %Date [ Required ];

Storage Default
{
<Data name="LucroDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Aluguel</Value>
</Value>
<Value name="3">
<Value>Valor</Value>
</Value>
<Value name="4">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^estagio.livraria.LucroD</DataLocation>
<DefaultData>LucroDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^estagio.livraria.LucroD</IdLocation>
<IndexLocation>^estagio.livraria.LucroI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Aluguel">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Data">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Valor">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^estagio.livraria.LucroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
