["fxGuiLoad.scd", "inputGuiLoad.scd", "mainGuiLoad.scd", "noiseGuiLoad.scd",  "samples2chGuiLoad.scd", "samples8chGuiLoad.scd"].do{|i|
	thisProcess.interpreter.executeFile(~path[\load]++i);
};
