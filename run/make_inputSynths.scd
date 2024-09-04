~inputSynthNames.do{|i|
	~inputSynths.add(
		Synth(\input, [
			\in1, ~params[i][\in1], \in2,~params[i][\in2],
			\lpfOn, ~params[i][\lpfOn], \hpfOn, ~params[i][\hpfOn],
			\lpfFreq, ~params[i][\lpfFreq], \hpfFreq, ~params[i][\hpfFreq],
			\out, ~params[i][\out], \pan, ~params[i][\pan], \amp, ~params[i][\amp],
			\masterAmp, ~masterAmp
		], ~nodes[\input]).register;
	);
};

~sendSynthNames.do{|i|
	~sendSynths.add(
		Synth(\input, [
			\in1, ~params[i][\in1], \in2,~params[i][\in2],
			\lpfOn, ~params[i][\lpfOn], \hpfOn, ~params[i][\hpfOn],
			\lpfFreq, ~params[i][\lpfFreq], \hpfFreq, ~params[i][\hpfFreq],
			\out, ~busses[i], \pan, ~params[i][\pan], \amp, ~params[i][\amp],
			\masterAmp, 1
		], ~nodes[\sends]).register;
	);
};
