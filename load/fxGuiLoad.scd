{
	var fxNames = ["violaGrains", "freeze", "freezeFade"];

	var fxParams = Dictionary.newFrom([
		\violaGrains, [
			\hpfFreq, \lpfFreq,
			\noiseGateThresh,
			\recBufSize,
			\rateLow, \rateHigh,
			\grainSizeLow, \grainSizeHigh,
			\dustFreq,
			\stutterProbTrigRate, \stutterProb,
			\stutterFreqLow, \stutterFreqHigh,
			\pointerDev, \pointerRandMax, \minPointerDelay, \pointerDelay

		],
		\freeze, [\hpfFreq, \lpfFreq, \route0, \route1],
		\freezeFade, [\hpfFreq, \lpfFreq, \atkLow, \atkHigh, \relLow, \relHigh, \route0, \route1],

	]);

	var fxParamsMin = Dictionary.newFrom([
		\violaGrains, [
			20, 4000, //\hpf, \lpf,
			0, //\noiseGateThresh
			1, //\recBufSize
			0.1, 1, //\rateLow, \rateHigh
			0.001, 0.1, //\grainSizeLow, \grainSizeHigh
			0.1, //\dustFreq
			0.01, 0.0, //\stutterProbTrigRate, \stutterProb,
			0.5, 10, //\stutterProbTrigRate, \stutterProb
			0, 0.5, 0.01, 0.1 //\pointerDev, \pointerRandMax, \minPointerDelay, \pointerDelay

		],
		\freeze, [20, 4000],
		\freezeFade, [20, 4000, 0.005, 0.005, 0.005, 0.005],
	]);

	var fxParamsMax = Dictionary.newFrom([
		\violaGrains, [
			200, 20000, //\hpf, \lpf,
			1, //\noiseGateThresh
			8,  //\recBufSize
			1, 10, //\rateLow, \rateHigh
			0.1, 0.4, //\grainSizeLow, \grainSizeHigh
			70, //\dustFreq
			20,  1, //\stutterProbTrigRate, \stutterProb,
			20, 100, //\stutterFreqLow, \stutterFreqHigh,
			1, 4, 1, 4 //\pointerDev, \pointerRandMax, \minPointerDelay, \pointerDelay
		],
		\freeze, [200, 20000],
		\freezeFade, [200, 20000, 4.0, 8.0, 4.0, 8.0],
	]);

	var receives =  Dictionary.newFrom([\viola, \receive0, \cello, \receive1, \bass, \receive2]);

	fxNames.do{|fxName|

		~fxGui[\onOff][fxName.asSymbol].value = 0;

		~fxGui[\amp][fxName.asSymbol].value = ~params[fxName.asSymbol][\amp];
		~fxGui[\ampNumbox][fxName.asSymbol].value = ~params[fxName.asSymbol][\amp].ampdb;

		~fxGui[\onOff][fxName.asSymbol].valueAction = 0;

		receives.keysDo{|i|
			~fxGui[("receiveSliders"++fxName).asSymbol][i].value = ~params[fxName.asSymbol][receives[i]];
			~fxGui[("receiveNumbox"++fxName).asSymbol][i].value = ~params[fxName.asSymbol][receives[i]].ampdb;
		};

		fxParams[fxName.asSymbol].do{|param, index|

			if(param==\route0 || {param==\route1},
				{
					8.do{|i|
						~fxGui[(param.asString++"Buttons"++fxName).asSymbol][i.asSymbol].value = ~params[fxName.asSymbol][param][i]
					};
				},
				{
					~fxGui[("paramSliders"++fxName).asSymbol][param].value = ~params[fxName.asSymbol][param].linlin(fxParamsMin[fxName.asSymbol][index], fxParamsMax[fxName.asSymbol][index], 0, 1);
					~fxGui[("paramNumbox"++fxName).asSymbol][param].value = ~params[fxName.asSymbol][param];
			});
		};
	};
}.value;


