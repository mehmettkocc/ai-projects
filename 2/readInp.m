fid = fopen('data/testLabelsProcessed.txt');
line1 = fgetl(fid);
res=line1;
while ischar(line1)
line1 = fgetl(fid);
res =char(res,line1);
end
fclose(fid);
for k=1:size(res,1)
  A{k}=str2num(res(k,:));
end