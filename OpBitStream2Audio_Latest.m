Fs=48000;
FID=fopen("LatestOutputFile.txt",'rb');
if FID < 0
msgbox(['Cannot read file: ', "LatestOutputFile.txt"],'File Error','Error');
end
FID1=fopen("RemoveNewLine",'a+');
if FID1 < 0
msgbox(['Cannot read file: ', "RemoveNewLine"],'File Error','Error');
end
%removing 'new line'
Data=fgetl(FID);
fprintf(FID1,Data);
i=1;
while ischar(Data)
Data=fgetl(FID);
fwrite(FID1,Data);
i=i+1;
end
%scanning the 24bit information as signed integer
B=fscanf(FID1,'%24d',[1,inf]);
%writing the data in audio format
audiowrite("Audio_Output.wav",B,Fs);

