{
	var window, compositeViews=List.new, sampleNames, numCompositeViews, height=805;

	~samples8chGui = Dictionary.newFrom([
		\filterWindows, Dictionary.new, \filterButtons, Dictionary.new,
		\amp, Dictionary.new, \ampNumbox, Dictionary.new, \trig, Dictionary.new,
		\lpfOn, Dictionary.new, \lpfFreq, Dictionary.new, \lpfNumbox, Dictionary.new, \hpfOn, Dictionary.new, \hpfFreq, Dictionary.new, \hpfNumbox, Dictionary.new,
		\startTimeSlider, Dictionary.new, \startTimeNumbox, Dictionary.new, \window, nil,

	]);

	numCompositeViews=~buffersNames[\samples_8ch].size;

	window = Window.new("Samples 8ch", Rect(0, 600, 100*~buffersNames[\samples_8ch].size, height)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );
	window.visible = false;
	~samples8chGui[\window] = window;

	numCompositeViews.do{|i| compositeViews.add(CompositeView( window.view, 100@height ).background_( Color.yellow(val: ([0.6, 0.8]!5).flatten[i], alpha: 1.0) )) };

	compositeViews.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisSample = ~buffersNames[\samples_8ch][j].asSymbol;
		f = StaticText(i, Rect(5, 5, 130, 20)).string = thisSample;
		f.font = Font("Helvetica", 18);

		~samples8chGui[\trig].add(thisSample ->
			Button(i, Rect(5, 30, 90, 50))
			.states_([["Play", Color.black, Color.grey], ["Off", Color.black, Color.red]])
			.action_({arg val;
				if(val.value==1, {
					if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\t_trig, 1)}, {
						~samples8chSynths[j] = Synth(\oneShot_8ch, [\gate, 1, \startPos, ~params[thisSample][\startPos],
							\buf, ~buffers[\samples_8ch][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
							\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
						], ~nodes[\fixed]).register;
					});
				},
				{~samples8chSynths[j].set(\gate, 0)}
				);
			});
		);

		//outputSlider
		StaticText(i, Rect(35, 80, 100, 20)).string = "Out";
		~samples8chGui[\amp].add(thisSample ->
			Slider(i, Rect(3, 100, 90, 300))
			.value_(1)
			.action_({arg val;
				~params[thisSample][\amp] = val.value;
				~samples8chGui[\ampNumbox][thisSample].value_(val.value.ampdb);
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\amp, val.value)});
			});
		);

		//~samples8chGui[\ampNumbox]
		~samples8chGui[\ampNumbox].add(thisSample ->
			NumberBox(i, Rect(3, 400, 90, 20))
			.value_(0)
			.action_({arg val;
				~samples8chGui[\amp][thisSample].valueAction_(val.value.dbamp);
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\amp, val.value.dbamp)});
			});
		);

		//filters
		~samples8chGui[\filterWindows].add(thisSample -> Window.new("Filters: "++thisSample.asString, Rect(30, 100, 630, 120)).visible=false);

		~samples8chGui[\filterButtons].add(thisSample -> Button(i, Rect(3, 423, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg val; if(val.value==1, {~samples8chGui[\filterWindows][thisSample].visible=true}, {~samples8chGui[\filterWindows][thisSample].visible=false})});
		);


		//filtersOnOff
		~samples8chGui[\lpfOn].add(thisSample ->
			Button(~samples8chGui[\filterWindows][thisSample], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisSample][\lpfOn] = val.value;
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\lpfOn, val.value)});

			});
		);
		//
		~samples8chGui[\hpfOn].add(thisSample ->
			Button(~samples8chGui[\filterWindows][thisSample], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisSample][\hpfOn] = val.value;
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\hpfOn, val.value)});
			});
		);
		//
		~samples8chGui[\lpfFreq].add(thisSample ->
			Slider(~samples8chGui[\filterWindows][thisSample], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 8000, 20000);
				~samples8chGui[\lpfNumbox][thisSample].value_(val);
				~params[thisSample][\lpfFreq] = val;
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\lpfFreq, val)});
			});
		);
		//
		~samples8chGui[\lpfNumbox].add(thisSample ->
			NumberBox(~samples8chGui[\filterWindows][thisSample], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(8000, 20000, 0.0, 1.0);
				~samples8chGui[\lpfFreq][thisSample].valueAction_(val);
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\lpfFreq, val)});
			});
		);
		//
		~samples8chGui[\hpfFreq].add(thisSample ->
			Slider(~samples8chGui[\filterWindows][thisSample], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  200);
				~samples8chGui[\hpfNumbox][thisSample].value_(val);
				~params[thisSample][\hpfFreq] = val;
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\hpfFreq, val)});
			});
		);
		//
		~samples8chGui[\hpfNumbox].add(thisSample ->
			NumberBox(~samples8chGui[\filterWindows][thisSample], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 200, 0.0, 1.0);
				~samples8chGui[\hpfFreq][thisSample].valueAction_(val);
				if(~samples8chSynths[j].isPlaying, {~samples8chSynths[j].set(\hpfFreq, val)});
			});
		);



		~samples8chGui[\startTimeSlider].add(thisSample ->
			Slider(i, Rect(3, 500, 90, 300))
			.value_(0)
			.action_({arg val;

				~params[thisSample][\startPos] = val.value.linlin(0.0, 1.0, 0.0, ~buffers[\samples_8ch][j].numFrames);

				~samples8chGui[\startTimeNumbox][thisSample].value_(val.value.linlin(0, 1, 0, ~buffers[\samples_8ch][j].numFrames/(s.sampleRate)/60));
			});
		);

		StaticText(i, Rect(5, 455, 130, 20)).string = "Start Position";

		~samples8chGui[\startTimeNumbox].add(thisSample ->
			NumberBox(i, Rect(3, 475, 90, 20))
			.value_(0)
			.decimals_(2)
			.action_({arg val;
				~params[thisSample][\startPos] = val.value.linlin(0, (~buffers[\samples_8ch][j].numFrames/(s.sampleRate)/60), 0.0, ~buffers[\samples_8ch][j].numFrames);
				~samples8chGui[\startTimeSlider][thisSample].value_(val.value.linlin(0, (~buffers[\samples_8ch][j].numFrames/(s.sampleRate)/60), 0.0, 1.0));

			});
		);
	};
}.value;












