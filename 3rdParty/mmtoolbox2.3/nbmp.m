function [X,iter]=nbmp(varargin)

% [X,iter]=NBMP(A1,A2,...,AP) computes the mean defined by Nakamura in [1] 
%  and Bini, Meini and Poloni in [2]
% [X,iter]=NBMP(A{1:p}) for a cell-array input
%
% varargin: positive definite matrix arguments A1,...,AP
% X: the (N)BMP mean of A1,...,AP
% iter: the number of iterations needed by the outer iteration
% 
% References
% [1] K. Nakamura, "Geometric Means of Positive Operators", Kyungpook Math. 
% J. 49 (2009), 167-181.
% [2] D.A. Bini, B. Meini and F. Poloni, "An effective matrix geometric mean
% satisfying the Ando-Li-Mathias properties", Math. Comp. 79 (2010), 437-452.

n=length(varargin{1});
p=nargin;maxiter=1000;
tol=1e-9;

for h=1:p
  A{h}=varargin{h};
end

if (p==2)
  X=sharp(A{1},A{2},1/2);
else
  for k=1:maxiter
        
    for h=1:p
      s=mod(h:h+p-2,p)+1;
      A1{h}=sharp(A{h},nbmp(A{s}),(p-1)/p);
    end
        
    ni=norm(A1{1}-A{1})/norm(A{1});
    if (ni<tol)
      iter=k; break;
    end
    if (k==maxiter)
      disp('Max number of iterations reached');
      iter=k; break;
    end
    for h=1:p
      A{h}=A1{h};
    end
        
  end
    
  % the arithmetic mean trick
  X=A1{1};
  for h=2:p
    X=X+A1{h};
  end
  X=X/p;
    
end