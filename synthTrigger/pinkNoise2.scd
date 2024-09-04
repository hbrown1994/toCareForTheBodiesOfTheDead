(
~noiseSynths.add(\pinkNoise2 ->
	Synth(\pinkNoise, [
		\gate, 1, \amp, ~params[\pinkNoise][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\hpf, ~params[\pinkNoise][\hpf], \lpf, ~params[\pinkNoise][\lpf],
		\route0, ~params[\pinkNoise][\route][0], \route1, ~params[\pinkNoise][\route][1], \route2, ~params[\pinkNoise][\route][2], \route3, ~params[\pinkNoise][\route][3],
		\route4, ~params[\pinkNoise][\route][4], \route5, ~params[\pinkNoise][\route][5], \route6, ~params[\pinkNoise][\route][6], \route7, ~params[\pinkNoise][\route][7],
		\ampStepSel, ~params[\pinkNoise][\ampStepSel][2]
	], ~nodes[\fixed]).register;
);
);