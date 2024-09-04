(
SynthDef(\oneShot_8ch, {
	arg startPos, buf, out, amp, hpf=20, lpf=20000, lpfFreq, hpfFreq, lpfOn, hpfOn, masterAmp, gate=0;
	var sig;

	sig = PlayBuf.ar(8, buf, BufRateScale.kr(buf), gate, startPos, 0, 2);

	sig = sig * EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = Select.ar(lpfOn.lag(0.005), [sig, LPF.ar(sig, lpfFreq.lag(0.005))]);
	sig = Select.ar(hpfOn.lag(0.005), [sig, HPF.ar(sig, hpfFreq.lag(0.005))]);

	amp = Select.kr(amp>0, [0, amp.linexp(0.0, 1.0, 0.001, 1.0)]);

	sig = sig * amp * masterAmp;

	Out.ar(out, sig);
}).add;
);

