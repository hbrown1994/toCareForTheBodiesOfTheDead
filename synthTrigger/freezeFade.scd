(
~fxSynths.add(\freezeFade ->
	Synth(\freezeFade, [
		\gate, 1, \t_trig, 1, \amp, ~params[\freezeFade][\amp], \masterAmp, ~masterAmp,
		\out, ~params[\mainOut],
		\in0,  ~busses[~sendSynthNames[0]],
		\in1,  ~busses[~sendSynthNames[1]],
		\in2,  ~busses[~sendSynthNames[2]],
		\hpfFreq, ~params[\freezeFade][\hpfFreq], \lpfFreq, ~params[\freezeFade][\lpfFreq],
		\route0, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][0],
		\route1, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][1],
		\route2, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][2],
		\route3, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][3],
		\route4, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][4],
		\route5, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][5],
		\route6, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][6],
		\route7, ~params[\freezeFade][("route"++~params[\freezeFade][\routeSel]).asSymbol][7]
	], ~nodes[\fx]).register;
);
);