function X=explog(varargin)

% X=EXPLOG(A1,A2,...,AP) computes the explog mean 
%  exp(1/P*(log(A1)+...+log(AP)))
%
% varargin: positive definite matrix arguments A1,...,AP
% X: the explog mean of A1,...,AP

n=length(varargin{1});
p=nargin;

S=zeros(n);
for k=1:p
  S=S+logm(varargin{k});
end
X=expm(1/p*S);