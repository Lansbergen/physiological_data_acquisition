%-------------------------------------------------------------------------%
init = true;   % initialize ?
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
%
% Continuous measurement data plot
%
% Log:
% 6-1-2015   - created program, based on MatLab examples in DAQ toolbox
%            - this program continuously measures and plot the data 
%            - recorded by the ultasound mic.
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

Info_DAQ_present = daqhwinfo('winsound');   % For microphone input using windows interface
AI = analoginput('winsound','0');           % Create AnalogInput object


addchannel(AI,1,'Measuring microphone');                           % Add channel to AI object
DAQInfoAI = daqhwinfo(AI);
PropAI = propinfo(AI);
disp(DAQInfoAI);

disp(PropAI.SampleRate);               % Check for range sample rate
disp(PropAI.BitsPerSample);            % Check for range bits per sample
set(AI, 'SampleRate', 96000);             % Set Sample rate (Hz)
set(AI, 'Bits', 32);                     % Set bits per sample

set(AI, 'TriggerType', 'immediate');
set(AI, 'SamplesPerTrigger', inf);
set(AI, 'TriggerRepeat', 0);

set(AI, 'TimerPeriod', 0.1);
set(AI, 'TimerFcn', @daqtimerplot);
set(AI, {'StartFcn', 'StopFcn', 'TriggerFcn'}, {'', '', ''});  % sets all three parameters to be empty

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