function [ settings ] = daq_parameters()
%daq_parameters gives acquisition pre-set parameters to main script.
%   
%   In this function all relevant parameters can be set for the physiology
%   data acquisition main script. The function can be copied and saved with
%   the addition of _nameofparameterset to the file name.
%    
%   (c) 2016, Simon Lansbergen.
%   


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Parameter Settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

settings.duration = 0.05;                % Duration of sample (seconds)
settings.sample_rate = 10000;            % Set sample rate (Hz), max = 200000Hz, min = 1Hz.
settings.trigger_type = 'Immediate';    % Set trigger type -> Triggerd immediate when start is executed
% settings.trigger_type = 'HwDigital';     % Set trigger type -> Triggerd from hardware (digital channel) TTL
settings.trigger_cond = 'TrigPosEdge';   % Set trigger condition -> Triggered when a positive edge is detected


end

