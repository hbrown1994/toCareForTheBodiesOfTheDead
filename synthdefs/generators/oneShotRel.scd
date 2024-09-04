(
SynthDef(\oneShotRel, {
	arg groupAmp, buf, out, amp, hpf=20, lpf=20000, lpfFreq, hpfFreq, lpfOn, hpfOn, masterAmp, route0, route1, route2, route3, route4, route5, route6, route7, gate=0;
	var sig;
	var route = [ route0, route1, route2, route3, route4, route5, route6, route7];

	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), gate, 0, 1);

	sig = sig * EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq.lag(0.005))]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq.lag(0.005))]);

	amp = Select.kr(amp>0, [0, amp.linexp(0.0, 1.0, 0.001, 1.0)]);
	groupAmp = Select.kr(groupAmp>0, [0, groupAmp.linexp(0.0, 1.0, 0.001, 1.0)]);

	sig = sig * amp * masterAmp * groupAmp;

	sig = sig*route;

	Out.ar(out, sig);
}).add;
);

