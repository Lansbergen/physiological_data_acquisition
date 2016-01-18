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
%                   communication with the stimulus-PC acquisition
%                   file-output.
%            - SL - Added control for pc-unix-mac -> but no functionallity.
%            - SL - Added summary session to screen.
% 16-1-2016  - SL - Added input_arg to parameters function, enabling the
%                   acquisition to run in Simulation for Beta testing
% 17-1-2016  - SL - Removed save and acquisition while loop in Main.m and
%                 - created trigger function call back. Within this call
%                   back function session data is saved.
%                 - Protected acquisistion with wait command, which ensures
%                   that MatLab locks until the acquisistion is complete
% 18-1-2016  - SL - Cleaned up existing code (removed old obsolete code)
%                   and added function descriptions of new functionallity.
%                 - Added new while loop with propper break possibility to
%                   stop acquisistion is complete
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load Parameter Settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use daq_parameters() vendor specific function (e.g. MCC DAQ PCI  
% DAS-6025 -> daq_parameters_mcc() ). Look into the help file of
% daq_parameters to check if input_arg are mandatory.


% Get MCC specific parameters and analog input object readily configured
[ai, settings] = daq_parameters_mcc( input_arg );    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% On-Screen Session Information %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

session_number = (ai.TriggerRepeat + 1);
session_info_string = ' -> Total session(s) this run : %d';
session_info_str = sprintf(session_info_string, session_number);
disp(' ');
disp(session_info_str);
disp(' ');
disp(' *** Acquisition waiting for trigger(s) ***');
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data Aqcuisition Loop %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The main while loop runs as long as the Analog Input Objects is active,
% either waiting for an external trigger or acquiring session data. When 
% there are no triggers left and no active acquisition, the loop breaks.
% The aqcuisition and saving this data is done in the run_trigger trigger
% call back function

% activate Analog Input Object -> either waits for trigger or starts immediatly
start (ai);                               

% main while loop
while true
    
    % breaks from loop if daq is inactive (i.e. waiting for start command)
    if strcmp(ai.Running,'Off')
        disp(' *** Acquisition ended ***');
        break
    end
    
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

