{
	var  window, comp=List.new, fxNames = ~fxNames;

	var fxParams = Dictionary.newFrom([
		\violaGrains, [
			\hpfFreq, \lpfFreq,
			\noiseGateThresh,
			\recBufSize,
			\rateLow, \rateHigh,
			\grainSizeLow, \grainSizeHigh,
			\dustFreq,
			\stutterProbTrigRate, \stutterProb,
			\stutterFreqLow, \stutterFreqHigh,
			\pointerDev, \pointerRandMax, \minPointerDelay, \pointerDelay

		],
		\freeze, [\hpfFreq, \lpfFreq, \route0, \route1],
		\freezeFade, [\hpfFreq, \lpfFreq, \atkLow, \atkHigh, \relLow, \relHigh, \route0, \route1],
	]);

	var fxParamsMin = Dictionary.newFrom([
		\violaGrains, [
			20, 4000, //\hpf, \lpf,
			0, //\noiseGateThresh
			1, //\recBufSize
			0.1, 1, //\rateLow, \rateHigh
			0.001, 0.1, //\grainSizeLow, \grainSizeHigh
			0.1, //\dustFreq
			0.01, 0.0, //\stutterProbTrigRate, \stutterProb,
			0.5, 10, //\stutterProbTrigRate, \stutterProb
			0, 0.5, 0.01, 0.1 //\pointerDev, \pointerRandMax, \minPointerDelay, \pointerDelay

		],
		\freeze, [20, 4000],
		\freezeFade, [20, 4000, 0.005, 0.005, 0.005, 0.005],
	]);

	var fxParamsMax = Dictionary.newFrom([
		\violaGrains, [
			200, 20000, //\hpf, \lpf,
			1, //\noiseGateThresh
			8,  //\recBufSize
			1, 10, //\rateLow, \rateHigh
			0.1, 0.4, //\grainSizeLow, \grainSizeHigh
			70, //\dustFreq
			20,  1, //\stutterProbTrigRate, \stutterProb,
			20, 100, //\stutterFreqLow, \stutterFreqHigh,
			1, 4, 1, 4 //\pointerDev, \pointerRandMax, \minPointerDelay, \pointerDelay
		],
		\freeze, [200, 20000],
		\freezeFade, [200, 20000, 4.0, 8.0, 4.0, 8.0],
	]);

	~fxGui = Dictionary.newFrom([
		\fxNames, ~fxNamesString, \onOff, Dictionary.new, \receivesOpen, Dictionary.new, \params, Dictionary.new, \amp, Dictionary.new, \ampNumbox,Dictionary.new,
		\receiveWindows, Dictionary.new,
		\receiveSlidersviolaGrains, Dictionary.new, \receiveNumboxviolaGrains, Dictionary.new,
		\receiveSlidersfreeze, Dictionary.new, \receiveNumboxfreeze, Dictionary.new,
		\receiveSlidersfreezeFade, Dictionary.new, \receiveNumboxfreezeFade, Dictionary.new,
		\paramWindows, Dictionary.new,
		\paramSlidersviolaGrains, Dictionary.new, \paramNumboxviolaGrains, Dictionary.new,
		\paramSlidersfreeze, Dictionary.new, \paramNumboxfreeze, Dictionary.new,
		\paramSlidersfreezeFade, Dictionary.new, \paramNumboxfreezeFade, Dictionary.new,
		\route0Buttonsfreeze, Dictionary.new, \route0ButtonsfreezeFade, Dictionary.new,
		\route1Buttonsfreeze, Dictionary.new, \route1ButtonsfreezeFade, Dictionary.new,
		\mainWindow, nil
	]);


	window = Window.new("FXs", Rect(0, 600, 160.0*(~fxNamesString.size), 500));
	~fxGui[\mainWindow] = window;
	~fxGui[\mainWindow].visible = false;
	window.view.decorator = FlowLayout( window.view.bounds, 0@0, 0@0 );

	(~fxNamesString.size).do{|i| comp.add(CompositeView( window.view, 160@500 ).background_( [Color.yellow(1.0), Color.cyan(1.0), Color.yellow(1.0), Color.cyan(1.0), Color.magenta][i] )) };


	comp.do{|i, j|
		var f, inputText=[60, 80, 65, 55, 50], fxName;
		f = StaticText(i, Rect(5, 5, 100, 20)).string = ~fxGui[\fxNames][j];
		f.font = Font("Helvetica", 18);
		fxName = fxNames[j];

		~fxGui[\onOff].add(fxName -> Button(i, Rect(90, 30, 60, 50))
			.states_([["Off", Color.black, Color.red], ["On", Color.black, Color.green]])
			.action_({arg view; if(view.value==1,
				{
					if(~fxSynths[fxName].isPlaying, {nil}, {thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd")});
				},
				{
					if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(\gate, 0)});
				}
			)});
		);

		if(fxName!=\violaGrains, {
			2.do{|trigIndex|
				Button(i, Rect(90, 90+(trigIndex*40), 60, 40))
				.states_([[("Trig"++trigIndex).asString, Color.black, Color.green]])
				.action_({arg view;
					~params[fxName][\routeSel]=trigIndex;
					if(~fxSynths[fxName].isPlaying,
						{
							~fxSynths[fxName].set(
								\t_trig, 1,
								\route0, ~params[fxName][("route"++trigIndex).asSymbol][0],
								\route1, ~params[fxName][("route"++trigIndex).asSymbol][1],
								\route2, ~params[fxName][("route"++trigIndex).asSymbol][2],
								\route3, ~params[fxName][("route"++trigIndex).asSymbol][3],
								\route4, ~params[fxName][("route"++trigIndex).asSymbol][4],
								\route5, ~params[fxName][("route"++trigIndex).asSymbol][5],
								\route6, ~params[fxName][("route"++trigIndex).asSymbol][6],
								\route7, ~params[fxName][("route"++trigIndex).asSymbol][7]
							);

						},
						{
							thisProcess.interpreter.executeFile(~path[\synthTrigger]++fxName.asString++".scd");
							~fxGui[\onOff][fxName].value = 1;
					});
				});
			};
		});

		//outputSlider
		~fxGui[\amp].add(fxName ->
			Slider(i, Rect(10, 170, 90, 300))
			.value_(0)
			.action_({arg val;
				val = val.value;
				~params[fxName][\amp] = val;
				if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(\amp, val)});
				~fxGui[\ampNumbox][fxName].value_(val.ampdb);
			});
		);

		~fxGui[\ampNumbox].add(fxName ->
			NumberBox(i, Rect(10, 470, 90, 20))
			.value_(-inf)
			.action_({arg val; ~fxGui[\amp][fxName].valueAction_(val.value.dbamp)});
		);


		/*_____________Receives______________________________________________*/
		~fxGui[\receiveWindows].add(fxName ->
			Window.new("Receives: "++fxName.asString, Rect(30+100, 100, 630, 270)).visible=false
		);

		~fxGui[\receivesOpen].add(fxName -> Button(i, Rect(10, 90, 60, 50))
			.states_([["Receives", Color.black, Color.magenta], ["Close", Color.black, Color.grey]])
			.action_({arg view; if(view.value==1,
				{
					~fxGui[\receiveWindows][fxName].visible=true;
				},
				{
					~fxGui[\receiveWindows][fxName].visible=false;
				}
			)});
		);


		~instrumentNames.do{|name, index|
			var paramName = [\receive0, \receive1, \receive2, \receive3, \receive4][index];
			var thisFxName = fxName.asString;
			~fxGui[("receiveSliders"++thisFxName).asSymbol].add(name.toLower.asSymbol ->
				Slider(~fxGui[\receiveWindows][fxName], Rect(53, 3+(53*index), 500, 50))
				.value_([1, 1, 1, 1, 0][index])
				.action_({arg val;
					val = val.value;
					~params[fxName][paramName] = val;
					if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(paramName, val)});
					~fxGui[("receiveNumbox"++thisFxName).asSymbol][name.toLower.asSymbol].value = val.ampdb;
				});
			);

			StaticText(~fxGui[\receiveWindows][fxName], Rect(5, 18+(53*index), 35, 20)).string = name;

			~fxGui[("receiveNumbox"++thisFxName).asSymbol].add(name.toLower.asSymbol  ->
				NumberBox(~fxGui[\receiveWindows][fxName], Rect(570, 3+(53*index), 50, 50))
				.value_([0, 0, 0, 0, -inf][index])
				.action_({arg val;
					~fxGui[("receiveSliders"++thisFxName).asSymbol][name.toLower.asSymbol].valueAction=val.value.dbamp;
				});
			);
		};


		/*_____________Params______________________________________________*/
		~fxGui[\paramWindows].add(fxName ->
			Window.new("Params: "++fxName.asString, Rect(30+100, 100, 710, [1020, 320, 530][j])).visible=false
		);

		~fxGui[\params].add(fxName ->Button(i, Rect(10, 30, 60, 50))
			.states_([["Params", Color.black, Color.white], ["Close", Color.black, Color.grey]])
			.action_({arg view; if(view.value==1,
				{~fxGui[\paramWindows][fxName].visible=true},
				{~fxGui[\paramWindows][fxName].visible=false;}
			)});
		);

		fxParams[fxName].do{|paramName, index|
			var thisFxName = fxName.asString;

			if(paramName==\route0 || {paramName==\route1},
				{
					StaticText(~fxGui[\paramWindows][fxName],
						Rect(
							195.5+140,
							(53*if(fxName==\freeze, {2.6*if(paramName==\route1, {1.7}, {1})}, {6.6*if(paramName==\route1, {1.25}, {1})})),
							100,
							20)).string = paramName.asString;

					~params[fxName][paramName].do{|item, routeIndex|

						~fxGui[((paramName.asString)++"Buttons"++thisFxName).asSymbol].add(routeIndex.asSymbol ->
							Button(~fxGui[\paramWindows][fxName],
								Rect(
									(55*routeIndex)+140,
									53*if(fxName==\freeze, {3*if(paramName==\route1, {1.6}, {1})}, {7*if(paramName==\route1, {1.25}, {1})}),
									50,
									50)
							)
							.states_([[routeIndex, Color.black, Color.grey], [routeIndex, Color.black, Color.red]])
							.action_({arg val;
								if(val.value==1,
									{
										~params[fxName][paramName][routeIndex]=1;
										if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(("route"++routeIndex).asSymbol, 1)});
									},
									{
										~params[fxName][paramName][routeIndex]=0;
										if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(("route"++routeIndex).asSymbol, 0)});
									}
								);
							})
							.value = item;
						);
					};
				},
				{
					StaticText(~fxGui[\paramWindows][fxName], Rect(5, 18+([47, 53, 53][j]*index), 120, 20)).string = paramName.asString;

					~fxGui[("paramSliders"++thisFxName).asSymbol].add(paramName ->
						Slider(~fxGui[\paramWindows][fxName], Rect([125, 35, 55][j], 3+([47, 53, 53][j]*index), [500, 610, 595][j], [45, 50, 50][j]))
						.value_(~params[fxName][paramName].linlin(fxParamsMin[fxName][index], fxParamsMax[fxName][index], 0, 1))
						.action_({arg val;
							val = val.value.linlin(0, 1, fxParamsMin[fxName][index], fxParamsMax[fxName][index]);
							~params[fxName][paramName]=val;
							if(~fxSynths[fxName].isPlaying, {~fxSynths[fxName].set(paramName, val)});
							~fxGui[("paramNumbox"++thisFxName).asSymbol][paramName].value=val;
						});
					);

					~fxGui[("paramNumbox"++thisFxName).asSymbol].add(paramName  ->
						NumberBox(~fxGui[\paramWindows][fxName], Rect(655, 3+([47, 53, 53][j]*index), [70, 50, 50][j], [45, 50, 45][j]))
						.decimals_(3)
						.value_(~params[fxName][paramName])
						.action_({arg val;
							~fxGui[("paramSliders"++thisFxName).asSymbol][paramName].valueAction=val.value.linlin(fxParamsMin[fxName][index], fxParamsMax[fxName][index], 0, 1);
						});
					);

				}
			);
		};
	};
}.value;

