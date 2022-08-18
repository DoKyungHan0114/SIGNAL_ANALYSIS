function listenfm(cf,playtime)
% 
% listenfm(cf,playtime)
% cf is the centre frequency, in Hz, default set to 106.1e6 Hz
% t is the time to listen, in minutes, default is 1 minute
%
%Usage- 
% listenfm() - plays default station, 106.1MHz, ABC Classic, for 1 minute
% listenfm(102.1e6) - plays station at 102.1MHz, ZZZ, for 1 minute
% listenfm(107.7e6,5) -plays station at 107.7Mhz, JJJ, for 5 minutes
%
%Notes-
% If a frequency above or below the fm band is selected, the function will
% default to a pre selected station toward the end of the spectrum nearest
% to the user input.
%
% If a time period is selected that is less then 1 minute, the play time
% will default to 1 minute, if a time period is selected for more than 59
% minutes, the play time will default to 59 minutes.
%
% List of stations for brisbane region
% 87.6 Mhz/87.8 Mhz/88.0 Mhz (various suburbs) Vision FM
% 88.0 Mhz (Brisbane CBD, southern suburbs and Moreton Island) 
% 93.3 Mhz SBS Radio (international languages)
% 94.9 Mhz River 94.9
% 96.5 Mhz 96five Family FM
% 97.3 Mhz 97.3 FM MIX
% 98.1 Mhz 4EB (ethnic community radio)
% 98.9 Mhz 98.9 FM (Indigenous community radio)
% 99.7 Mhz Bridge FM
% 100.3 Mhz Bay FM
% 101.1 Mhz 101.1 KIIS FM
% 102.1 Mhz 4ZZZ
% 103.7 Mhz 4MBS
% 104.5 Mhz Triple M
% 105.3 Mhz B105 FM
% 106.1 Mhz ABC Classic FM
% 106.9 Mhz Nova 106.9
% 107.7 Mhz Triple J
%
% station information collected from 
% https://www.brisbane.qld.gov.au/community-and-safety/community-safety/disasters-and-emergencies/severe-weather-alerts/brisbane-radio-stations

%% massage user input

if nargin == 0
    cf = 106.1e6; % classic FM
end

if (cf <87.5e6)
    cf = 93.3e6 % SBS FM
    fprintf('frequency below fm band, listen to %.1f instead\n',cf/1e6)
end
if (cf>108e6)
    cf = 107.7e6; %triple J
    fprintf('frequency above fm band, listen to %.1f instead\n',cf/1e6)
end

if nargin<2
    playtime = 1;
end

if playtime > 59
    playtime = 59;
    fprintf('playtime too long, set to %i \n',playtime)
end

if playtime <1
    playtime = 1;
    fprintf('playtime too short, set to %i \n',playtime)
end

fprintf('Listening to %.1f MHz for %i minutes\n',cf/1e6,playtime)


%%
%Capture parameters
sdrid = '0'; % RTL-SDR ID
gain = 29;
%cf = (usercf)*1e6;  %Centre frequencny in Hz
fs = 228e3; % SampleRate in Hz- default 250e3
frame = 2983;  %Samples per frame -default 1024
dataType = 'single'; %output data type

%Demodulate & Audio Playback parameters
audiofs = 48000;  %Audio samplerate 
ft = 7.5000e-05; % Filter time constant
buf = 3840; % Buffer size

% Radio Loop control
run = true; % Bool to control play loop


%% Connect to radio
fmRadio = comm.SDRRTLReceiver('RadioAddress',sdrid,...
    'CenterFrequency',cf,...
    'SampleRate',fs,...
    'OutputDataType',dataType,...
    'EnableTunerAGC', true,...
    'SamplesPerFrame',frame);
%% Demodulation of radio signal;
fmDemod = comm.FMBroadcastDemodulator(...
    'SampleRate', fs, ...
    'FilterTimeConstant', ft, ...
    'AudioSampleRate', audiofs, ...
    'PlaySound', true, ...
    'BufferSize', buf, ...
    'Stereo', true);
    
%% Play Radio

start = datetime('now'); %initialise start time

while run 

    for i=1:10
    fmRx =step(fmRadio);
    fmrcv = fmDemod(fmRx);
    end
    
    played = datetime('now');
    if ((played.Minute-start.Minute)> playtime)
        run = false;
    end
    

    
end;
    


%% Clean up

release(fmRadio)
release(fmDemod)

end
