int16 binn1;
int16 binn2;
int16 binn3;
int16 binn;
%SamplingFrequenciess
Fs=48000;
Fs1=48000;
Fs2=48000;
Fs3=48000;
%NoOfSamples
samples=[1,Fs];
samples1=[1,Fs1];
samples2=[1,Fs2];
samples3=[1,Fs3];
%Read 4 different audio files for 4 different inputchannel(16bit)
[binn,Fs]=audioread("chimes.wav",samples,"native");
[binn1,Fs1]=audioread("tada.wav",samples1,"native");
[binn2,Fs2]=audioread("notify.wav",samples2,"native");
[binn3,Fs3]=audioread("Windows Notify.wav",samples3,"native");

info=audioinfo('chimes.wav');
info1=audioinfo('tada.wav');
info2=audioinfo('notify.wav');
info3=audioinfo('Windows Notify.wav');
% File to output the bitstream at the rate of 48KHz of merged audio(4
% audios) information
FID1=fopen("Inputaudio2BitStream.txt",'w+');
%File error handling
if FID1 < 0
msgbox(['Cannot read file: ', "Inputaudio2BitStream.txt"],'File Error','Error');
end
%The 4 audio's decimal is converted to  binary format
Data= dec2bin(binn);
Data3= dec2bin(binn1);
Data4= dec2bin(binn2);
Data5= dec2bin(binn3);
a=1;
b=1;
c=1;
d=1;
%while loop that 12000 times, each time 4 different audio file's 16bit
% information is written consecutively to form a total of 48000bits     )
while a < 750*16
for k= a:(16+(a-1))
FinalData=Data(a:k);
fprintf(FID1,FinalData);
fprintf(FID1,'\n');
a=a+1;
end
for l=b:(16+(b-1))
FinalData=Data3(b:l);
fprintf(FID1,FinalData);
fprintf(FID1,'\n');
b=b+1;
end
for m=c:(16+(c-1))
FinalData=Data4(c:m);
fprintf(FID1,FinalData);
fprintf(FID1,'\n');
c=c+1;
end
for n=d:(16+(d-1))
FinalData=Data5(d:n);
fprintf(FID1,FinalData);
fprintf(FID1,'\n');
d=d+1;
end
end
fclose(FID1);