(
MIDIIn.connectAll;


/*________________Fixed Samples_______________________*/
{
	var noise = [\whiteNoise, \pinkNoise], whiteNoiseMIDI = [37, 39, 41, 43], pinkoiseMIDI = [36, 38, 40, 42];
	var noiseMIDINotes = [whiteNoiseMIDI, pinkoiseMIDI];
	var samples2ch = ~buffersNames[\samples_2ch], samples2chMIDI = [45, 47, 49, 51];
	var samples8ch = ~buffersNames[\samples_8ch], samples8chMIDI = [44, 46];

	/*________________Noise_______________________*/
	noise.do{|thisNoise, thisNoiseIndex|
		noiseMIDINotes[thisNoiseIndex].do{|midiNum, index|
			MIDIFunc.noteOn({
				if(~noiseSynths[(thisNoise.asString++index).asSymbol].isPlaying, {nil}, {
					thisProcess.interpreter.executeFile(~path[\synthTrigger]++thisNoise.asString++index++".scd");
					~noiseSynths[(thisNoise.asString++index).asSymbol].set(\ampStepSel, ~params[thisNoise][\ampStep][index])
				});

				{~noiseGui[\ampStepsSelector][(thisNoise.asString++index).asSymbol].value = 1}.defer;
			}, midiNum,  ~nanoPadMIDIChan);

			MIDIFunc.noteOff({
				if(~noiseSynths[(thisNoise.asString++index).asSymbol].isPlaying, {~noiseSynths[(thisNoise.asString++index).asSymbol].set(\gate, 0)});
				{~noiseGui[\ampStepsSelector][(thisNoise.asString++index).asSymbol].value = 0}.defer;
			}, midiNum,  ~nanoPadMIDIChan);
		};
	};

	/*________________Samples 2ch_______________________*/

	samples2ch.do{|sample, index|
		var thisSample = sample.asSymbol;
		var midiNum = samples2chMIDI[index];

		MIDIFunc.noteOn({
			if(~samples2chSynths[index].isPlaying, {~samples2chSynths[index].set(\t_trig, 1)}, {
				~samples2chSynths[index] = Synth(\oneShotRel, [\gate, 1,
					\buf, ~buffers[\samples_2ch][index],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\groupAmp, ~params[thisSample][\groupAmp],
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});

			{~samples2chGui[\trig][thisSample].value = 1}.defer;
		}, midiNum,  ~nanoPadMIDIChan);

		MIDIFunc.noteOff({
			if(~samples2chSynths[index].isPlaying, {~samples2chSynths[index].set(\gate, 0)});
			{~samples2chGui[\trig][thisSample].value = 0}.defer;
		}, midiNum,  ~nanoPadMIDIChan);
	};

	/*________________Samples 8ch_______________________*/
	samples8ch.do{|sample, index|
		var thisSample = sample.asSymbol;
		var midiNum = samples8chMIDI[index];

		MIDIFunc.noteOn({
			if(~samples8chSynths[index].isPlaying, {~samples8chSynths[index].set(\t_trig, 1)}, {
				~samples8chSynths[index] = Synth(\oneShot_8ch, [\gate, 1,
					\buf, ~buffers[\samples_8ch][index],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
					\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
					\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
					\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
				], ~nodes[\fixed]).register;
			});

			{~samples8chGui[\trig][thisSample].value = 1}.defer;
		}, midiNum,  ~nanoPadMIDIChan);

		MIDIFunc.noteOff({
			if(~samples8chSynths[index].isPlaying, {~samples8chSynths[index].set(\gate, 0)});
			{~samples8chGui[\trig][thisSample].value = 0}.defer;
		}, midiNum,  ~nanoPadMIDIChan);
	};
}.value;

/*________________Ensemble FXs_______________________*/
{
	var fxNames = ~fxNames, midiOn = [64, 65, 66], midiOnAlt=[48, 49, 50], midiOff = [32, 33, 34];
	var midiOut=MIDIOut.newByName("nanoKONTROL2",  "CTRL").latency=Server.local.latency;

	3.do{|i|
		midiOut.noteOn(~nanoKontrolMIDIChan, midiOff[i]);
		midiOut.noteOff(~nanoKontrolMIDIChan, midiOn[i]);
		midiOut.noteOff(~nanoKontrolMIDIChan, midiOnAlt[i]);
	};

	fxNames.do{|fxName, fxNameIndex|
		/*_________ ON __________*/
		MIDIFunc.noteOn({
			if(fxName!=\violaGrains,
				~params[fxName][\routeSel]=0;

				{
					if(~fxSynths[fxName].isPlaying,
						{
							~fxSynths[fxName].set(
								\t_trig, 1,
								\route0, ~params[fxName][("route"++0).asSymbol][0],
								\route1, ~params[fxName][("route"++0).asSymbol][1],
								\route2, ~params[fxName][("route"++0).asSymbol][2],
								\route3, ~params[fxName][("route"++0).asSymbol][3],
								\route4, ~params[fxName][("route"++0).asSymbol][4],
								\route5, ~params[fxName][("route"++0).asSymbol][5],
								\route6, ~params[fxName][("route"++0).asSymbol][6],
								\route7, ~params[fxName][("route"++0).asSymbol][7]
							);

							midiOut.noteOn(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
							midiOut.noteOff(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
						},
						{
							thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd");
							{~fxGui[\onOff][fxName].value = 1};

							midiOut.noteOn(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
							midiOut.noteOff(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
							midiOut.noteOff(~nanoKontrolMIDIChan, midiOff[fxNameIndex]);
					});
				},
				{
					if(~fxSynths[fxName].isPlaying, {nil}, {
						thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd");
					});
					midiOut.noteOn(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
					midiOut.noteOff(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
					midiOut.noteOff(~nanoKontrolMIDIChan, midiOff[fxNameIndex]);
				}
			);
		}, midiOn[fxNameIndex], ~nanoKontrolMIDIChan);


		/*_________ ON-Alt __________*/
		MIDIFunc.noteOn({
			if(fxName!=\violaGrains,
				{
					~params[fxName][\routeSel]=1;
					if(~fxSynths[fxName].isPlaying,
						{
							~fxSynths[fxName].set(
								\t_trig, 1,
								\route0, ~params[fxName][("route"++1).asSymbol][0],
								\route1, ~params[fxName][("route"++1).asSymbol][1],
								\route2, ~params[fxName][("route"++1).asSymbol][2],
								\route3, ~params[fxName][("route"++1).asSymbol][3],
								\route4, ~params[fxName][("route"++1).asSymbol][4],
								\route5, ~params[fxName][("route"++1).asSymbol][5],
								\route6, ~params[fxName][("route"++1).asSymbol][6],
								\route7, ~params[fxName][("route"++1).asSymbol][7]
							);
							midiOut.noteOff(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
							midiOut.noteOn(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
						},
						{
							thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd");
							{~fxGui[\onOff][fxName].value = 1};

							midiOut.noteOn(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
							midiOut.noteOff(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
							midiOut.noteOff(~nanoKontrolMIDIChan, midiOff[fxNameIndex]);
					});
				},
				{
					if(~fxSynths[fxName].isPlaying, {nil}, {
						thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd");
					});
					midiOut.noteOn(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
					midiOut.noteOff(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
					midiOut.noteOff(~nanoKontrolMIDIChan, midiOff[fxNameIndex]);
				}
			);
		}, midiOnAlt[fxNameIndex], ~nanoKontrolMIDIChan);


		/*_________ OFF __________*/
		MIDIFunc.noteOn({
			if(~fxSynths[fxName].isPlaying, {
				~fxSynths[fxName].set(\gate, 0);
				{~fxGui[\onOff][fxName].value = 0}.defer;
				midiOut.noteOn(~nanoKontrolMIDIChan, midiOff[fxNameIndex]);
				midiOut.noteOff(~nanoKontrolMIDIChan, midiOn[fxNameIndex]);
				midiOut.noteOff(~nanoKontrolMIDIChan, midiOnAlt[fxNameIndex]);
			});
		}, midiOff[fxNameIndex], ~nanoKontrolMIDIChan);
	};
}.value;


/*________________Sliders_______________________*/
{
	var sliderNames = [\whiteNoise, \pinkNoise];

	[0, 1, 2].do{|i, index|
		var fxName = [\violaGrains, \freeze, \freezeFade][index];

		MIDIFunc.cc({arg val;
			val = val / 127;
			~params[fxName][\amp] = val;
			if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(\amp, val)});
			{~fxGui[\amp][fxName].value_(val)}.defer;
			{~fxGui[\ampNumbox][fxName].value_(val.ampdb)}.defer;
		}, i, ~nanoKontrolMIDIChan)
	};


	[3, 4].do{|i, index|
		var thisNoise = [\whiteNoise, \pinkNoise][index];
		MIDIFunc.cc({arg val;
			val = val / 127;
			~params[thisNoise][\amp] = val;
			{~noiseGui[\amp][thisNoise].value_(val)}.defer;
			{~noiseGui[\ampNumbox][thisNoise].value_(val.ampdb)}.defer;

			4.do{|noiseIndex|
				var synthName = (thisNoise.asString++noiseIndex).asSymbol;
				if(~noiseSynths[synthName].isPlaying, {~noiseSynths[synthName].set(\amp, val)});
			};
		}, i, ~nanoKontrolMIDIChan)
	};

	[5].do{|i, index|
		MIDIFunc.cc({arg val;
			val = val / 127;
			{
				~mainGui[\sample2chSlider].value = val;
				~mainGui[\sample2chNumbox].value = val.ampdb;
			}.defer;

			~samples2chSynths.keysDo{|i|
				if(~samples2chSynths[i].isPlaying, {~samples2chSynths[i].set(\groupAmp,  val)});
			};

			~buffersNames[\samples_2ch].do{|i|
				~params[i.asSymbol][\groupAmp] = val;
			};
			~params[\sample2chpSlider] = val;
		}, i, ~nanoKontrolMIDIChan)
	};

	[6, 7].do{|i, index|
		var thisSample = ~buffersNames[\samples_8ch][index].asSymbol;

		MIDIFunc.cc({arg val;
			val = val / 127;

			{
				~samples8chGui[\amp][thisSample].value_(val);
				~samples8chGui[\ampNumbox][thisSample].value_(val.ampdb);
			}.defer;

			~params[thisSample][\amp] = val;

			if(~samples8chSynths[index].isPlaying, {~samples8chSynths[index].set(\amp, val.value)});

		}, i, ~nanoKontrolMIDIChan);
	};

}.value;
);


