(
SynthDef(\pinkNoise, {
	arg ampStepSel, out, amp, hpf=20, lpf=20000, lpfFreq, hpfFreq, lpfOn, hpfOn, masterAmp, route0, route1, route2, route3, route4, route5, route6, route7, gate=0;
	var sig, routeMarkov0, routeMarkov1, sigPan0, sigPan1, sigMix;
	var route = [ route0, route1, route2, route3, route4, route5, route6, route7];

	sig = PinkNoise.ar(0.6);

	sig = sig * EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq.lag(0.005))]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq.lag(0.005))]);

	sig = sig * ampStepSel.linexp(0.0, 1.0, 0.001, 1.0);

	sig = sig * amp * masterAmp;

	routeMarkov0 = TWindex.kr(gate, route, 1);
	routeMarkov1 = TWindex.kr(gate, route, 1);
	routeMarkov1 = Select.kr(
		BinaryOpUGen('==', routeMarkov0, routeMarkov1),
		[
			routeMarkov1,
			(routeMarkov1+(TIRand.kr(1, 6, gate))).wrap(0, 7)
		]
	);

	sigPan0 = PanX.ar(8, sig, routeMarkov0/(~numChannels-1));
	sigPan1 = PanX.ar(8, sig, routeMarkov1/(~numChannels-1));

	sigMix = sigPan0 + sigPan1;

	Out.ar(out, sigMix);
}).add;
);