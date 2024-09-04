(
/*______________________________________________ 1. Server Configuration / Controller Init _________________________*/
s = Server.local; //Define server
s.options.blockSize = 64;
s.newBusAllocators;
s.latency = 0.05;
s.options.numOutputBusChannels = 8; //8 inputs and outputs
s.options.numInputBusChannels = 8;
s.options.memSize = 2.pow(21);
s.options.numAudioBusChannels = 100000;
s.options.maxNodes = 11000;
s.options.recHeaderFormat = "wav";
s.options.numWireBufs = 128 * 128;
Buffer.freeAll;

//Clean up server just in case something is running
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
//

/*______________________________________________ 2. Global Variables/Init Singeltons ______________________________________________*/
~parentPath = PathName(thisProcess.nowExecutingPath).parentPath;
~path = Dictionary.newFrom(
	[
		\buffers, ~parentPath++"buffers/",
		\init, ~parentPath++"init/",
		\synthdefs, ~parentPath++"synthdefs/",
		\gui, ~parentPath++"gui/",
		\run, ~parentPath++"run/",
		\reset, ~parentPath++"reset/",
		\save, ~parentPath++"save/",
		\load, ~parentPath++"load/",
		\kill, ~parentPath++"kill/",
		\startup, ~parentPath++"startup/",
		\makeGui, ~parentPath++"makeGui/",
		\synthTrigger, ~parentPath++"synthTrigger/",
		\presets, ~parentPath++"presets/"
	]
);

~buffers = Dictionary.new;
~buffersNames = Dictionary.new;
~nodes = Dictionary.new;

~inputSynths = List.new;
~sendSynths = List.new;
~forestSynths = Dictionary.new;
~fxSynths = Dictionary.new;

~instrumentNames = ["Viola", "Cello", "Bass"];
~fxNames = [\violaGrains, \freeze, \freezeFade];
~fxNamesString = ["violaGrains", "freeze", "freezeFade"];

~masterAmp=0;
~nanoPadMIDIChan=3;
~nanoKontrolMIDIChan=2;
~numChannels=8;

/*______________________________________________ 3. Server. Cleanup ______________________________________________*/
//Cleanup server on command period/Server quit
~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

ServerQuit.add(~cleanup);

~cmdPeriodCleanup = {

};

CmdPeriod.add(~cmdPeriodCleanup);

/*______________________________________________ 4. Executing on Server Boot ______________________________________________*/
s.waitForBoot({ //Wait to boot server once contained functions have been evaluated.
	var rout;

	thisProcess.interpreter.executeFile(~path[\init]++"make_busses.scd");
	s.sync;

	~inputSynthNames = Array.fill(~instrumentNames.size, {arg i; ("inputSynth"++i).asSymbol});
	~sendSynthNames = Array.fill(~instrumentNames.size, {arg i; ("sendSynth"++i).asSymbol});
	thisProcess.interpreter.executeFile(~path[\startup]++"make_buffers.scd");

	s.sync;

	thisProcess.interpreter.executeFile(~path[\startup]++"init_params.scd");

	s.sync;

	PathName(~path[\synthdefs]).entries.do{|i|
		(i.entries).do{|j| thisProcess.interpreter.executeFile(j.fullPath)}
	};

	s.sync;

	PathName(~path[\gui]).entries.do{|i|
		thisProcess.interpreter.executeFile(i.fullPath)
	};

	s.sync;

	/*MAKE GUI_____________*/
	PathName(~path[\makeGui]).entries.do{|i|
		thisProcess.interpreter.executeFile(i.fullPath)
	};

	s.sync;
	s.freeAll;
	s.sync;
	s.meter;
	s.plotTree;
	"done".postln;
});
);