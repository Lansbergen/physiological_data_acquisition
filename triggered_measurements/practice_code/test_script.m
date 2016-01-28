
% Set paths yourself

% temp1 = load('D:\Dropbox\NIN\data\data_set_1.mat');
% temp2 = load('D:\Dropbox\NIN\data\data_set_2.mat');
% temp3 = load('D:\Dropbox\NIN\data\data_set_3.mat');
% temp4 = load('D:\Dropbox\NIN\data\data_set_4.mat');
% 
% data1 = temp1.data;
% time1 = temp1.time;
% data2 = temp2.data;
% time2 = temp2.time;
% data3 = temp3.data;
% time3 = temp3.time;
% data4 = temp4.data;
% time4 = temp4.time;



% pre settings
Fs = 10000;                    % Sampling frequency
N = length(data1(1:600000,:)');


%%%%%%%%%%%%%%%%%%
%%% Data Set 1 %%%
%%%%%%%%%%%%%%%%%%

% data set 1
xdft1 = fft(data1(1:600000,:)');
xdft1 = xdft1(1:N/2+1);
psdx1 = (1/(Fs*N)) * abs(xdft1).^2;
psdx1(2:end-1) = 2*psdx1(2:end-1);
freq1 = 0:Fs/length(data1(1:600000,:)'):Fs/2;

% heart rate variable data set 1
[~,heart_rate_data1]= max(psdx1);
disp('Heart Rate Data set 1 : ');disp(heart_rate_data1);

% plot data set 1
figure
subplot(2,2,1)
plot(freq1(1:1500),10*log10(psdx1(1:1500)))
grid on
title('Periodogram Data Set 1 Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')


%%%%%%%%%%%%%%%%%%
%%% Data Set 2 %%%
%%%%%%%%%%%%%%%%%%

% data set 2
xdft2 = fft(data2(1:600000,:)');
xdft2 = xdft2(1:N/2+1);
psdx2 = (1/(Fs*N)) * abs(xdft2).^2;
psdx2(2:end-1) = 2*psdx2(2:end-1);
freq2 = 0:Fs/length(data2(1:600000,:)'):Fs/2;

[~,heart_rate_data2]= max(psdx2);
disp('Heart Rate Data set 2 : ');disp(heart_rate_data2);

% plot data set 2
subplot(2,2,2)
plot(freq2(1:1500),10*log10(psdx2(1:1500)))
grid on
title('Periodogram Data Set 2 Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')


%%%%%%%%%%%%%%%%%%
%%% Data Set 3 %%%
%%%%%%%%%%%%%%%%%%

% data set 3
xdft3 = fft(data3(1:600000,:)');
xdft3 = xdft3(1:N/2+1);
psdx3 = (1/(Fs*N)) * abs(xdft3).^2;
psdx3(2:end-1) = 2*psdx3(2:end-1);
freq3 = 0:Fs/length(data3(1:600000,:)'):Fs/2;

[~,heart_rate_data3]= max(psdx3);
disp('Heart Rate Data set 3 : ');disp(heart_rate_data3);

% plot data set 3
subplot(2,2,3)
plot(freq3(1:1500),10*log10(psdx3(1:1500)))
grid on
title('Periodogram Data Set 3 Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')


%%%%%%%%%%%%%%%%%%
%%% Data Set 4 %%%
%%%%%%%%%%%%%%%%%%

% data set 4
xdft4 = fft(data4(1:600000,:)');
xdft4 = xdft4(1:N/2+1);
psdx4 = (1/(Fs*N)) * abs(xdft4).^2;
psdx4(2:end-1) = 2*psdx4(2:end-1);
freq4 = 0:Fs/length(data4(1:600000,:)'):Fs/2;

[~,heart_rate_data4]= max(psdx4);
disp('Heart Rate Data set 4 : ');disp(heart_rate_data4);

% plot data set 4
subplot(2,2,4)
plot(freq4(1:1500),10*log10(psdx4(1:1500)))
grid on
title('Periodogram Data Set 4 Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

