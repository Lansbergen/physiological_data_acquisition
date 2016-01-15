%-------------------------------------------------------------------------%
% Initialisation
clear all       % Clear all variables in workspace
close all       % Close all current windows with figures (plots)
clc             % Clear Command window
echo off        % No echoing of commands lines in script/function files 
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2015-2016.
%
% Test DAQ hardware and communication possibilities.
%
% Log:
% 11-12-2015 - created program, including MCC DAQ
%              based on legacy interface
% 4-1-2016   - added National Instruments DAQ
%
%-------------------------------------------------------------------------%


if (~isempty(daqfind)) %finds and stops active data acquisistion objects and terminates them
    stop(daqfind)
end


% Create object containing Hardware information
Gen_Info_DAQ = daqhwinfo;
Info_DAQ_MCC_present = daqhwinfo('mcc');
Info_DAQ_NI_present = daqhwinfo('nidaq');
Info_DAQ_WIN_present = daqhwinfo('winsound');

% Give information about installed DAQ

% Info_DAQ_present
Gen_Info_DAQ.InstalledAdaptors;

% DAQ type and ID



disp('*********************************');
disp('*** Installed DAQ Board Names ***');
disp('*********************************');
% MCC
disp('*** MCC ->');
disp(Info_DAQ_MCC_present.BoardNames);
disp('*** Installed Board IDs (the same order as DAQ Board names) ->');
disp(Info_DAQ_MCC_present.InstalledBoardIds);
% NI
disp('*** NI ->');
disp(Info_DAQ_NI_present.BoardNames);
disp('*** Installed Board IDs (the same order as DAQ Board names) ->');
disp(Info_DAQ_NI_present.InstalledBoardIds);
% Soundcard
disp('*** Winsound ->');
disp(Info_DAQ_WIN_present.BoardNames);
disp('*** Installed Board IDs (the same order as DAQ Board names) ->');
disp(Info_DAQ_WIN_present.InstalledBoardIds);



disp('*********************************');
disp('*** Hardware info DAQ         ***');
disp('*********************************');
% Creates an Analog input object containing board ID 1 from MCC
AI_MCC = analoginput('mcc','1');  %MCC PCI card
% Creates an Analog input object containing board ID Dev1 from NI
AI_NI = analoginput('nidaq','Dev1');  %NI USB card
% Creates an Analog input object containing board ID 1 from WIN
%AI_WIN = analoginput('winsound','1');  %WIN USB card

disp('*** Hardware info MCC ***');
disp(daqhwinfo(AI_MCC));
disp('*** Hardware info NI ***');
disp(daqhwinfo(AI_NI));

OverallPropMCC = propinfo(AI_MCC);
OverallPropNI = propinfo(AI_NI);

disp('SampleRate Properties NI ->');
disp(OverallPropNI.SampleRate);
disp('SampleRate Properties MCC ->');
disp(OverallPropMCC.SampleRate);

% Setup Analog Input Object NI






% Define input channels NI DAQ
hwchannels = [2 3]; % DAQ channel input Sinks
hwindex = [1 2];    % assign channel index to current Object
InpFunGen = addchannel(AI_NI,hwchannels,hwindex,'Input Function Generator');

 
testsample = getsample(AI_NI);





% % It seems the USB card DAQ is not supported in Matlab, although I can see
% % it in the information about the DAQ
% % AI0 = analoginput('mcc',0);  %USB card (Starr)
% 
% 
% 
% % create channels input
% % Define single channels, which you can adress individual
% ai0 = addchannel(AI,0,'Boven');
% ai1 = addchannel(AI,1,'Rechts');
% ai2 = addchannel(AI,2,'Onder');
% ai3 = addchannel(AI,3,'Links');
% 
% 
% % Define a set or a pair of channels, in this case 4 (e.g. differentail
% % amp output)
% % hwchannels = [4 5 6 7];
% % hwindex = [5 6 7 8];
% % aiTest = addchannel(AI,hwchannels,hwindex,'TestName');
% 
% 
% % create channels output
% % Define single channels, which you can adress individual
% ao0 = addchannel(AO,0,'Boven');
% ao1 = addchannel(AO,1,'Rechts');
% 
% 
% ao0_value = [5.25 5.75];   % set output 
% 
% %aiTest  % output specific channel to screen for info
% 
% AI    % output object to screen for info
% 
% 
% putsample(AO,ao0_value);
% 
% AO
% 
% testsample = getsample(AI);
% testsample






% *********************************
% *** Delete all analog objects ***
% *********************************

%delete(AI_MCC);
%delete(AI_NI);
%delete(AI_WIN);


