%-------------------------------------------------------------------------%
init = true;   % initialize ?
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
%
% Continuous measurement data plot
%
% Log:
% 5-1-2015   - created program, based on MatLab examples in DAQ toolbox
% 
%
%-------------------------------------------------------------------------%
% Initialisation
switch init
    case true
clear all       % Clear all variables in workspace
close all       % Close all current windows with figures (plots)
clc             % Clear Command window
if (~isempty(daqfind)) % finds and stops active data acquisistion-
    stop(daqfind)      % objects and terminates them
end
echo off        % No echoing of commands lines in script/function files
end
%-------------------------------------------------------------------------%

DAQ_Info = daqhwinfo;

Settings.Daq_Type = 'mcc'; 
Info_DAQ_present = daqhwinfo(Settings.Daq_Type);
% create Analog Input object
AI = analoginput(Info_DAQ_present.AdaptorName,'1');     % sets mcc->device 1


hwchannels = [0 1]; % DAQ MCC PCI DAS6025 differential channel-input sinks.
addchannel(AI,hwchannels,{'Diff Channel 0','Diff Channel 1'});

DAQInfoAI = daqhwinfo(AI);
PropAI = propinfo(AI);
disp(DAQInfoAI);

disp(PropAI.SampleRate);              % Check for range sample rate
set(AI, 'SampleRate', 10000);          % Set Sample rate (Hz)



set(AI, 'TriggerType', 'immediate');
set(AI, 'SamplesPerTrigger', inf);
set(AI, 'TriggerRepeat', 0);

set(AI, 'TimerPeriod', 0.01);
set(AI, 'TimerFcn', @daqtimerplot);
set(AI, {'StartFcn', 'StopFcn', 'TriggerFcn'}, {'', '', ''});

% The analog input object is started.  Wait for up to 6 seconds for the
% acquisition to complete
start(AI)
%wait(AI,6);


% *************************************
% *** Stop and delete analog object ***
% *************************************
donotuse = input('Hit Enter to stop');
% Stop acquire data 

stop(AI);
close all;
delete(AI);

disp('*** program terminated ***');