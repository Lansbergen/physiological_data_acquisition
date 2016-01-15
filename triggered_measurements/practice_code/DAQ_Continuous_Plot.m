%-------------------------------------------------------------------------%
init = true;   % initialize ?
%-------------------------------------------------------------------------%
% 
% Software written by Simon Lansbergen, (c)2016.
%
% Continuous measurement data plot
%
% Log:
% 5-1-2015   - created program, based on MatLab examples in DAQ toolbox
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

DAQ_Info = daqhwinfo;

Settings.Daq_Type = 'winsound'; 
Info_DAQ_present = daqhwinfo(Settings.Daq_Type);
Settings.BoardID = cell2mat(Info_DAQ_present.InstalledBoardIds);
AI = analoginput(Info_DAQ_present.AdaptorName,Settings.BoardID);
addchannel(AI,1);

set(AI, 'TriggerType', 'immediate');
set(AI, 'SamplesPerTrigger', inf);
set(AI, 'TriggerRepeat', 0);

set(AI, 'TimerPeriod', 0.1);
set(AI, 'TimerFcn', @daqtimerplot);
set(AI, {'StartFcn', 'StopFcn', 'TriggerFcn'}, {'', '', ''});

% The analog input object is started.  Wait for up to 6 seconds for the
% acquisition to complete
start(AI)
%wait(AI,6);


% *************************************
% *** Stop and delete analog object ***
% *************************************

% Stop acquire data
% stop(AI);
% delete(AI);