%HW4 of DSP course: BPF design by the Kaiser and Parks-McCellan
%This piece of code is written by: Zavareh Bozorgasl in Nov 2022
clc
clear 
Fstop1 = 9500;%Lower stop frequency (Hz) <=9.5 kHz
Fpass1 = 10000;%Passband frequency (Hz)  >=10 kHz
Fpass2 = 20000;%Passband frequency (Hz)
Fstop2 = 21500;%Upper stop frequency (Hz) >=21500
Astop1 = 65;%Stopband attenuation (>= 65 ) dB
Apass  = 1; %Passbadn ripple 1 dB
Astop2 = 65;%Stopband attenuation (>= 65 ) dB
Fs =  60000;%Sampling frequency (samples/second or Hz)
%%
%%LPF design by the Matlab function designfilt; The Kaiser window method
BPF_Kaiser = designfilt('bandpassfir', ...
  'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
  'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
  'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
  'StopbandAttenuation2',Astop2, ...
  'DesignMethod','kaiserwin','SampleRate',Fs);
%%
%%BPF design by the Matlab functions firpmord and firpm; Parks-McCellan
%firpmord estimates some parameters such as the n (order)
f = [Fstop1 Fpass1 Fpass2 Fstop2 ]; 
m = [0 1  0]; %desired function's amplitude, corresponding to the f vector frequencies
%deviation is computed as: 1/(10^3.25) = 5.6234e-04;
dev1 = 1/(10^(Astop1/20)); dev2 = 1/(10^(Astop2/20)); % Astop = 20log10(dev)
dev = [ dev1  dev1 dev2 ];%deviation for passband and stopband (equivalent to 65 dB)
%DEV is a vector of maximum deviations or ripples (in linear units)
% fo: normalized frequencies, mo:frequency band magnitudes, w:weights
[n,fo,mo,w] = firpmord(f,m,dev,Fs);%preparing the parametes for firpm function
%DEV is a vector of maximum deviations or ripples (in linear units)
BPF_PM = firpm(n+4,fo,mo);%BPF designed by Parks-McCellan

%%
h = fvtool(BPF_PM);% Here, I just plot the nice figure of an odd case
%h = fvtool(BPF_Kaiser);
%zoom(h,'passband');%Zooming on the passband of the filter 
%h = fvtool(LPF_PM,1,BPF_PM);% we can plot them simultaneously 

% We can plot each of the Kaiser or Parks-McCellan (in squence, or in a for
% loop). Here is just an example to show how I investigated the problem
figure(1)
h = fvtool(BPF_PM)
h.Analysis = "fre"
figure(2)
h = fvtool(BPF_PM)
h.Analysis = "phase"
figure(3)
h = fvtool(BPF_PM)
h.Analysis = "impulse"
figure(4)
h = fvtool(BPF_PM)
h.Analysis = "grpdelay"
figure(5)
h = fvtool(BPF_PM)
h.Analysis = "polezero"
figure(6)
h = fvtool(BPF_PM)
h.Analysis = "info"