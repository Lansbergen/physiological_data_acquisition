%-------------------------------------------------------------------------%
init = true;   % initialize ?
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
Settings.Duration = 60;                 % Duration of sample (seconds)
Settings.Itteration = 5;                % number of loop itterations

Settings.Daq_Type = 'winsound';         % Adapter type
Settings.Sample_Rate = 5000;            % Sample rate (Hz)
Settings.Bits = 32;                     % Bits per sample (board dependend)
Settings.Trigger_Type = 'Immediate';    % Trigger
% Settings.SamplesPerTrigger = inf;       % number of samples taken
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

Settings.BoardID = cell2mat(Info_DAQ_present.InstalledBoardIds);
 
disp('*********************************');
disp('*** Hardware info DAQ         ***');
disp('*********************************');

% Create Analog Input Object
AI = analoginput(Info_DAQ_present.AdaptorName,Settings.BoardID);  %NI USB card
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
set(AI, 'Bits', Settings.Bits);
Info_On_AI = propinfo(AI);        % AI object property info

% Define input channels NI DAQ
hwchannels = [0 1]; % DAQ MCC PCI DAS6025 differential channel-input sinks.
hwindex = [1];    % assign channel index to current Object
InpFunGen = addchannel(AI,hwchannels,{'Diff Channel 0','Diff Channel 1'});
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
figure;
plot(time,data);
xlabel('Time (s)');         % Setting up the xlabel
ylabel('Signal (Volts)');   % Setting up the ylabel
title('Data Acquired using Microphone for 10 seconds'); % Setting up the title
grid on; 
 
%%% loop
for i = 1:Settings.Itteration
    [data, time] = getdata(AI);
    
    
end 
   


% *************************************
% *** Stop and delete analog object ***
% *************************************

% Stop acquire data
% stop(AI);
% delete(AI);



