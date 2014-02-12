fid = fopen('data/testLabelsProcessed.txt');
line1 = fgetl(fid);
res=line1;
while ischar(line1)
line1 = fgetl(fid);
res = char(res,line1);
end
fclose(fid);
for k=1:size(res,1)
  Ytest{k}=str2num(res(k,:));
end
fid = fopen('data/trainingLabelsProcessed.txt');
line1 = fgetl(fid);
res=line1;
while ischar(line1)
line1 = fgetl(fid);
res = char(res,line1);
end
fclose(fid);
for k=1:size(res,1)
  Xtest{k}=str2num(res(k,:));
end
X = importdata('data/posTraining.txt');
actX = cell(size(X,1),1);
for k=1:size(X,1)
   sd = textscan(X{k,1},'%s');
   data = cellstr(sd{1});
  % data = data';
   actX{k} = data;
end
X = actX;
Xtest = importdata('data/posTest.txt');
actX = cell(size(Xtest,1),1);
for k=1:size(Xtest,1)
   sd = textscan(Xtest{k,1},'%s');
   data = cellstr(sd{1});
  % data = data';
   actX{k} = data;
end
Xtest = actX;