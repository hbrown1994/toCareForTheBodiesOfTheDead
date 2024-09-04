{
	var controlsGui;        //a Gui method in which all the above methods are executed.

	~controlsGui = Dictionary.new;

	controlsGui = Window.new("Controls", Rect(0, 260, 210, 210)).front;  //Make window

	Button(controlsGui, Rect(5,5,100,100))
	.states_([["FXs", Color.black, Color.red], ["Close FXs", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~fxGui[\mainWindow].visible = true;
			},
			{
				~fxGui[\mainWindow].visible = false;
			}
	)});

	Button(controlsGui, Rect(105,5,100,100))
	.states_([["Noise", Color.black, Color.red(val: 1.5)], ["Close Noise", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~noiseGui[\window].visible = true;
			},
			{
				~noiseGui[\window].visible = false;
			}
	)});

	Button(controlsGui, Rect(5,105,100,100))
	.states_([["Samples 2ch", Color.black, Color.green], ["Close Samples 2ch", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~samples2chGui[\window].visible = true;
			},
			{
				~samples2chGui[\window].visible = false;
			}
	)});

	Button(controlsGui, Rect(105,105,100,100))
	.states_([["Samples 8ch", Color.black, Color.yellow], ["Close Samples 8ch", Color.black, Color.white]])
	.action_({arg view;
		if(view.value==1,
			{
				~samples8chGui[\window].visible = true;
			},
			{
				~samples8chGui[\window].visible = false;
			}
	)});


}.value;



