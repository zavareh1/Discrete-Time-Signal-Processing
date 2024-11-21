%HW4 of DSP course: LPF design by the Kaiser and Parks-McCellan
%This piece of code is written by: Zavareh Bozorgasl in Nov 2022
clc
clear 
%%
Fpass = 20000;%Passband frequency (Hz) or 20 kHz
Fstop = 24000;%Stopband frequency (Hz) or 24 kHz
Apass = 1;%Passband ripple (dB)
Astop = 65;%Stopband attenuatution (dB)
Fs = 60000;%Sampling frequency (samples/second or Hz) or 60 kSamples/second
%% LPF design by the Matlab function designfilt; The Kaiser window method
LPF_Kaiser = designfilt('lowpassfir', ...
  'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
  'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
  'DesignMethod','kaiserwin','SampleRate',Fs);
%%
%%LPF design by the Matlab functions firpmord and firpm; Parks-McCellan
%firpmord estimates some parameters such as the n (order)
f = [Fpass Fstop]; 
m = [1 0]; %desired function's amplitude, corresponding to the f vector frequencies
%deviation is computed as: 1/(10^3.25) = 5.6234e-04;
dev1 = 1/(10^(Astop/20)); dev2 = 1/(10^(Astop/20)); % Astop = 20log10(dev)
dev = [dev1 dev2];%deviation for passband and stopband (equivalent to 65 dB)
%DEV is a vector of maximum deviations or ripples (in linear units)
% fo: normalized frequencies, mo:frequency band magnitudes, w:weights
[n,fo,mo,w] = firpmord(f,m,dev,Fs);%preparing the parametes for firpm function
LPF_PM = firpm(n+1,fo,mo);%LPF designed by Parks-McCellan

%%
%Analysing the results
h = fvtool(LPF_Kaiser)
%h = fvtool(LPF_PM);
%zoom(h,'passband');%Zooming on the passband of the filter 
%h = fvtool(LPF_PM,1,LPF_Kaiser);% we can plot them simultaneously 

% We can plot each of the Kaiser or Parks-McCellan (in squence, or in a for
% loop). Here is just an example to show how I investigated the problem
figure(1)
h = fvtool(LPF_Kaiser)
h.Analysis = "fre"
figure(2)
h = fvtool(LPF_Kaiser)
h.Analysis = "phase"
figure(3)
h = fvtool(LPF_Kaiser)
h.Analysis = "impulse"
figure(4)
h = fvtool(LPF_Kaiser)
h.Analysis = "grpdelay"
figure(5)
h = fvtool(LPF_Kaiser)
h.Analysis = "polezero"
figure(6)
h = fvtool(LPF_Kaiser)
h.Analysis = "info"


