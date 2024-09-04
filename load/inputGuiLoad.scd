{
	var inputGuiNames = [
		\in1, \out,
	];

	var inputGuiNamesPerc = [
		\in1, \out,
	];

	var filterGuiNames = [
		\lpfOn, \hpfOn, \lpfFreq, \lpfNumbox, \hpfFreq, \hpfNumbox
	];

	(~instrumentNames.size).do{|i|

		~dryGui[\amp][i].value = ~params[~inputSynthNames[i]][\amp];
		~dryGui[\ampNumbox][i].value = ~params[~inputSynthNames[i]][\amp].ampdb;

		~sendGui[\amp][i].value = ~params[~sendSynthNames[i]][\amp];
		~sendGui[\ampNumbox][i].value = ~params[~sendSynthNames[i]][\amp].ampdb;

		~dryGui[\pan][i].value = ~params[~inputSynthNames[i]][\pan].linlin(-1.0, 1.0, 0.0, 1.0);
		~dryGui[\panNumbox][i].value = ~params[~inputSynthNames[i]][\pan];

		~sendGui[\pan][i].value = ~params[~sendSynthNames[i]][\pan].linlin(-1.0, 1.0, 0.0, 1.0);
		~sendGui[\panNumbox][i].value = ~params[~sendSynthNames[i]][\pan];

		//FILTERS////
		~dryGui[\lpfOn][i].value = ~params[~inputSynthNames[i]][\lpfOn];
		~dryGui[\hpfOn][i].value = ~params[~inputSynthNames[i]][\hpfOn];

		~dryGui[\lpfFreq][i].value = ~params[~inputSynthNames[i]][\lpfFreq].linlin(8000, 20000, 0.0, 1.0);
		~dryGui[\lpfNumbox][i].value = ~params[~inputSynthNames[i]][\lpfFreq];

		~dryGui[\hpfFreq][i].value = ~params[~inputSynthNames[i]][\hpfFreq].linlin(20, 200, 0.0, 1.0);
		~dryGui[\hpfNumbox][i].value = ~params[~inputSynthNames[i]][\hpfFreq];

		~sendGui[\lpfOn][i].value = ~params[~inputSynthNames[i]][\lpfOn];
		~sendGui[\hpfOn][i].value = ~params[~inputSynthNames[i]][\hpfOn];

		~sendGui[\lpfFreq][i].value = ~params[~inputSynthNames[i]][\lpfFreq].linlin(8000, 20000, 0.0, 1.0);
		~sendGui[\lpfNumbox][i].value = ~params[~inputSynthNames[i]][\lpfFreq];

		~sendGui[\hpfFreq][i].value = ~params[~inputSynthNames[i]][\hpfFreq].linlin(20, 200, 0.0, 1.0);
		~sendGui[\hpfNumbox][i].value = ~params[~inputSynthNames[i]][\hpfFreq];

	};

	~inputSynthNames.do{|i, j|
		inputGuiNames.do{|k|
			~inputGui[k][j].value = ~params[i][k].asString;
		};
	};
}.value;
