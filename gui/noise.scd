{
	var window, compositeViews=List.new, sampleNames, numCompositeViews=2, names=[\whiteNoise, \pinkNoise];
	var synths = Array.newClear(2);

	~noiseGui = Dictionary.newFrom([
		\filterWindows, Dictionary.new, \filterButtons, Dictionary.new,
		\amp, Dictionary.new, \ampNumbox, Dictionary.new, \trig, Dictionary.new,
		\lpfOn, Dictionary.new, \lpfFreq, Dictionary.new, \lpfNumbox, Dictionary.new, \hpfOn, Dictionary.new, \hpfFreq, Dictionary.new, \hpfNumbox, Dictionary.new,
		\paramButtons, Dictionary.new, \window, nil,
		\routingWindow, Dictionary.new, \routingSliders, Dictionary.new, \routingNumbox, Dictionary.new,
		\ampStepsWindow, Dictionary.new, \ampStepsButton, Dictionary.new,
		\ampStepSliders, Dictionary.new, \ampStepNumbox, Dictionary.new,
		\ampStepsSelector, Dictionary.new
	]);

	window = Window.new("Noise", Rect(0, 600, 100*numCompositeViews, 620)).front;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );
	window.visible = false;
	~noiseGui[\window] = window;

	numCompositeViews.do{|i| compositeViews.add(CompositeView( window.view, 100@720 ).background_( Color.red(val: ([2.0, 1.5]!5).flatten[i], alpha: 1.0) )) };

	compositeViews.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50];
		var thisNoise = names[j];
		f = StaticText(i, Rect(5, 5, 130, 20)).string = thisNoise;
		f.font = Font("Helvetica", 18);

		//outputSlider
		StaticText(i, Rect(35, 120, 100, 20)).string = "Out";
		~noiseGui[\amp].add(thisNoise ->
			Slider(i, Rect(3, 140, 90, 300))
			.value_(1)
			.action_({arg val;
				~params[thisNoise][\amp] = val.value;
				~noiseGui[\ampNumbox][thisNoise].value_(val.value.ampdb);
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\amp, val.value)});
			});
		);

		~noiseGui[\ampNumbox].add(thisNoise ->
			NumberBox(i, Rect(3, 445, 90, 20))
			.value_(0)
			.action_({arg val;
				~noiseGui[\amp][thisNoise].valueAction_(val.value.dbamp);
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\amp, val.value.dbamp)});
			});
		);

		//filters
		~noiseGui[\filterWindows].add(thisNoise -> Window.new("Filters: "++thisNoise.asString, Rect(30, 100, 630, 120)).visible=false);

		~noiseGui[\filterButtons].add(thisNoise -> Button(i, Rect(3, 470, 90, 30))
			.states_([["Filters", Color.black, Color.magenta], ["Close", Color.black, Color.red]])
			.action_({arg val; if(val.value==1, {~noiseGui[\filterWindows][thisNoise].visible=true}, {~noiseGui[\filterWindows][thisNoise].visible=false})});
		);

		~noiseGui[\lpfOn].add(thisNoise ->
			Button(~noiseGui[\filterWindows][thisNoise], Rect(3, 3, 60, 50))
			.states_([["LPF", Color.black, Color.green], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisNoise][\lpfOn] = val.value;
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\lpfOn, val.value)});

			});
		);

		~noiseGui[\hpfOn].add(thisNoise ->
			Button(~noiseGui[\filterWindows][thisNoise], Rect(3, 60, 60, 50))
			.states_([["HPF", Color.black, Color.magenta], ["Off", Color.black, Color.red]])
			.action_({arg val;
				~params[thisNoise][\hpfOn] = val.value;
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\hpfOn, val.value)});
			});
		);
		//
		~noiseGui[\lpfFreq].add(thisNoise ->
			Slider(~noiseGui[\filterWindows][thisNoise], Rect(65, 3, 500, 50))
			.value_(1)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 8000, 20000);
				~noiseGui[\lpfNumbox][thisNoise].value_(val);
				~params[thisNoise][\lpfFreq] = val;
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\lpfFreq, val)});
			});
		);
		//
		~noiseGui[\lpfNumbox].add(thisNoise ->
			NumberBox(~noiseGui[\filterWindows][thisNoise], Rect(570, 3, 50, 50))
			.value_(20000)
			.action_({arg val;
				val = val.value.linlin(8000, 20000, 0.0, 1.0);
				~noiseGui[\lpfFreq][thisNoise].valueAction_(val);
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\lpfFreq, val)});
			});
		);
		//
		~noiseGui[\hpfFreq].add(thisNoise ->
			Slider(~noiseGui[\filterWindows][thisNoise], Rect(65, 60, 500, 50))
			.value_(0)
			.action_({arg val;
				val = val.value.linlin(0.0, 1.0, 20,  200);
				~noiseGui[\hpfNumbox][thisNoise].value_(val);
				~params[thisNoise][\hpfFreq] = val;
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\hpfFreq, val)});
			});
		);
		//
		~noiseGui[\hpfNumbox].add(thisNoise ->
			NumberBox(~noiseGui[\filterWindows][thisNoise], Rect(570, 60, 50, 50))
			.value_(20)
			.action_({arg val;
				val = val.value.linlin(20, 200, 0.0, 1.0);
				~noiseGui[\hpfFreq][thisNoise].valueAction_(val);
				if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(\hpfFreq, val)});
			});
		);

		/*_____________Amp Steps______________________________________________*/
		~noiseGui[\ampStepsWindow].add(thisNoise ->
			Window.new("Routing: "++thisNoise.asString, Rect(30+100, 100, 230, 400)).visible=false
		);

		~noiseGui[\ampStepsButton].add(thisNoise ->Button(i, Rect(3, 560, 90, 50))
			.states_([["Amp Steps", Color.black, Color.white], ["Close", Color.black, Color.grey]])
			.action_({arg view; if(view.value==1,
				{~noiseGui[\ampStepsWindow][thisNoise].visible=true},
				{~noiseGui[\ampStepsWindow][thisNoise].visible=false}
			)});
		);

		4.do{|index|
			~noiseGui[\ampStepSliders].add((thisNoise.asString ++ index).asSymbol ->
				Slider(~noiseGui[\ampStepsWindow][thisNoise], Rect(5+(index*55), 35, 50, 300))
				.value_(~params[\whiteNoise][\ampStep][index])
				.action_({arg val;
					val=val.value;
					~params[thisNoise][\ampStep][index] = val;
					~noiseGui[\ampStepNumbox][(thisNoise.asString ++ index).asSymbol].value=val;
					if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(("ampStep"++index).asSymbol, val)});
				});
			);

			~noiseGui[\ampStepNumbox].add((thisNoise.asString ++ index).asSymbol  ->
				NumberBox(~noiseGui[\ampStepsWindow][thisNoise], Rect(5+(index*55), 350, 50, 30))
				.value_(~params[thisNoise][\ampStep][index])
				.decimals_(3)
				.action_({arg val;
					val=val.value;
					~noiseGui[\ampStepSliders][(thisNoise.asString ++ index).asSymbol].value=val;
				});
			);

			~noiseGui[\ampStepsSelector].add((thisNoise.asString ++ index).asSymbol  ->
				Button(i, Rect([5, 5+45, 5, 5+45][index], [30, 30, 30+45, 30+45][index], 45, 45))
				.states_([["Amp "++index, Color.black, Color.white], ["Off", Color.black, Color.red]])
				.action_({arg val;
					if(val.value==1,
						{

							if(~noiseSynths[(thisNoise.asString++index).asSymbol].isPlaying, {nil}, {
								thisProcess.interpreter.executeFile(~path[\synthTrigger]++thisNoise.asString++index++".scd");
								~noiseSynths[(thisNoise.asString++index).asSymbol].set(\ampStepSel, ~params[thisNoise][\ampStep][index])
							});

						},
						{
							if(~noiseSynths[(thisNoise.asString++index).asSymbol].isPlaying, {~noiseSynths[(thisNoise.asString++index).asSymbol].set(\gate, 0)});
						}
					);
				});
			);
		};

		/*_____________Routing______________________________________________*/
		~noiseGui[\routingWindow].add(thisNoise ->
			Window.new("Routing: "++thisNoise.asString, Rect(30+100, 100, 450, 400)).visible=false
		);

		~noiseGui[\paramButtons].add(thisNoise ->Button(i, Rect(3, 505, 90, 50))
			.states_([["Routing", Color.black, Color.white], ["Close", Color.black, Color.grey]])
			.action_({arg view; if(view.value==1,
				{~noiseGui[\routingWindow][thisNoise].visible=true},
				{~noiseGui[\routingWindow][thisNoise].visible=false}
			)});
		);

		8.do{|index|
			~noiseGui[\routingSliders].add((thisNoise.asString ++ index).asSymbol ->
				Slider(~noiseGui[\routingWindow][thisNoise], Rect(5+(index*55), 35, 50, 300))
				.value_(1)
				.action_({arg val;
					val=val.value;
					~params[thisNoise][\route][index] = val;
					~noiseGui[\routingNumbox][(thisNoise.asString ++ index).asSymbol].value=val;
					if(~noiseSynths[thisNoise].isPlaying, {~noiseSynths[thisNoise].set(("route"++index).asSymbol, val)});
				});
			);

			~noiseGui[\routingNumbox].add((thisNoise.asString ++ index).asSymbol  ->
				NumberBox(~noiseGui[\routingWindow][thisNoise], Rect(5+(index*55), 350, 50, 30))
				.value_(1)
				.action_({arg val;
					val=val.value;
					~noiseGui[\routingSliders][(thisNoise.asString ++ index).asSymbol].value=val;
				});
			);
		};
	};
}.value;

