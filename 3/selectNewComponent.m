%{
Author: Mehmet Koc
Date: 2/24/14
--------------------------------------------------------------------------
Description: Given K-by-1 component probability mass function, this
function selects a random new component according to this PMF.

Note that componentPMF can be normalized or unnormalized.
%}

function newComponent = selectNewComponent(componentPMF)
% get the cumulative distribution
K = length(componentPMF);
componentCMF = zeros(K+1, 1);
componentCMF(2:end) = cumsum(componentPMF);

randNum = componentCMF(end) * rand(1, 1);
newComponent = find(componentCMF <= randNum, 1, 'last');
end
