(
SynthDef(\violaGrains, {
	arg pointerDev, noiseGateThresh=0.001, stutterProbTrigRate, grainSizeLow, grainSizeHigh, stutterFreqLow, stutterFreqHigh, stutterProb=0.5, out=0, receive0=1, gate, masterAmp, hpfFreq=20, lpfFreq=20000, amp, in0, rateLow, rateHigh, dustFreq, buf, recBufSize, recBuf, grainEnv, pointerRandMax = 3000, minPointerDelay=1000, pointerDelay=(s.sampleRate/4);
	var in, bufRecPhasor, bufRec, dust, pan, dur, rate, pos, sig, grainSizeSample, pointer, pointerRand, totalDelay, maxGrainDur, onsets, stutterBuf, stutterPhasor, stutter, stutterBufSize, stutterOnOff, stutterProbTrig;

	in = Mix(In.ar(in0, 2))*receive0;

	// apply gate (mouse x sets treshold)
	in = Compander.ar(in, in,
		thresh: noiseGateThresh,
		slopeBelow: 10,
		slopeAbove:  1,
		clampTime:   0.01,
		relaxTime:   0.01
	);

	stutterProbTrig = Dust.kr(stutterProbTrigRate);
	stutterOnOff = TWindex.kr(stutterProbTrig, [1-stutterProb, stutterProb])+Impulse.kr(0);

	recBufSize = recBufSize * SampleRate.ir;
	recBuf = LocalBuf(recBufSize, 1).clear;
	bufRecPhasor = Phasor.ar(0, stutterOnOff.linlin(0, 1, 1, 0), 0, recBufSize);
	BufWr.ar(in, recBuf, bufRecPhasor, 0);

	dust = Select.kr(stutterOnOff, [Dust.kr(dustFreq), Impulse.kr(TExpRand.kr(stutterFreqLow, stutterFreqHigh, stutterOnOff))]);

	dur = Gate.kr(TExpRand.kr(grainSizeLow, grainSizeHigh, dust), stutterOnOff.linlin(0, 1, 1, 0));
	rate = Gate.kr(TExpRand.kr(rateLow, rateHigh, dust), stutterOnOff.linlin(0, 1, 1, 0));
	pan =  Gate.kr(TBrownRand.kr(-1.0, 1.0, 1.0, 0, dust), stutterOnOff.linlin(0, 1, 1, 0));

	pointerRandMax = pointerRandMax*SampleRate.ir;
	pointerRand = Gate.kr(TBrownRand.kr(pointerRandMax.neg, pointerRandMax, pointerDev, 0, dust), stutterOnOff.linlin(0, 1, 1, 0));
	pointerDelay = pointerDelay * SampleRate.ir;
	totalDelay = max(pointerDelay - pointerRand, minPointerDelay*SampleRate.ir);

	pointer = bufRecPhasor - totalDelay;
	pointer = (pointer / recBufSize) %1;
	maxGrainDur = (totalDelay / rate) / SampleRate.ir;
	dur = min(dur, maxGrainDur);

	sig = GrainBuf.ar(~params[\spatialOutputChannels], dust, dur, recBuf, rate, pointer, 4, pan, grainEnv);

	amp = Select.kr(amp>0, [0, amp.linexp(0.0, 1.0, 0.001, 1.0)]);
	sig = sig * amp * masterAmp;
	sig = sig * EnvGen.kr(Env.asr(0.005, 1, 0.005), gate, doneAction: 2);

	sig = HPF.ar(sig, hpfFreq);
	sig = LPF.ar(sig, lpfFreq);

	Out.ar(out, sig);
}).add;
);