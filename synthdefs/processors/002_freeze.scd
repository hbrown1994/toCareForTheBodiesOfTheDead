(
SynthDef(\freeze, {
	arg receive0=1, receive1=1, receive2=1, gate, masterAmp, hpfFreq=20, lpfFreq=20000, amp, out, t_trig=0, in0, in1, in2, route0=1, route1=1, route2=0, route3=0, route4=0, route5=0, route6=0, route7=0;
	var in, sig, chain, route = [ route0, route1, route2, route3, route4, route5, route6, route7];

	in = Mix([
		In.ar(in0, 2)*receive0,
		In.ar(in1, 2)*receive1,
		In.ar(in2, 2)*receive2,
	]);

	in=Mix(in);
	in = HPF.ar(in, 80);

	chain = FFT(LocalBuf(1024, 1), in);
	chain = PV_Freeze(chain, SetResetFF.kr(DelayN.kr(t_trig, 0.05, 0.05), t_trig));
	sig = IFFT(chain);

	sig = sig * EnvGen.kr(Env.asr(0.05, 1, 0.05), gate, doneAction: 2);
	sig = sig * EnvGen.kr(Env.new([0.0, 1], [0.005]), DelayN.kr(gate, 0.05, 0.05), doneAction: 0);

	amp = Select.kr(amp>0, [0, amp.linexp(0.0, 1.0, 0.001, 1.0)]);

	sig = sig * amp * masterAmp;

	sig = HPF.ar(sig, hpfFreq);
	sig = LPF.ar(sig, lpfFreq);

	sig = sig * route.lag(0.005);

	Out.ar(out, sig);
}).add;
);