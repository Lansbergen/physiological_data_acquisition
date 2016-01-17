function run_trigger(ai,event,settings)
%runtrigger is used for displaying acquisistion progress
%   
%   Nothing here yet.
%    
%   (c) 2016, Simon Lansbergen.
% 

% session number is equal to the trigger number
index = event.Data.Trigger;  

% str_body = 'Total Acquisition time session %d : %d (seconds).';
% str_out = sprintf(str_body,index,settings.duration);
% disp(' ');
% disp(str_out);
% disp(' ');

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