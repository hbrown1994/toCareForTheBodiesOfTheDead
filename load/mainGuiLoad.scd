{
	[\mainOut,  \spatialOutputChannels, \sample2chSlider].do{|i|
		~mainGui[i].value=~params[i];
	};
	~mainGui[\sample2chNumbox].value=~params[\sample2chSlider].ampdb;
}.value;



