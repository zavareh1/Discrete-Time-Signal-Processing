%Written by: Zavareh Bozorgasl; Fall 2022

fc1 = 1000; % Create a sine wave of fc = 1KHz.
fc2 = 1000.5; % Create a sine wave of fc = 1KHz.
fs = 16*fc1; % Sampling frequency
T = 0;%1/fc1;
Tdur = 10 + 0.5*T;%duration of signal in seconds
t = 0:1/fs:Tdur-1/fs; % Time vector of 10 second
v1 = sin(2*pi*t*fc1);
v2 = sin(2*pi*t*fc2);
v = v1 + v2;
nfft = length(v); % Length of FFT
% Take fft, padding with zeros so that length(X) is equal to nfft
V = fft(v,nfft); 
% FFT is symmetric, throw away second half
V_half = V(1:nfft/2);
% Take the magnitude of fft of x
Mag_v = abs(V_half);
% Frequency vector
f = (0:nfft/2-1)*fs/nfft;
%%
X1=fftshift(V); %compute DFT using FFT      
f1=(-nfft/2:nfft/2-1)*fs/nfft; %DFT Sample points 

%%
% Generate the plot, title and labels.

figure(1);
% plot(t,v1,'r')
% hold on 
% plot(t,v2,'b')
% plot(t,v,'g');
title('Sine Wave Signal');
xlabel('Time (s)'); 
ylabel('v = v1+ v2')
legend('v1','v2','v1+v2')

figure(2);
%plot(f1,abs(X1)/max(abs(X1)));
stem(f,Mag_v);
%title('Power Spectrum of a Sine Wave');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
set(gcf, 'color', 'white')
%%
figure(3)

N1 = (round(nfft*(0.995*fc1/fs)):round(nfft*(1.005*fc1/fs)));%the round is for cases such as Part 2
Norm_factor = max(Mag_v);%normalizing factor (to make the maximum at 1 (0 dB)
stem(f(N1),Mag_v(N1)/Norm_factor)
xlabel('0.995*fc1 to 1.005*fc1 (Hz)'); 
ylabel('Normalized magnitude')
set(gcf, 'color', 'white')
figure(4)
plot(f(N1),20*log10(Mag_v(N1)/Norm_factor),'r')
xlabel('0.995*fc1 to 1.005*fc1'); 
ylabel('20*log10(abs(fft(v)/Norm-factor (dB)')
set(gcf, 'color', 'white')