function A=random(n,alg,par)

% A=RANDOM(n,alg,par) generates a random matrix with different algorithms
% 
% alg: 0 random positive matrix
%      1 random positive matrix with norm 1
%      2 random positive matrix with condition number par

if (nargin<2)
  alg=0;
end
if (nargin<3)
  par=1d1;
end

switch (alg)
case 0 
  W=randn(n);A=sqrtm(W*W');A=(A+A')/2;
case 1
  W=randn(n)-rand(n);W=W*W';A=W/norm(W);A=(A+A')/2;
case 2
  W=rand(n)-rand(n);X=W'*W;
  X=X-eye(n)*min(eig(X));X=X/norm(X);
  X=X+eye(n)/(par-1);A=X/norm(X);
otherwise
  error('This is impossible')
end