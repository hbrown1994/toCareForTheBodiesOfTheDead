{
	var names=[\whiteNoise, \pinkNoise];
	names.do{|i|

		~noiseGui[\amp][i].value = ~params[i][\amp];
		~noiseGui[\ampNumbox][i].value = ~params[i][\amp].ampdb;

		~noiseGui[\lpfOn][i].value = ~params[i][\lpfOn];
		~noiseGui[\hpfOn][i].value = ~params[i][\hpfOn];

		~noiseGui[\lpfFreq][i].value = ~params[i][\lpfFreq].linlin(8000, 20000, 0.0, 1.0);
		~noiseGui[\lpfNumbox][i].value = ~params[i][\lpfFreq];

		~noiseGui[\hpfFreq][i].value = ~params[i][\hpfFreq].linlin(20, 200, 0.0, 1.0);
		~noiseGui[\hpfNumbox][i].value = ~params[i][\hpfFreq];

		8.do{|routeNum|
			var route = (i.asString ++ routeNum).asSymbol;
			~noiseGui[\routingSliders][route].value = ~params[i][\route][routeNum];
			~noiseGui[\routingNumbox][route].value = ~params[i][\route][routeNum];
		};

		4.do{|ampStepNum|
			var ampStep = (i.asString ++ ampStepNum).asSymbol;

			~noiseGui[\ampStepSliders][ampStep].value = ~params[i][\ampStep][ampStepNum];
			~noiseGui[\ampStepNumbox][ampStep].value  = ~params[i][\ampStep][ampStepNum];
			~noiseGui[\ampStepsSelector][ampStep].value = 0;
		};
	};
}.value;



