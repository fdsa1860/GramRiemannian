function G=mean2(A,B,alg)

% G=MEAN2(A,B,alg) computes the geometric mean of two Hermitian positive 
%  definite matrices with various algorithms (the default is based on 
%  the polar decomposition)
%
% A,B: positive definite matrices
% G: the geometric mean of A and B
% alg: the algorithm for computing the geometric mean
% alg='schur' uses the Schur decomposition 
% alg='polar' uses the polar decomposition 
% alg='avera' uses the scaled averaging technique 
%
% Reference
% [1] B. Iannazzo, The geometric mean of two matrices from a computational
% viewpoint, arXiv preprint arXiv:1201.0101, 2011.

n=size(A,1);

if (nargin<3)
  alg='polar';
end

if (strcmp(alg,'schur'))
  G=sharp(A,B,1/2);
end

if (strcmp(alg,'polar'))
  mA=cond(A);mB=cond(B);
  if (mA>mB) % swap A and B if B is better conditioned
    C=A;A=B;B=C;
  end	
  RA=chol(A);
  RB=chol(B);
  
  % computes the polar decomposition of RB/RA
  U=RB/RA;
  stop=0;ct=0;flag=0;
  while (stop==0 && ct<20)
    ct=ct+1;
    iU=inv(U);
    g=sqrt(sqrt(norm(iU,1)/norm(U,1)*norm(iU,'inf')/norm(U,'inf')));
    Un=(g*U+iU'/g)/2;
    if (flag==1)
      stop=1;
    end
    if (norm(Un-U)<1e-10) 
      flag=1;
    end
  U=Un;
  end
  G=RB'*Un*RA;
end

if (strcmp(alg,'avera'))
  mA=cond(A);mB=cond(B);
  if (mA>mB) % swap A and B if B is better conditioned
    C=A;A=B;B=C;
  end	
  X0=inv(A);
  Y0=B;
  stop=0;ct=0;flag=0;
  while (stop==0 && ct<20)
    ct=ct+1;
    g=(det(X0)*det(Y0))^(-1/(2*n));
    X1=(g*X0+inv(g*Y0))/2;
    Y1=(g*Y0+inv(g*X0))/2;        
    if (flag==1)
      stop=1;
    end
    if (norm(X0-X1)<1e-10)
      flag=1;
    end
    X0=X1;Y0=Y1;
  end
  G=Y0;
end