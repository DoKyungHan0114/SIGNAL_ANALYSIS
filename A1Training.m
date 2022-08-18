%% Assignment 1 Template 
%  Run the GenerateAssignment1Data.m script if you have not already done
%  so.
clear all, close all, clc % clearing and preparing a clean workspace.
% Loading your data into the workspace. 
% Do not change the following line.
load('A1Data.mat','msg','fs','st1','st2','st3');

%==========================================================================
% Below are the variables you MUST use throughout your assignment.
% Failure to adhere to the names will result in your group losing marks.
% Not all variables may be referenced in the assignment brief. However, it
% is a good idea to examine these vectors and make sure they are what you
% expect them to be.
% 
% ------- Part 1
% fc1 - carrier frequency
% c1 - carrier
% m1 - message
% kf1 - frequency sensitivity factor
% y1 - modulated signal (time domain)
% Y1 - modulated signal (frequency domain) - Fourier transform only
% beta1 - Modulation Index
% Df1 - Maximum frequency deviation

% ------ Part 2
% msg - message
% fs - sample rate
% kf2 - frequency sensitivity factor
% Df2 - Peak Frequency Deviation
% t2 - time vector
% BW_FM - theoretical bandwidth
% BW_MSG - Message Bandwidth
% fc2 - carrier frequency
% msg_tx - modulated signal
% msg_rx - modulated signal after passing through channel
% msg_rc - recovered message (demodulated signal) 
% beta2 - modulation index
%==========================================================================
% Enter your code below this line:
%==========================================================================
%% FM Theory
%% a) Model
% Frequency Modulation Parameters
fc1 = 450e6;        % Carrier signal frequency
Ac = 10;            % Carrier signal amplitude
Tc = 1/fc1;         % Carrier signal period
fm = 15e3;          % Message signal frequency
Am = 1;             % Message signal amplitude
Tm = 1/fm;          % Message signal period
kf = 60000;         % Sensitivity factor

% Create time vectors for carrier and message signals
tc = linspace(0,Tc,1e3);
tm = linspace(0,Tm,1e3);

% Define carrier and message signals for one period
c = Ac*cos(2*pi*fc1*tc);
m = Am*cos(2*pi*fm*tm);

% Plot carrier and messag signals
figure(1)
subplot(2,1,1)
plot(tc, c);
title('Carrier Signal, 450MHz')
xlabel('Time (s)')
ylabel('Amplitude (V)')
subplot(2,1,2)
plot(tm, m);
title('Message Signal, 15KHz')
xlabel('Time (s)')
ylabel('Amplitude (V)')
%% b) Freq Dev and Mod Index
beta1 = (kf*Am)/fm;     % Modulation Index
Df1 = beta1*fm;         % Maximum Frequency Deviation
%% c) Determine Side Bands
R = 1;                                  % Assumed Resistance
Pc = ((Ac*besselj(0,4))^2)/(2*R);       % Carrier Power
% Calculate Side Band Power and Store in Array
for n = 1:5
    Psb(n) = ((Ac*besselj(n,4))^2)/(2*R)+((Ac*besselj(-n,4))^2)/(2*R);
end
% Calculate Total Power
TotalP = Pc + sum(Psb)
%% d) Plot Magnitude Spectrum
% Store magnitudes and frequencies in separate vectors
mag = [1.9855, 0.33, 1.8205, 2.151, 1.4055, 0.6605];
freq = [4.5e8, 4.50015e8, 4.49985e8, 4.5003e8, 4.4997e8, 4.50045e8, 4.49955e8, 4.5006e8, 4.4994e8, 4.50075e8, 4.49925e8];
% Plot magnitudes against frequencies
figure(2)
hold on
m = 1;              % Counter for magnitude
% Loop over each frequency in the frequency vector
for f = 1:length(freq)
    % Draw a line from 0 to the corresponding magnitude for each frequency
    line([freq(f), freq(f)], [0, mag(m)])
    % Plot a circle at the peak magnitude of each frequency
    plot(freq(f), mag(m), 'ro')
    % If the frequency is odd
    if mod(f,2) == 1;
        m = m + 1;  % Increment magnitude
    end
 end
title('Magnitude Spectrum of Frequency Modulated Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude (V)')     
%% e) Estimate Bandwidth
% Calculate bandwidth between maximum and minimum spectral frequencies
band = max(freq) - min(freq);
%% f)
%% PART 2: FM Training
% a) Download the "Assignment1.zip" and unzip
% b) Generate data with three student ID numbers

% c) 
length_signal = length(msg); %To create time vetor, get length of msg signal


t2 = linspace (1,length(msg)/fs,length_signal); % Cteate time vetor with using Linspace
figure(3);
plot(t2,msg) % Plot msg to identify features
xlabel('Times(t)');ylabel('Magnitude');title('Message Signal');
grid on; grid minor;

%Important feature

%% d)
% To get specturm of siganl,using fourier transform into frequency domain
time_length = length(t2);

%Create frequency vector
f = linspace(-fs/2, fs/2, time_length + 1);
f(end) = [];

% Using inbuilt fuction fft for fourier transfrom
msg_spectrum = fft(msg)/fs;

% The lines below to plot msg on frequency domain
figure(4);
plot(f,abs(fftshift(msg_spectrum)))
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('Spectrum of MSG');
xlim([-800,800]);

grid on;
grid minor;

% Estimate bandwidth and frequency of message siganl according to graph.
BW_MSG = 700;
fm2 = 200;
%% e)
%Create impulse function which has same length as msg signal
impulse = [1,zeros(1,length(msg) - 1)];

% Put impulse function to channel function
[impulse_rx] = channel(impulse);

% Using fourier transform to plot on frequency domain
IMPULSE = fft(impulse_rx);

% The lines below to plot impulse system
figure(5);
plot(f,abs(fftshift(IMPULSE)))
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('Spectrum of Impulse');
grid on; grid minor;

% Carrier frequency
fc2 = 16000;
%% f)
% Rearrange the folmula to get beta2 : BW = 2(beta + 1)*fm
%(BW/2*fm) - 1 = beta;
beta2 = (BW_MSG/(2*fm2)) - 1;
% Sensitivity of factor
Am_msg = max(msg);
kf2 = (beta2*fm2)/Am_msg;

%% g)
%Rearrange the fomula to get Df2 : beta = f_d / f_m
Df2 = beta2 * fm2;

BW_FM = Df2;

%% h) & i)
% part h & i to build fm_mod matlab function

%% j)
msg_tx = fm_mod(msg,fc2,fs,kf2);


%% k)
figure();
t3 = linspace(0,length(msg),length(msg)+1);
t3(end) = [];
plot(t3,msg_tx)
xlabel('times(t)');ylabel('Magnitude');title('Modulated message signal');
xlim([0,1000]);
grid on; grid minor;
figure();
MSG_TX = fft(msg_tx);
plot(f,abs(fftshift(MSG_TX)))

xlim([-10000,10000]);
xlabel('Frequency(Hz)');
ylabel('Magnitude');
title('Spectrum of msg tx');
grid on; grid minor;

%% m)
msg_rx = channel(msg_tx);

%% o)
msg_rc = fm_demod(msg_rx, fc2, fs, kf2);
disp(msg_rc)

%%
%{
 Part 3 
 Hardware setup
%}

mysdr = sdrinfo;


%{
 3a  Write a MATLAB function titled listenfm to listen to a selected FM radio station using RTL-SDR
%}

help listenfm % shows helpfile for listenfm function, explains the usage.

%{
 3b Use the spectrumanalyser.m to scan the spectrum
 
%}


spectrum_analyser


%{
3c. Several different spectral bands exist, and are used for different purposes. 
 These include,
1.  FM analog radio transmission
2.  Digital Audio Broadcasting (DAB)
3.  Digital Video Broadcasting (DVB)
4.  Mobile Frequencies
5.  Queensland Government Wireless Network (GWN)
For each of the listed ranges, scan and plot the frequency spectrum.  
Also state character-istics of these transmission and the owners of these frequencies
%}

%common parameters
fs = 3.2e6;
num = 2^14;


%3c.1 FM 87.5 to 108 MHZ 

fstart = 87.5e6;
fstop = 108e6;
loc = 'Brisbane FM Spectrum';
spectrum_sweep(fstart,fstop,fs,num,loc)

%3c.2 Digital Audio Broadcasting (DAB)  175 to 230MHz
fstart = 174e6;
fstop = 230e6;
loc = 'Brisbane DAB Spectrum';
spectrum_sweep(fstart,fstop,fs,num,loc)

%3c.3 Digital Video Broadcasting (DVB)520 to 625MHZ
fstart = 520e6;
fstop = 625e6;
loc = 'Brisbane DVB Spectrum';
spectrum_sweep(fstart,fstop,fs,num,loc)

%3c.4 Mobile Frequencies
%{
Start Band MHz	End Band MHz	Usage
825             845             3G
870             890             3G
890             915             GSM/3G
935             960             GSM/3G
1710            1785            GSM*

* there are bands in the mobile spectrum above these frequencies, but they
lay beyond the frequency range of the rtl-sdr
%}
%all mobile
fstart = 825e6;
fstop = 1765e6;
loc = 'Brisbane Mobile Spectrum';
spectrum_sweep(fstart,fstop,fs,num,loc)

%3G a & b

fstart = 825e6;
fstop = 845e6;
loc = 'Brisbane 3G Spectrum detail (a)';
spectrum_sweep(fstart,fstop,fs,num,loc)

fstart = 870e6;
fstop = 890e6;
loc = 'Brisbane 3G Spectrum detail (b)';
spectrum_sweep(fstart,fstop,fs,num,loc)

%GSM/3G

fstart = 890e6;
fstop = 915e6;
loc = 'Brisbane 3G/GSM Spectrum detail (c)';
spectrum_sweep(fstart,fstop,fs,num,loc)

fstart = 935e6;
fstop = 960e6;
loc = 'Brisbane 3G/GSM Spectrum detail (d)';
spectrum_sweep(fstart,fstop,fs,num,loc)

fstart = 171e7;
fstop = 175e7;
loc = 'Brisbane GSM Spectrum detail (e)';
spectrum_sweep(fstart,fstop,fs,num,loc)







%3c.5 Queensland Government Wireless Network (GWN)420-430MHz

fstart = 420e6;
fstop = 430e6;
loc = 'Brisbane QLD GWN Spectrum';
spectrum_sweep(fstart,fstop,fs,num,loc)

%3d Discuss the effect of the number of samples per frame,L, on the above spectral measurements
%{
example using local FM radio 106.1MHZ, for increasingnumber of samples
%}

fstart = 105.6e6;
fstop = 106.6e6;
for i = 4:2:18
    num = 2^i;
    loc = strcat('Brisbane FM Spectrum, number of samples n=2^',num2str(i),' (L)= ',num2str(num)) ;
    spectrum_sweep(fstart,fstop,fs,num,loc)
end



%{
3e Identify several common radio stations in your current area.  Label this on a spectrum plot.
%}





%{
3f from  the  information  gathered  in  the  previous  parts,  make  an  informed  decision  for  
a suitable carrier frequency for Fraser Island emergency communication system.  Be sure tolist all 
the factors that impacted your decision.
%}

%{
3g Discuss the advantages and disadvantages of using Digital emergency communications
%}





