%-------------------------------------------------------------------------%
init = true;   % initialize, yes=true no=false
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
% 
%
% Log:
% 14-1-2016 - Created program.
%           - Introduced daq_parameters_mcc() function.            
%
%
% program:
% main script for processing data acquisition in a loop. Program is
% explicitly written for DAQ MCC PCI DAS-6025, using MatLab ver. 2015b 32bit
% for data aqcuisition toolbox legacy interface. MCC PCI DAS-6025 has a 
% fixed 12 bits per sample.
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

% put in checks for pc system pcwin, unix, mac-os
% to generalize code and improve compatibility

c = computer;

% Get MCC specific parameters and analog input object readily configured
[ai, settings] = daq_parameters_mcc();    % get ai object and settings
start (ai);                               % activate ai object
disp(' ');disp(' ');
disp('*** Pre-configured Analog Input ***');
disp(' ');
disp('Look into parameter function file to set specific');
disp('configuration settings displayed below and found in');
disp('settings.');
disp(' ');
disp(' ');
disp(ai);


%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data Aqcuisition %%%
%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% create while loop
%%%

[ data, time ] = getdata(ai);


%%%%%%%%%%%%%%%%%
%%% Plot Data %%%
%%%%%%%%%%%%%%%%%

figure;
plot(time,data);
xlabel('Time (s)');         % Setting up the xlabel
ylabel('Signal (Volts)');   % Setting up the ylabel
title('Data Acquired');     % Setting up the title
legend(settings.hwnames);
grid on; 


% *************************************
% *** Stop and delete analog object ***
% *************************************
% Stop acquire data
stop(ai);       % Stops (all active processes on) analog input object
delete(ai);     % Deletes analog input object
clear ai        % Removes analog input object from workspace
