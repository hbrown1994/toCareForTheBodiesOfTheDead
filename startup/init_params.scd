Routine{
	~params = Dictionary.newFrom([\forestOut, 2, \forestOutputChannels, 6, \mainOut, 0, \spatialOut, 0, \spatialOutputChannels, 8, \sample2chSlider, 1]);

	0.005.wait;

	(~inputSynthNames).do{|i, j|
		~params.add(i -> Dictionary.newFrom([\in1, j, \lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \pan, 0,  \amp, 0, \out, ~params[\mainOut]]));
	};


	(~sendSynthNames).do{|i, j|
		~params.add(i -> Dictionary.newFrom([\in1, j, \lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \pan, 0, \amp, 0]));
	};

	//__________________FX__________________
	~params.add(\violaGrains -> Dictionary.newFrom([
		\amp, 0, \hpfFreq, 20, \lpfFreq, 20000,  \out, ~params[\mainOut],
		\receive0, 1, \receive1, 0, \receive2, 0,
		\noiseGateThresh, 0.0,
		\grainEnv, -1, \recBufSize, 4,

		\rateLow, 0.9, \rateHigh, 3.14,
		\grainSizeLow, 0.005,  \grainSizeHigh, 0.2,

		\dustFreq, 35,

		\stutterProbTrigRate, 6, \stutterProb, 0.2,
		\stutterFreqLow, 10, \stutterFreqHigh, 50,

		\pointerDev, 1, \pointerRandMax, 3.2, \minPointerDelay, 0.1, \pointerDelay, 0.5

	]));

	~params.add(\freeze -> Dictionary.newFrom([
		\amp, 0, \hpfFreq, 20, \lpfFreq, 20000,  \out, ~params[\mainOut],
		\receive0, 1, \receive1, 1, \receive2, 1,
		\routeSel, 0,
		\route0, [1, 1, 0, 0, 0, 0, 0, 0], \route1, [1, 1, 0, 0, 0, 0, 0, 0]
	]));

	~params.add(\freezeFade -> Dictionary.newFrom([
		\amp, 0, \hpfFreq, 20, \lpfFreq, 20000,  \out, ~params[\mainOut],
		\receive0, 1, \receive1, 1, \receive2, 1,
		\route0, [1, 1, 0, 0, 0, 0, 0, 0], \route1, [1, 1, 0, 0, 0, 0, 0, 0],
		\routeSel, 0,
		\atkLow, 0.005, \atkHigh, 0.005, \relLow, 0.005, \relHigh, 0.005
	]));

	//__________________Noise__________________
	~params.add(\whiteNoise -> Dictionary.newFrom([
		\amp, 0, \hpfFreq, 20, \lpfFreq, 20000,  \out, ~params[\mainOut], \lpfOn, 0, \hpfOn, 0,
		\route, 1!8, \ampStep, [0.1, 0.3, 0.6, 1], \ampStepSel, 1
	]));

	~params.add(\pinkNoise -> Dictionary.newFrom([
		\amp, 0, \hpfFreq, 20, \lpfFreq, 20000,  \out, ~params[\mainOut], \lpfOn, 0, \hpfOn, 0,
		\route, 1!8, \ampStep, [0.1, 0.3, 0.6, 1], \ampStepSel, 1
	]));

	//__________________Samples__________________
	~buffersNames[\samples_2ch].do{|i|
		i=i.asSymbol;
		~params.add(i -> Dictionary.newFrom(
			[
				\lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \amp, 1, \out, ~params[\mainOut],
				\route0, 1, \route1, 1, \route2, 0, \route3, 0, \route4, 0, \route5, 0, \route6, 0, \route7, 0,
				\groupAmp, 1,
			]
		));
	};

	~buffersNames[\samples_8ch].do{|i|
		i=i.asSymbol;
		~params.add(i -> Dictionary.newFrom(
			[
				\lpfOn, 0, \hpfOn, 0, \lpfFreq, 20000, \hpfFreq, 20, \amp, 1, \out, ~params[\mainOut],
				\startPos, 0,
			]
		));
	};

	"Parameters Loaded".postln;

}.play(AppClock);


