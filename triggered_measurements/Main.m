%-------------------------------------------------------------------------%

init = true;   % initialize, yes=true no=false

%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
%
%   Editor(s):
%     SL : Simon Lansbergen
%
% Log:
% 14-1-2016  - SL - Created program.
%            - SL - Introduced daq_parameters_mcc() function.            
% 15-1-2016  - SL - Added main acquisition loop and save functionallity w/o
%                 - communication with the stimulus-PC acquisition
%                 - file-output.
%            - SL - Added control for pc-unix-mac -> but no functionallity.
%            - SL - Added summary session to screen.
% 16-1-2016  - SL - Added input_arg to parameters function, enabling the
%                 - acquisition to run in Simulation for Beta testing
%
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
% Simulate acquisition outside InVivoTools? true/false

input_arg.simulate = true;

%-------------------------------------------------------------------------%

% check running in simulation mode
if input_arg.simulate == true
    [input_arg.save_dir_temp] = daq_simulation();
end 

% put in checks for pc system pcwin, unix, mac-os
% to generalize code and improve compatibility

if ispc == 1;
    disp('This system is a Windows based computer');
    % follow-up statement
    
elseif isunix == 1;
    disp('This system is a Linux based computer');
    % follow-up statement
    
elseif ismac == 1;
    disp('This system is a Mac based computer');
    % follow-up statement
    
end

% Get MCC specific parameters and analog input object readily configured
[ai, settings] = daq_parameters_mcc( input_arg );    % get ai object and settings
start (ai);                               % activate ai object


% info on configuration
disp(' ');disp(' ');
disp('*** Pre-configured Analog Input ***');
disp(' ');
disp('Look into parameter function file to set specific');
disp('configuration settings displayed below and found in');
disp('settings.');
disp(' ');
disp(' ');
disp(ai);

% info on total session(s)
session_number = (ai.TriggerRepeat + 1);
session_info_string = ' -> Total session(s) this run : %d';
session_info_str = sprintf(session_info_string, session_number);
disp(' ');
disp(' *** Acquisition waiting for trigger(s) ***');
disp(' ');
disp(session_info_str);
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data Aqcuisition %%%
%%%%%%%%%%%%%%%%%%%%%%%%

% The main while loop runs as long as the Analog Input Objects waits for an
% external trigger and drives the data acquisition. When there are no 
% triggers left the loop runs until there is no data remaining in the 
% acquisition buffer. The last session is saved outside the main while
% loop.




while strcmp(ai.Running,'On')

    % what to do in this loop, and how to show progres?
   
end




 
% loop to implement in code checks if file is changed

% while 1
%     acqready_props = dir(acqready);
%     if ~isempty(acqready_props) && acqready_props.datenum > acqready_props_prev.datenum
%         logmsg('acqReady changed');
%         acqready_props_prev = acqready_props;
%         fid = fopen(acqready,'r');
%         fgetl(fid); % pathSpec line
%         datapath = fgetl(fid);
%         fclose(fid);
% 	
% 	wc_startpi(datapath);
%     else
%         pause(0.3);
%     end



%%%%%%%%%%%%%%%%%%%%%%%
%%% Summary Session %%%
%%%%%%%%%%%%%%%%%%%%%%%

% disp(' ');disp(' ');disp(' ');
% disp(' *** Summary Acquisition Session ***');
% showdaqevents(ai);
% disp(' ');disp(' ');


% *************************************
% *** Stop and delete analog object ***
% *************************************

% Stop acquire data
% stop(ai);       % Stops (all active processes on) analog input object
% delete(ai);     % Deletes analog input object
% clear ai        % Removes analog input object from workspace

% clear data in workspace
% clear         % disable in debug mode

