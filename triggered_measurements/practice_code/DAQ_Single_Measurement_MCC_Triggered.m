%-------------------------------------------------------------------------%
init = true;   % initialize ?
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
% 
% 
%
% Log:
% 11-1-2016 Created program, copied it from single MCC DAQ measurement
%           code. Added the triggers.
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
%%
% MCC has a fixed 12 bits per sample.
% Parameter settings
Settings.Duration = 0.01;                % Duration of sample (seconds)
Settings.Daq_Type = 'mcc';               % Set adapter type
Settings.Sample_Rate = 100000;           % Set sample rate (Hz)


% Settings.Trigger_Type = 'Immediate';    % Set trigger type -> Triggerd immediate when start is executed
Settings.Trigger_Type = 'HwDigital';     % Set trigger type -> Triggerd from hardware (digital channel)

Settings.Trigger_Cond = 'TrigPosEdge';   % Set trigger condition -> Triggered when a positive edge is detected
% Settings.Trigger_Cond = 'TrigNegEdge';   % Set trigger condition -> Triggered when a negative edge is detected -> TTL convention used by stimulus-PC.
% Settings.SamplesPerTrigger = inf;      % number of samples taken

Settings.SamplesPerTrigger = 0;

%%
% Create and setup analog input AI object 


% Create object containing Hardware information
Info_DAQ_present = daqhwinfo(Settings.Daq_Type)


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
set(AI, 'TriggerCondition', Settings.Trigger_Cond);

HW_Info_AI = daqhwinfo(AI);         % AI object hardware info
Prop_Info_AI = propinfo(AI);        % AI object property info (object setup)

% Define input channels MCC DAQ
%hwchannels = [0 1]; % DAQ channel input Sinks
hwchannels = [0]; % DAQ channel input Sinks
% InpFunGen = addchannel(AI,hwchannels,{'diff 0','diff 1'});
InpFunGen = addchannel(AI,hwchannels,'diff 0');

%%
% Execute measurement/acquisition


start(AI);          % Run AI object

% The AI object now waits until it recieves a trigger 

% Test for wait time
%waitTime = Settings.Duration * 1.1 + 0.5;   % set wait time
% tic
% wait(AI, waitTime);
% waitTime
% toc

% Start acquire data
disp('***********************************');
disp('****  Start recording process  ****');
disp('***********************************');

% [data, time] = getdata(AI);

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
% stop(AI);       % Stops (all active processes on) analog input object
% delete(AI);     % Deletes analog input object
% clear AI        % Removes analog input object from workspace