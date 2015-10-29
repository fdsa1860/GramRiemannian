function [X,iter]=alm(varargin)

% [X,iter]=ALM(A1,A2,...,AP) computes the Ando-Li-Mathias mean 
%  defined in [1]
% [X,iter]=ALM(A{1:p}) for a cell-array input
%
% varargin: positive definite matrix arguments A1,...,AP
% X: the ALM mean of A1,...,AP
% iter: the number of iterations needed by the outer iteration
% 
% Reference
% [1] T. Ando, C.-K. Li and R. Mathias, "Geometric Means", 
% Linear Algebra Appl. 385 (2004), 305-334.

n=length(varargin{1});
p=nargin;
tol=1e-14;maxiter=1000;

for h=1:p
  A{h}=varargin{h};
end

if (p==2)
  X=sharp(A{1},A{2},1/2);
else
  for k=1:maxiter
        
    for h=1:p
      s=mod(h:h+p-2,p)+1;
      A1{h}=alm(A{s});
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