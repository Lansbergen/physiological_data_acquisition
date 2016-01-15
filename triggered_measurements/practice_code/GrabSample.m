function [DAQ, Prop_Info_AI, Chan_Info_AI] = GrabSample(Settings)
%Grabs sample from MCC PCI DAS-6025 DAQ
%   This function is explicitly writen for MCC PCI DAS-6025 DAQ. 
%   The function returns 'DAQ' which containes both data and time information. 
%   The function also returns 'Prop_Info_AI' which contains used
%   aqcuisition parameters.
%   The function takes the struct 'Settings' as input, mainly to setup the 
%   analog input object necessary for data aqcuisition.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create analog input object %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AI = analoginput('mcc','1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Setup Analog Input Object %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate required samples for aqcuisition
requiredSamples = floor(Settings.Sample_Rate * Settings.Duration);

% number of samples taken after trigger
set(AI, 'SamplesPerTrigger', requiredSamples);

% sets sample rate
set(AI, 'SampleRate', Settings.Sample_Rate);

% sets trigger type
set(AI, 'TriggerType', Settings.Trigger_Type);

% sets trigger condition. (eg triggered when a positive edge is detected)
% only if TriggerType == 'HwDigital'
if Settings.Trigger_Type == 'HwDigital'
    set(AI, 'TriggerCondition', Settings.Trigger_Cond);
end

% AI object property info (object setup)
Prop_Info_AI = propinfo(AI); 


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Channel Selection %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

Chan_Info_AI = addchannel(AI, Settings.hwchannels);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data Aqcuisition %%%
%%%%%%%%%%%%%%%%%%%%%%%%

% start aqcuisition, either immediate or set by a trigger
start(AI);
DAQ.waitTime = Settings.Duration * 1.1 + 0.5;   % set wait time
wait(AI, DAQ.waitTime);

% grab samples
[DAQ.data, DAQ.time] = getdata(AI);

% Stop acquire data
stop(AI);       % Stops (all active processes on) analog input object
delete(AI);     % Deletes analog input object
clear AI        % Removes analog input object from workspace

end

