{
	var window, compositeViews=List.new, sampleNames, numCompositeViews;


	~samples2chGui = Dictionary.newFrom([
		\filterWindows, Dictionary.new, \filterButtons, Dictionary.new,
		\amp, Dictionary.new, \ampNumbox, Dictionary.new, \trig, Dictionary.new,
		\lpfOn, Dictionary.new, \lpfFreq, Dictionary.new, \lpfNumbox, Dictionary.new, \hpfOn, Dictionary.new, \hpfFreq, Dictionary.new, \hpfNumbox, Dictionary.new,
		\routeButtons, Dictionary.new, \window, nil

	]);

	numCompositeViews=~buffersNames[\samples_2ch].size;

	window = Window.new("Samples 2ch", Rect(0, 600, 100*~buffersNames[\samples_2ch].size+1, 640)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );
	window.visible = false;
	~samples2chGui[\window] = window;

	numCompositeViews.do{|i| compositeViews.add(CompositeView( window.view, 100@640 ).background_( Color.green(val: ([0.6, 0.8]!5).flatten[i], alpha: 1.0) )) };

	compositeViews.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisSample = ~buffersNames[\samples_2ch][j].asSymbol;
		f = StaticText(i, Rect(5, 5, 130, 20)).string = thisSample;
		f.font = Font("Helvetica", 18);

		if(thisSample=='3_plops', {
			~samples2chGui[\trig].add(thisSample ->
				Button(i, Rect(5, 30, 90, 50))
				.states_([["Play", Color.black, Color.grey], ["Off", Color.black, Color.red]])
				.action_({arg val;
					if(val.value==1, {
						if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\t_trig, 1)}, {
							~samples2chSynths[j] = Synth(\oneShotRel, [\gate, 1,
								\buf, ~buffers[\samples_2ch][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
								\groupAmp, ~params[thisSample][\groupAmp],
								\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
								\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
								\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
							], ~nodes[\fixed]).register;
						});
					},
					{
						if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\gate, 0)});
					});
				});
			);
		},
		{
			~samples2chGui[\trig].add(thisSample ->
				Button(i, Rect(5, 30, 90, 50))
				.states_([["Play", Color.black, Color.grey], ["Off", Color.black, Color.red]])
				.mouseDownAction_({
					if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\t_trig, 1)}, {
						~samples2chSynths[j] = Synth(\oneShotRel, [\gate, 1,
							\buf, ~buffers[\samples_2ch][j],  \amp, ~params[thisSample][\amp], \out, ~params[thisSample][\out], \masterAmp, ~masterAmp,
							\groupAmp, ~params[thisSample][\groupAmp],
							\lpfOn, ~params[thisSample][\lpfOn], \hpfOn, ~params[thisSample][\hpfOn], \lpfFreq, ~params[thisSample][\lpfFreq], \hpfFreq, ~params[thisSample][\hpfFreq],
							\route0, ~params[thisSample][\route0], \route1, ~params[thisSample][\route1], \route2, ~params[thisSample][\route2], \route3, ~params[thisSample][\route3],
							\route4, ~params[thisSample][\route4], \route5, ~params[thisSample][\route5], \route6, ~params[thisSample][\route6], \route7, ~params[thisSample][\route7]
						], ~nodes[\fixed]).register;
						{~samples2chGui[\trig][thisSample].value = 1}.defer;
					});
				})
				.mouseUpAction_({arg val;
					if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\gate, 0)});
					{~samples2chGui[\trig][thisSample].value = 1}.defer;
				});
			);
		}
		);

		//outputSlider
		StaticText(i, Rect(35, 80, 100, 20)).string = "Out";
		~samples2chGui[\amp].add(thisSample ->
			Slider(i, Rect(3, 100, 90, 300))
			.value_(1)
			.action_({arg val;
				~params[thisSample][\amp] = val.value;
				~samples2chGui[\ampNumbox][thisSample].value_(val.value.ampdb);
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\amp, val.value)});
			});
		);

		//~samples2chGui[\ampNumbox]
		~samples2chGui[\ampNumbox].add(thisSample ->
			NumberBox(i, Rect(3, 400, 90, 20))
			.value_(0)
			.action_({arg val;
				~samples2chGui[\amp][thisSample].valueAction_(val.value.dbamp);
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\amp, val.value.dbamp)});
			});
		);

		//filters
		~samples2chGui[\filterWindows].add(thisSample -> Window.new("Filters: "++thisSample.asString, Rect(30, 100, 630, 120)).visible=false);

		~samples2chGui[\filterButtons].add(thisSample -> Button(i, Rect(3, 423, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg val; if(val.value==1, {~samples2chGui[\filterWindows][thisSample].visible=true}, {~samples2chGui[\filterWindows][thisSample].visible=false})});
		);


		//filtersOnOff
		~samples2chGui[\lpfOn].add(thisSample ->
			Button(~samples2chGui[\filterWindows][thisSample], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisSample][\lpfOn] = val.value;
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\lpfOn, val.value)});

			});
		);
		//
		~samples2chGui[\hpfOn].add(thisSample ->
			Button(~samples2chGui[\filterWindows][thisSample], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisSample][\hpfOn] = val.value;
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\hpfOn, val.value)});
			});
		);
		//
		~samples2chGui[\lpfFreq].add(thisSample ->
			Slider(~samples2chGui[\filterWindows][thisSample], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 8000, 20000);
				~samples2chGui[\lpfNumbox][thisSample].value_(val);
				~params[thisSample][\lpfFreq] = val;
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\lpfFreq, val)});
			});
		);
		//
		~samples2chGui[\lpfNumbox].add(thisSample ->
			NumberBox(~samples2chGui[\filterWindows][thisSample], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(8000, 20000, 0.0, 1.0);
				~samples2chGui[\lpfFreq][thisSample].valueAction_(val);
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\lpfFreq, val)});
			});
		);
		//
		~samples2chGui[\hpfFreq].add(thisSample ->
			Slider(~samples2chGui[\filterWindows][thisSample], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  200);
				~samples2chGui[\hpfNumbox][thisSample].value_(val);
				~params[thisSample][\hpfFreq] = val;
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\hpfFreq, val)});
			});
		);
		//
		~samples2chGui[\hpfNumbox].add(thisSample ->
			NumberBox(~samples2chGui[\filterWindows][thisSample], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 200, 0.0, 1.0);
				~samples2chGui[\hpfFreq][thisSample].valueAction_(val);
				if(~samples2chSynths[j].isPlaying, {~samples2chSynths[j].set(\hpfFreq, val)});
			});
		);
		//routing
		{
			var routeDict = Dictionary.new;
			//routing
			8.do{|routeNum|
				var buttonName = ("route"++routeNum).asSymbol;
				var buttonSize=45;
				var buttonYStart = 455;

				~samples2chGui[\routeButtons].add(thisSample ->
					routeDict.add(buttonName ->
						Button(i, Rect([3, buttonSize+5][routeNum%2], [buttonYStart!2, (buttonYStart+(buttonSize*1))!2, (buttonYStart+(buttonSize*2))!2, (buttonYStart+(buttonSize*3))!2].flatten[routeNum], buttonSize, buttonSize))
						.states_([[routeNum.asString, Color.black, Color.grey], [routeNum.asString, Color.black, Color.red]])
						.action_({arg val;
							~params[thisSample][buttonName]=val.value;
						})
						.value = (~params[thisSample][("route"++routeNum).asSymbol]);
					);
				);
			};
		}.value;
	};
}.value;

