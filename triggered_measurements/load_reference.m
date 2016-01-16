function [ trigger_number, data_dir] = load_reference()
%load_reference gives acquisition trigger parameter and save directory to parameter function.
%
%   This function loads the number of acquisition session triggerd by an
%   extrnal TTL pulse. The function retreives this data as well as the 
%   reference to the save directory of the session data, from the
%   Stimulus-PC.
%   
%   The data collected in the function is given by [trigger_number,
%   data_dir] the data is already converted into machine specific
%   convention.
%    
%   (c) 2016, Simon Lansbergen.
%   
%   Currently the function is still working outside InVivoTools (fixed
%   simulated)!
%

% read-in acqReady
% for testing outside InVivoTools

filepath = 'C:\Data\stims\acqReady';
test = fullfile(filepath);
delimiterIn = '	';

% !! Use when implemented in InVivoTools !!

% remotecommglobals;
% acqready = fullfile(Remote_Comm_dir,'acqReady');
%
% AND TEST FOR EXISTENCE (maybe try loop?)




% !! From this point on no testing code !!

% Reomve variable test from path_data

% import data
path_data = importdata(test,delimiterIn);

% convert cell to string
temp = cell2mat(path_data(2));

% convert string for proper path convention on multiple platforms
% directory used for both reading the trigger parameter as storing the
% session data.

data_dir_file = fullfile(temp,'acqParams_in');
data_dir = fullfile(temp);

% get retrieve total amount of triggers to start each acquisition session
trigger_data = importdata(data_dir_file);
trigger_number = trigger_data.data(2);

% when fully loaded, output ok message to screen
disp(' ');
disp(' *** Loaded reference data from Stimulus-PC correctly ***');
disp(' ');

end