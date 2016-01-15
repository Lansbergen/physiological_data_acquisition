%-------------------------------------------------------------------------%
init = 1;
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
%
% NI 6008 USB DAQ. Data acquisistion program
%
% Log:
% 4-1-2015   - created program, based on National Instruments DAQ
%              writin in legacy interface.
% 5-1-2015   - added overview of parameter settings at begin
%
%-------------------------------------------------------------------------%
% Initialisation
switch init
    case 1
clear all       % Clear all variables in workspace
close all       % Close all current windows with figures (plots)
clc             % Clear Command window
if (~isempty(daqfind)) %finds and stops active data acquisistion objects and terminates them
    stop(daqfind)
end
echo off        % No echoing of commands lines in script/function files 
end
%-------------------------------------------------------------------------%


% Parameter settings
daqtype = 'winsound';
Sample_Rate = 5000;




% Create object containing Hardware information
Info_DAQ_present = daqhwinfo(daqtype);

disp('*********************************');
disp('*** Installed DAQ Board Names ***');
disp('*********************************');
disp(Info_DAQ_present.BoardNames);
disp('*** Installed Board IDs (the same order as DAQ Board names) ->');
disp(Info_DAQ_present.InstalledBoardIds);

% 
% disp('*********************************');
% disp('*** Hardware info DAQ         ***');
% disp('*********************************');
% 
% % Create Analog Input Object
% AI = analoginput('nidaq','Dev1');  %NI USB card
% disp('*** Hardware info NI ***');
% disp(daqhwinfo(AI));
% 
% OverallPropNI = propinfo(AI);
% disp('SampleRate Properties NI ->');
% disp(OverallPropNI.SampleRate);
% 
% 
% 
% % Define input channels NI DAQ
% hwchannels = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]; % DAQ channel input Sinks
% hwindex = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];    % assign channel index to current Object
% InpFunGen = addchannel(AI,hwchannels,hwindex,'Input Function Generator');
% 
% % Setup Analog Input Object NI
% AI.SampleRate = 5000;    % sets sample rate
% AI.SamplesPerTrigger = 5000; % sets amount of samples when triggered
% AI.TriggerType = 'Immediate';
% 
% 
% % Start acquire data
% start(AI);
% [d,t] = getdata(AI);
% 
% 
% plot(t,d);
% zoom on;
% 
% 
% % *************************************
% % *** Stop and delete analog object ***
% % *************************************
% 
% % Stop acquire data
% stop(AI);
% delete(AI);



