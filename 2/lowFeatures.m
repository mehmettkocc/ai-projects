function fj = lowFeatures(yi,yii,x,k)
%LOWFEATURES This function computes f_j.
%   Detailed explanation goes here

j = 46; % number of feature functions
%ySet = {'COMMA', 'PERIOD' , 'QUESTION_MARK', 'EXCLAMATION_POINT', 'COLON', 'SPACE'};
fj = zeros(j,1);

fj(1) = ffTempA2(x,k,{'DT','CC','JJ','PRP','JJR','LS','TO','POS','VBD','IN'})*ffTempB(yi,6);
fj(2) = ffTempA2(x,1,{'WRB','WP','WDT','WP$','MD','VBP'})*ffTempB3(yi,3,x,k);
fj(3) = ffTempA(x,k,'PRP')*ffTempB(yii,1);
fj(4) = ffTempA(x,k,'CC')*ffTempB(yii,1);
fj(5) = ffTempA(x,k,'RB')*ffTempB(yi,1);
fj(6) = ffTempA3(x,k)*ffTempB(yi,6);
fj(7) = ffTempA3(x,k)*ffTempB(yi,1);
fj(8) = ffTempA3(x,k)*ffTempB(yi,5);
fj(9) = ffTempA3(x,k)*ffTempB(yi,2);
fj(10) = ffTempA4(x,k,'VB','IN')*ffTempB(yi,6);
count = 11;
for i=1:6
   for j=1:6
       fj(count) = ffTempB2(yi,yii,i,j);
       count=count+1;
   end
end
end

% ------------------------------------------------------------------------
% feature function template helpers

function b = ffTempB(yi,label)
    b = (yi==label);
end

function b = ffTempB2(yi,yii,labeli,labelii)
    b = ((yi==labeli)&&(yii==labelii));
end

function b = ffTempB3(yi,label,x,k)
    b = ((yi==label)&&(k==length(x{1})));
end

function a = ffTempA(x,k,posTag)
    a = strcmpi(x{1}(k),posTag);
end

function a = ffTempA2(x,k,posGroup)
    a = sum(ismember(posGroup,x{1}(k)));
end

function a = ffTempA3(x,k)
    a = (length(x{1})==k);
end

function a = ffTempA4(x,k,pos1,pos2)
    if(k~=1)
        a = (strcmpi(x{1}(k),pos1)&&strcmpi(x{1}(k-1),pos2));
    else
        a = 0;
    end
end