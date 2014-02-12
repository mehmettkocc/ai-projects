function fj = lowFeatures(yi,yii,x,k)
%LOWFEATURES This function computes f_j.
%   Detailed explanation goes here

j = 9; % number of feature functions
%ySet = {'COMMA', 'PERIOD' , 'QUESTION_MARK', 'EXCLAMATION_POINT', 'COLON', 'SPACE'};
fj = zeros(j,1);

fj(1) = ffTempA(x,k,'dt')*ffTempB(yi,6);
fj(2) = ffTempA(x,1,'wrb')*ffTempB(yi,3);
fj(3) = ffTempA(x,k,'prp')*ffTempB(yi,6);
fj(4) = ffTempA(x,k,'jjr')*ffTempB(yi,6);
fj(5) = ffTempA(x,k,'vbd')*ffTempB(yi,6);
fj(6) = ffTempA(x,1,'md')*ffTempB(yi,3);
fj(7) = ffTempA(x,1,'vbp')*ffTempB(yi,3);
fj(8) = ffTempA(x,1,'wp')*ffTempB(yi,3);
fj(9) = ffTempA(x,1,'prp')*ffTempB(yi,6);
%dummy features instead of having 36*36*2*2 feature functions for speed at
%this initial stage
end

% ------------------------------------------------------------------------
% feature function template helpers

function b = ffTempB(yi,label)
    b = (yi==label);
end

function b = ffTempB2(yi,yii,labeli,labelii)
    b = ((yi==labeli)&&(yii==labelii));
end

function a = ffTempA(x,k,posTag)
    a = strcmpi(x{1}(k),posTag);
end

function a = ffTempA2(x,k,posGroup)
    a = sum(ismember(posGroup,x{1}(k)));
end