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


%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data Aqcuisition %%%
%%%%%%%%%%%%%%%%%%%%%%%%

% The main while loop runs as long as the Analog Input Objects waits for an
% external trigger and drives the data acquisition. When there are no 
% triggers left the loop runs until there is no data remaining in the 
% acquisition buffer. The last session is saved outside the main while
% loop.

% set local variables
index = 1;      % start index for save file <- temp?
triggers_remaining = (ai.TriggerRepeat + 1) - ai.TriggersExecuted;

% output information on screen
remain_string = 'Remaining triggers : %d';
remain_str = sprintf(remain_string,triggers_remaining);
wait_string = ' *** Waiting for trigger number : %d ***';
wait_str = sprintf(wait_string,index);
disp(' '); disp(remain_str); disp(' '); disp(wait_str);

% main loop
while triggers_remaining ~= 0 
    
    % acquisition and save loop
    if ai.SamplesAvailable ~= 0
        
        % get actual data
        [ data, time ] = getdata(ai);
        
        % create output file name and save
        file_string = 'test_data%d.txt';
        file_str = sprintf(file_string,index);
        save(file_str,'data','time','-ascii');
        
        % display progress
        ok_string = 'saved data to test_data%d.txt succesfully';
        ok_str = sprintf(ok_string,(index));
        disp(' '); disp(ok_str); disp(' '); disp(' '); disp(' ');
        remain_string = 'Remaining triggers : %d';
        remain_str = sprintf(remain_string,triggers_remaining);
        wait_string = ' *** Waiting for trigger number : %d ***';
        wait_str = sprintf(wait_string,index + 1);
        disp(remain_str); disp(' '); disp(wait_str);
        
        % give index +1 after acquisition and save statements
        index = index + 1;      
    end
    
    % calculate remaining triggers again to progress in while loop
    triggers_remaining = (ai.TriggerRepeat + 1) - ai.TriggersExecuted;
end

% get data from the last session, which the loops jumps over
[ data, time ] = getdata(ai);

% save and output progress
file_string = 'test_data%d.txt';
file_str = sprintf(file_string,index);
save(file_str,'data','time','-ascii');
ok_string = 'saved data to test_data%d.txt succesfully';
ok_str = sprintf(ok_string,index);
disp(' '); disp(ok_str); disp(' ');
 

%%%%%%%%%%%%%%%%%
%%% Plot Data %%%
%%%%%%%%%%%%%%%%%

% Plot data just for now as a control mechanism

% figure;
% plot(time,data);
% xlabel('Time (s)');         % Setting up the xlabel
% ylabel('Signal (Volts)');   % Setting up the ylabel
% title('Data Acquired');     % Setting up the title
% legend(settings.hwnames);
% grid on; 


%%%%%%%%%%%%%%%%%%%%%%%
%%% Summary Session %%%
%%%%%%%%%%%%%%%%%%%%%%%

disp(' ');disp(' ');disp(' ');
disp(' *** Summary Acquisition Session ***');
showdaqevents(ai);
disp(' ');disp(' ');


% *************************************
% *** Stop and delete analog object ***
% *************************************

% Stop acquire data
stop(ai);       % Stops (all active processes on) analog input object
delete(ai);     % Deletes analog input object
clear ai        % Removes analog input object from workspace

% clear data in workspace
% clear         % disable in debug mode

