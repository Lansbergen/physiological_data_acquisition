function [ ai, settings ] = daq_parameters_mcc( input_arg )
%daq_parameters_mcc gives acquisition pre-set parameters to main script.
%
%   In this function all relevant parameters can be set for the physiology
%   data acquisition main script. The function is specifically written for
%   the DAQ PCI DAS-6025 acquisition card.
%
%   MCC DAQ PCI DAS-6025 has a fixed 12 bits per sample and 8 analog 
%   differential inputs.
%
%   -> to be completed
%    
%   (c) 2016, Simon Lansbergen.
%   

if input_arg.simulate == true
    settings.data_dir = input_arg.save_dir_temp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hardware Settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% daq_type sets the hardware fixed to the installed MCC DAQ PCI DAS-6025.
% the setting daq_hw_id sets the id of the installed hardware on the
% specific machine. This settings is likely to be changed on another system
% or setup.

settings.daq_type = 'mcc';                % Set adapter type
settings.daq_hw_id = '1';                 % Hardware ID

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Acquisition Settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change settings.samples_per_trigger to a value other than 0 if a manual
% input is needed for this parameter, otherwise the necessary samples per
% trigger is calculated automatically
%
% see also propinfo(ai) and help propinfo for detailed information on 
% parameter settings.

settings.sample_rate = 10000;             % Set sample rate (Hz), max = 200000Hz, min = 1Hz.


settings.trigger_type = 'Immediate';      % Set trigger type -> Triggerd immediate when start is executed
settings.trigger_type = 'HwDigital';      % Set trigger type -> Triggerd from hardware (digital channel) TTL
% settings.trigger_cond = 'TrigPosEdge';    % Set trigger condition -> Triggered when a positive edge is detected
settings.trigger_cond = 'TrigNegEdge';    % Set trigger condition -> Triggered when a negative edge is detected -> TTL convention used by stimulus-PC.
settings.samples_per_trigger = 0;         % Sets samples per trigger manually if not equal to 0.
settings.trigger_repeat = 0;              % the amount of triggered samples to be taken if false than default
                                          % when counted 0 is 1, but cannot be used eg. 10 -> 11 triggers
                                  
                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data Aqcuisition Timing %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Timing is obtained by reading a timer file, or by extracting the total
% number of blocks/timeslots of each measuring session. The latter is
% multiplied by 10 sec and an additional 10 seconds are added to the total
% acquisition time per session. 
%    
% Timing between sessions is less critical in terms of speed. This will not
% exceed the time it takes to load the parameters and Analog Input Object
% and should be at least more than a minute.                                        

%%% Retrieve trigger information and save directory reference from Stimulus-PC %%%
if input_arg.simulate == true
settings.duration = 10;                  % Duration of sample (seconds)
else
[settings.block_number, settings.data_dir] = load_reference;
% Duration is number of blocks times 10 sec + an additional 10 sec. 
% FIXED TIMING PARAMETER
settings.duration = (settings.block_number * 10) + 10;                 
end



%%%%%%%%%%%%%%%%%%%%%%%%
%%% Channel Settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%

% Define input channels for aqcuisition. The DAQ has 8 analog differential
% inputs labeled 0 to 7. The number of diff channels can be added in the []
% array. eg. [0 1 2 6]. Note that the first channel for MCC is 0 while this
% is not always the case with other hardware.
% With the use of {'name_channel_1','name_channel_2'} in the [] array,
% multiple names can be added to analog data object ai

settings.hwchannels = [0];                 % DAQ channel input Sinks
settings.hwnames = [{'diff 1'}];           % Give name to channels


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create Analog Input Object %%%      <- Important latest step !!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get analog input with settings struct as an input.
% Calls function to receive readily configured analog input object.
% Trigger callback function set in create_input() function.
[ai, ai_channel_setting] = create_analog_input(settings);     


% Add miscellaneous to settings struct
settings.ai_channel_setting = ai_channel_setting;
settings.ai_propinfo        = propinfo(ai);
settings.simulate           = input_arg.simulate;


% info on configuration
disp(' ');disp(' ');
disp('*** MCC PCI DAS-6025 Pre-configured Analog Input ***');
disp(' ');
disp('Look into parameter function file to set specific');
disp('configuration settings displayed below and found in');
disp('settings. -> help daq_parameters_mcc()');
disp(' ');
disp(' ');
% show summarized information Analog Input object
disp(ai);


end

