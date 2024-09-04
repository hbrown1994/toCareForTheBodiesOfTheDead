(
~noiseSynths.add(\whiteNoise1 ->
	Synth(\whiteNoise, [
		\gate, 1, \amp, ~params[\whiteNoise][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\hpf, ~params[\whiteNoise][\hpf], \lpf, ~params[\whiteNoise][\lpf],
		\route0, ~params[\whiteNoise][\route][0], \route1, ~params[\whiteNoise][\route][1], \route2, ~params[\whiteNoise][\route][2], \route3, ~params[\whiteNoise][\route][3],
		\route4, ~params[\whiteNoise][\route][4], \route5, ~params[\whiteNoise][\route][5], \route6, ~params[\whiteNoise][\route][6], \route7, ~params[\whiteNoise][\route][7],
		\ampStepSel, ~params[\whiteNoise][\ampStepSel][1]
	], ~nodes[\fixed]).register;
);
);