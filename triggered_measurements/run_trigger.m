function run_trigger(~,~,settings)
%runtrigger is used for displaying acquisistion progress
%   
%   Nothing here yet.
%    
%   (c) 2016, Simon Lansbergen.
% 


% use this maybe to implement getdata and wait command for safety and more
% elegant code?

str_body = 'Total Acquisition time this session : %d (seconds).';
str_out = sprintf(str_body,settings.duration);
disp(' ');
disp(' *** Acquisition in progress ***');
disp(' ');
disp(str_out);
disp(' ');

end