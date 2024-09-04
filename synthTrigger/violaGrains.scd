(
~fxSynths.add(\violaGrains ->
	Synth(\violaGrains, [
		\gate, 1, \amp, ~params[\violaGrains][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0,  ~busses[~sendSynthNames[0]],

		\hpfFreq, ~params[\violaGrains][\hpfFreq], \lpfFreq, ~params[\violaGrains][\lpfFreq],

		\noiseGateThresh, ~params[\violaGrains][\noiseGateThresh],
		\grainEnv, ~params[\violaGrains][\grainEnv], \recBufSize, ~params[\violaGrains][\recBufSize],

		\rateLow, ~params[\violaGrains][\rateLow], \rateHigh, ~params[\violaGrains][\rateHigh],
		\grainSizeLow, ~params[\violaGrains][\grainSizeLow],  \grainSizeHigh, ~params[\violaGrains][\grainSizeHigh],

		\dustFreq, ~params[\violaGrains][\dustFreq],

		\stutterProbTrigRate, ~params[\violaGrains][\stutterProbTrigRate], \stutterProb, ~params[\violaGrains][\stutterProb],
		\stutterFreqLow, ~params[\violaGrains][\stutterFreqLow], \stutterFreqHigh, ~params[\violaGrains][\stutterFreqHigh],

		\pointerDev, ~params[\violaGrains][\pointerDev], \pointerRandMax, ~params[\violaGrains][\pointerRandMax],
		\minPointerDelay, ~params[\violaGrains][\minPointerDelay], \pointerDelay, ~params[\violaGrains][\pointerDelay]
	], ~nodes[\fx]).register;
);
);