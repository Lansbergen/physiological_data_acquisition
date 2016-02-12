function run_trigger(ai,event,settings)
%run_trigger is called when triggered and ensures that session data is
%recorded and saved accordingly
%   
%   The function run_trigger gets the Analog Input Object as an input as
%   well as some event information and parameter settings struct. Each new
%   session is saved to a pre-set data directory (set by the stimulus-PC).
%
%   The data and time variables which are collected by getdata() are stored
%   as one channel each collum. So when multiple channels are simultaneously
%   saved, all data is stored in one variable with number of collums
%   related to the configured channels.
%    
%   (c) 2016, Simon Lansbergen.
% 


% wait to block Matlab during acquisition time, with an additional 0.5
% seconds for safety.
wait(ai,(settings.duration + 0.5));

% get actual data
[data, time] = getdata(ai);

% save both time and data, as well as hardware and c
file_str = 'physiological_data';
save_to = fullfile(settings.data_dir,file_str);
channel_settings = ai.Channel;
save(save_to,'data','time','channel_settings');

% Done acquiring and saving session data
done_msg = sprintf('\n \n Done acquiring and saving session \n \n');
logmsg(done_msg);

end