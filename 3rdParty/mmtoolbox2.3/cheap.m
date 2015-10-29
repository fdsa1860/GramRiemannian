function [X,iter]=cheap(varargin)

% [X,iter]=CHEAP(A1,A2,...,AP) computes the mean defined by Bini and Iannazzo
%  in [1]
% [X,iter]=CHEAP(A{1:p}) for a cell-array input
%
% varargin: positive definite matrix arguments A1,...,AP
% X: the Cheap mean of A1,...,AP
% iter: the number of iterations needed by the outer iteration
% 
% References
% [1] D.A. Bini and B. Iannazzo, "A note on computing matrix geometric 
% means", Adv. Comput. Math., 35-2/4 (2011), pp. 175-192.

n=length(varargin{1});
p=nargin;
tol=1e-9; maxiter=1000;

for h=1:p
  A{h}=varargin{h};
end

for k=1:maxiter
  for h=1:p
    R{h}=chol(A{h});
    RI{h}=inv(R{h});
  end
  for h=1:p
    RI{h}=inv(R{h});
    S=zeros(n);
    for ell=1:p
      if (ell~=h)
        % computes S=S+logm(RI{h}'*A{ell}*RI{h})
        Z=R{ell}*RI{h};
        [U V]=schur(Z'*Z);
        T=U*diag(log(diag(V)))*U';
        S=S+(T+T')/2;
      end
    end
    [U V]=schur(1/p*S);
    T=diag(exp(diag(V))).^(1/2)*U'*R{h};
    A1{h}=T'*T;
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