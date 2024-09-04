{
	~buffersNames[\samples_2ch].do{|i|
		var thisSample=i.asSymbol;

		~samples2chGui[\trig][thisSample].value = 0;

		~samples2chGui[\amp][thisSample].value = ~params[thisSample][\amp];
		~samples2chGui[\ampNumbox][thisSample].value = ~params[thisSample][\amp].ampdb;

		~samples2chGui[\lpfOn][thisSample].value = ~params[thisSample][\lpfOn];
		~samples2chGui[\hpfOn][thisSample].value = ~params[thisSample][\hpfOn];

		~samples2chGui[\lpfFreq][thisSample].value = ~params[thisSample][\lpfFreq].linlin(8000, 20000, 0, 1);
		~samples2chGui[\hpfFreq][thisSample].value = ~params[thisSample][\hpfFreq].linlin(20, 200, 0, 1);

		~samples2chGui[\lpfNumbox][thisSample].value = ~params[thisSample][\lpfFreq];
		~samples2chGui[\hpfNumbox][thisSample].value = ~params[thisSample][\hpfFreq];

		8.do{|routeNum|
			var route = ("route"++routeNum).asSymbol;
			~samples2chGui[\routeButtons][thisSample][route].value = ~params[thisSample][route];
		};

	};
}.value;





