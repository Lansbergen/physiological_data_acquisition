function run_trigger(ai,event,settings)
%run_trigger is called when triggered and ensures that session data is
%recorded and saved accordingly
%   
%   The function run_trigger gets the Analog Input Object as an input as
%   well as some event information and parameter settings struct. Each new
%   session is saved to a pre-set data directory (set by the stimulus-PC).
%    
%   (c) 2016, Simon Lansbergen.
% 

% session number is equal to the trigger number
index = event.Data.Trigger;  

% wait to block Matlab during acquisition time, with an additional 5
% seconds for safety.
wait(ai,(settings.duration + 5));

% get actual data
[data, time] = getdata(ai);

% create output file name and save
file_string = 'test_data%d.txt';
file_str = sprintf(file_string,index);
save_to = fullfile(settings.data_dir,file_str);
save(save_to,'data','time','-ascii');

% Done acquiring and saving session data
done_string = ' -> Done acquiring and saving session : %d.';
done_str = sprintf(done_string,index);
disp(' '); disp(done_str); disp(' ');


end