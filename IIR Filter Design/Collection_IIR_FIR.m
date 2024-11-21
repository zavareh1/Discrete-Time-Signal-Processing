%HW5 of DSP course (by Dr. Bob Hay): IIR and FIR filter design
%This piece of code is written by: Zavareh Bozorgasl in Dec. 2022
clc
clear 
%% , LPF, BPF: FIR (Kaiser, Equiripple), IIR (Butterworth, Chebyschev I,Chebyschev II, Elliptic)
Type1 = {'lowpassiir','lowpassfir'}; Type2 = {'bandpassiir', 'bandpassfir'}; 
Desginmethod1 ={'kaiserwin','equiripple'};Desginmethod2 = {'butt','cheby1','cheby2','ellip'};
%.....................................................................................
IIR_FIR = input('Specify type of the filter. IIR = 1 or FIR = 2? ');%1 shows IIR, and 2 shows FIR
LPF_BPF = input('Specify LPF = 1 or BPF1 = 2 or BPF2 = 3? ');%1 shows LPF, 2 shows BPF1, 3 shows BPF2

if IIR_FIR == 1 %If you chose IIR, then, you have to chose one of the 4 given methods
    fprintf('Determine the type of filter: Butt: 1, Cheby 1: 2, Cheby 2: 3, Ellip: 4\n');
    IIR_Type = input('Specify type of the filter  ');
else  %If you chose FIR, then, you have to chose one of the 2 given methods
    fprintf('Determine the type of filter: Kaiser win: 1 , Equiripple : 2\n');
    FIR_Type = input('Specify type of the filter  ');
end

if LPF_BPF == 2  %Spec. of BPF 1 as given in the question
   Fstop1 = 8000;%Lower stop frequency (Hz) <=8 kHz
   Fpass1 = 10000;%Passband frequency (Hz)  >=10 kHz
   Fpass2 = 20000;%Passband frequency (Hz)
   Fstop2 = 22000;%Upper stop frequency (Hz) >=22 kHz
   Astop1 = 65;%Stopband attenuation (>= 65 ) dB
   Apass  = 0.5; %Passbadn ripple 0.5 dB
   Astop2 = 65;%Stopband attenuation (>= 65 ) dB
   Fs =  60000;%Sampling frequency (samples/second or Hz)
elseif LPF_BPF == 3 %Spec. of BPF 2 by changing Fstop1 and Fstop2
   Fstop1 = 9000;%Lower stop frequency (Hz) <=9 kHz
   Fpass1 = 10000;%Passband frequency (Hz)  >=10 kHz
   Fpass2 = 20000;%Passband frequency (Hz)
   Fstop2 = 21000;%Upper stop frequency (Hz) >=kHz
   Astop1 = 65;%Stopband attenuation (>= 65 ) dB
   Apass  = 0.5; %Passbadn ripple 1 dB
   Astop2 = 65;%Stopband attenuation (>= 65 ) dB
   Fs =  60000;%Sampling frequency (samples/second or Hz)
    
else %Spec. of LPF
    Fpass = 20000;%Passband frequency (Hz) or 20 kHz
    Fstop = 24000;%Stopband frequency (Hz) or 24 kHz
    Apass = 0.5;%Passband ripple (dB)
    Astop = 65;%Stopband attenuatution (dB)
    Fs = 60000;%Sampling frequency (samples/second or Hz) or 60 kSamples/second

end
%%
%Now we have to design the filter based on the given information.
if LPF_BPF == 1
    if IIR_FIR == 1
        %LPF, IIR
        IIR_filt = designfilt(Type1{1} , ...
         'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
         'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
         'DesignMethod',Desginmethod2{IIR_Type},'SampleRate',Fs);  
         [b,a] = sos2tf(IIR_filt.Coefficients); %SOS to numerator and denominator
          IIR = dsp.IIRFilter('Numerator',b,...
           'Denominator',a,'Structure','Direct form II');%Specify the configuration (Direct form I or II)
          cost(IIR) % Cost of the filter
          %info(IIR_filt)
          [z,p,k] = zpk(IIR_filt);%Zero poles of IIR filter
          Max_radius = max(abs(p))% The maximum radius of the poles 
          Dis_circle = 1- Max_radius       %Distance to the unit circle for the pole with max radius
          grp_samples = max(grpdelay(IIR_filt))% Computing the number of samples of group delay
          grp_time = (max(grpdelay(IIR_filt))/Fs)*10^6 % Converting the samples to microSeconds
          
          fvtool(IIR_filt)
    else      
        %LPF, FIR
        FIR_filt = designfilt(Type1{2} , ...
         'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
         'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
         'DesignMethod',Desginmethod1{FIR_Type},'SampleRate',Fs);
          FIR = dsp.FIRFilter(FIR_filt.Coefficients);
          cost(FIR)% Cost of the filter
          grp_samples = max(grpdelay(FIR_filt))% Computing the number of samples of group delay
          grp_time = (max(grpdelay(FIR_filt))/Fs)*10^6 % Converting the samples to microSeconds
          
          fvtool(FIR_filt)
    end
else
  if IIR_FIR == 1
     %BPF, IIR
    IIR_filt = designfilt(Type2{1}, ...
    'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
    'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
    'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
    'StopbandAttenuation2',Astop2, ...
    'DesignMethod',Desginmethod2{IIR_Type},'SampleRate',Fs);
         [b,a] = sos2tf(IIR_filt.Coefficients); %SOS to numerator and denominator
          IIR = dsp.IIRFilter('Numerator',b,...
           'Denominator',a,'Structure','Direct form II');%Specify the configuration (Direct form I or II)
          cost(IIR) % Cost of the filter
          %info(IIR_filt)
          [z,p,k] = zpk(IIR_filt);%Zero poles of IIR filter
          Max_radius = max(abs(p))% The maximum radius of the poles 
          Dis_circle = 1- Max_radius       %Distance to the unit circle for the pole with max radius
          grp_samples = max(grpdelay(IIR_filt))% Computing the number of samples of group delay
          grp_time = (max(grpdelay(IIR_filt))/Fs)*10^6 % Converting the samples to microSeconds
          
          fvtool(IIR_filt)
  else
      %BPF, FIR
     FIR_filt = designfilt(Type2{2}, ...
    'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
    'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
    'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
    'StopbandAttenuation2',Astop2, ...
    'DesignMethod',Desginmethod1{FIR_Type},'SampleRate',Fs);    
     FIR = dsp.FIRFilter(FIR_filt.Coefficients);
     cost(FIR)% Cost of the filter
     grp_samples = max(grpdelay(FIR_filt))% Computing the number of samples of group delay
     grp_time = (max(grpdelay(FIR_filt))/Fs)*10^6 % Converting the samples to microSeconds
     
     fvtool(FIR_filt)
    end
end






