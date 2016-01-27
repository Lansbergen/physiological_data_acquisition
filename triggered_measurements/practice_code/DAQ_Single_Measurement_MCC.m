%-------------------------------------------------------------------------%
init = false;   % initialize ?
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
%
% 
%
% Log:
% 
%              
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



% Parameter settings
Settings.Duration = 0.05;                 % Duration of sample (seconds)
Settings.Daq_Type = 'mcc';              % Set adapter type
Settings.Sample_Rate = 10000;            % Set sample rate (Hz)
% MCC has a fixed 12 bits per sample.
% Settings.Bits = 32;                     % Set bits per sample
Settings.Trigger_Type = 'Immediate';    % Set trigger type
% Settings.SamplesPerTrigger = inf;     % number of samples taken
Settings.SamplesPerTrigger = 0;
% To continuously acquire data set the SamplesPerTrigger property to Inf. 
% Use the stop command to stop the device.

% Create object containing Hardware information
Info_DAQ_present = daqhwinfo(Settings.Daq_Type)

disp('*********************************');
disp('*** Installed DAQ Board Names ***');
disp('*********************************');
disp(Info_DAQ_present.BoardNames);
disp('*** Installed Board IDs (the same order as DAQ Board names) ->');
disp(Info_DAQ_present.InstalledBoardIds);


 
disp('*********************************');
disp('*** Hardware info DAQ         ***');
disp('*********************************');

% Create Analog Input Object
AI = analoginput(Info_DAQ_present.AdaptorName,'1');  %MCC PCI card
disp(daqhwinfo(AI));

% Setup Analog Input Object
requiredSamples = floor(Settings.Sample_Rate * Settings.Duration);
if Settings.SamplesPerTrigger == false
    set(AI, 'SamplesPerTrigger', requiredSamples);
else
    set(AI, 'SamplesPerTrigger', Settings.SamplesPerTrigger);
end
set(AI, 'SampleRate', Settings.Sample_Rate);
set(AI, 'TriggerType', Settings.Trigger_Type);
% set(AI, 'Bits', Settings.Bits);

HW_Info_AI = daqhwinfo(AI);         % AI object hardware info
Prop_Info_AI = propinfo(AI);        % AI object property info (object setup)

% Define input channels MCC DAQ
hwchannels = [0 1]; % DAQ channel input Sinks
% hwchannels = [0]; % DAQ channel input Sinks
InpFunGen = addchannel(AI,hwchannels,{'diff 0','diff 1'});
% InpFunGen = addchannel(AI,hwchannels,'diff 0');

disp('*********************************');
disp('***        Channel info       ***');
disp('*********************************');
disp(InpFunGen);    % Output AI object info

start(AI);          % Run AI object


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Setup continuous acquisistion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The best practice is to use the wait command before bringing the data in 
% to MATLAB®. Set the duration of the wait command to be more than the 
% actual duration of the acquisition. This ensures that the object has 
% sufficient time to acquire the data even with system overhead with object 
% setup and triggering. The recommended wait time is 110% of the duration 
% +0.5 seconds. The wait function returns to MATLAB as soon as the
% acquisition completes and does not pause execution for the whole waitTime.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test for wait time
waitTime = Settings.Duration * 1.1 + 0.5;   % set wait time
% tic
% wait(AI, waitTime);
% waitTime
% toc

% Start acquire data
disp('***********************************');
disp('****  Start recording process  ****');
disp('***********************************');

[data, time] = getdata(AI);

disp('');disp('');
disp('***********************************');
disp('****   End recording process   ****');
disp('***********************************');


% Plot data
% figure;
% plot(time,data);
% xlabel('Time (s)');         % Setting up the xlabel
% ylabel('Signal (Volts)');   % Setting up the ylabel
% title('Data Acquired'); % Setting up the title
% legend('diff 0','diff 1');
% grid on; 
 


% *************************************
% *** Stop and delete analog object ***
% *************************************
% Stop acquire data
% stop(AI);
% delete(AI);

save('c:\temp\test','data','time')
% clear data time
% load('c:\temp\test','data','time')
