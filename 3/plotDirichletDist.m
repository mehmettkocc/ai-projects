%{
Author: Mehmet Koc
Date: 2/25/14
--------------------------------------------------------------------------
Description: Given the Dirichlet probability distribution parameter alpha
(3-by-1 vector), this function plots p(x; alpha) for x=[x1, x2, x3]. Note
that x has DOF=2 since sum_{i}(x_i)=1
%}

function plotDirichletDist (alpha)
precision = 0.01; 
pointNum = ceil(1/precision) + 1;

% normalization constant
Z = prod(gamma(alpha))/gamma(sum(alpha));

[x1, x2] = ndgrid(linspace(0, 1, pointNum), linspace(0, 1, pointNum));
x3 = 1 - x1 - x2;
bad = (x1+x2 >= 1); x1(bad) = NaN; x2(bad) = NaN; x3(bad) = NaN;

y = (x1.^(alpha(1)-1) .* x2.^(alpha(2)-1) .* x3.^(alpha(3)-1)) / Z;

surf(x1, x2, y,'EdgeColor', 'none');
xlabel('x1'); ylabel('x2'); zlabel('p(x; \alpha)');
title(['\alpha = [', num2str(alpha'), ']']);
view(-160,40);

%rotate3d on;

end