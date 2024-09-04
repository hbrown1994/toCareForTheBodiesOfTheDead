{
	~buffersNames[\samples_8ch].do{|i|
		var thisSample=i.asSymbol;

		~samples8chGui[\trig][thisSample].value = 0;

		~samples8chGui[\amp][thisSample].value = ~params[thisSample][\amp];
		~samples8chGui[\ampNumbox][thisSample].value = ~params[thisSample][\amp].ampdb;

		~samples8chGui[\lpfOn][thisSample].value = ~params[thisSample][\lpfOn];
		~samples8chGui[\hpfOn][thisSample].value = ~params[thisSample][\hpfOn];

		~samples8chGui[\lpfFreq][thisSample].value = ~params[thisSample][\lpfFreq].linlin(8000, 20000, 0, 1);
		~samples8chGui[\hpfFreq][thisSample].value = ~params[thisSample][\hpfFreq].linlin(20, 200, 0, 1);

		~samples8chGui[\lpfNumbox][thisSample].value = ~params[thisSample][\lpfFreq];
		~samples8chGui[\hpfNumbox][thisSample].value = ~params[thisSample][\hpfFreq];
	};
}.value;





