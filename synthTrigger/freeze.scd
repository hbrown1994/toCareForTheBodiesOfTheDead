(
~fxSynths.add(\freeze ->
	Synth(\freeze, [
		\gate, 1, \t_trig, 1, \amp, ~params[\freeze][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0,  ~busses[~sendSynthNames[0]],
		\in1,  ~busses[~sendSynthNames[1]],
		\in2,  ~busses[~sendSynthNames[2]],
		\hpfFreq, ~params[\freeze][\hpfFreq], \lpfFreq, ~params[\freeze][\lpfFreq],
		\route0, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][0],
		\route1, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][1],
		\route2, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][2],
		\route3, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][3],
		\route4, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][4],
		\route5, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][5],
		\route6, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][6],
		\route7, ~params[\freeze][("route"++~params[\freeze][\routeSel]).asSymbol][7]
	], ~nodes[\fx]).register;
);
);

