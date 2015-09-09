function [u_hat,eta,x] = hstln_mo(u,R,x0,Omega)
% 
% Hankel Structured Total Least Squares (HSTLN)
%   Fits an order R system to the input vector using HSTLN formula
%       (A+E)x = b+f
%
% Inputs:
%       U:  D times N input vector (D: dimension N: length)
%       R:  order of the fit
%       x0 (Optional):   initial AR coefficients
%       Omega(Optional): 0/1 sampling vector(use this if you miss 
%                        data samples or do not trust some of them)
% Outputs:
%       U_h: D times N output vector (filtered output)
%       eta: corrections (negative estimated noise)
%       x:   AR coefficients
%       
%
%
%   Written by CD, 07/22/11 based on the paper:  
%   I. Park, L. Zhang and J.B. Rosen   "Low rank approximation of
%          a Hankel matrix by structured total least norm" 


% parameters 
% TODO: make them parameters of function so user can change them
tol = 10e-8;
maxiter = 100;
w = 10e8;

[u_D,u_N] = size(u);
nc = R+1;
nr = (u_N-nc+1)*u_D;

% make the input sequence hankel
Ab = hankel_mo(u,[nr nc]);

A = Ab(:,1:end-1);
b = Ab(:,end);


% initializations
if nargin>2 && ~isempty(x0)
    x=x0;
else
    x = A\b;
end    
P1 = [zeros(nr,R*u_D) eye(nr,nr) ];
% P0 = [eye((u_N-1)*u_D) zeros((u_N-1)*u_D,u_D)];

eta = zeros(u_D*u_N,1);

% TRY
% if mod(u_N,2) % odd    
%     d = (1:(u_N+1)/2);
%     d = [d d(end-1:-1:1)];
% else   %even    
%     d = (1:(u_N+1)/2);
%     d = [d d(end:-1:1)];
% end
% d = reshape(repmat(d,[u_D 1]),[1 u_N*u_D]);
% TRY


if nargin>3 && ~isempty(Omega)
    % remember D is multiplying eta
    D = diag(reshape(repmat(Omega,[u_D 1]),size(eta)));
else
    D = eye(u_N*u_D);
%    D = diag(d);
end
%!!!
Yrow = zeros(1,u_D*(u_N-1));



for iter=1:maxiter
    
    % form matrices 
    E   = hankel_mo(reshape(eta,size(u)),[nr nc-1]);
%     E = hankel(eta(1:nr), eta(nr:u_N-1) );
%     Y = toeplitz( [x(1,1);zeros(nr-1,1)], [x; zeros(nr-1,1)] );
    Yrow(1:u_D:u_D*R) = x';
    Y = toeplitz([Yrow(1,1);zeros(nr-1,1)], Yrow );
    % Y*P0 = [Y|0]
    YP0 = [Y zeros(nr,u_D)];
    
    
    f   = eta(end-nr+1:end);
    
    % compute r
    r = b+f - (A+E)*x;
    
    % form M
     M = [ w*(P1-YP0) -w*(A+E);...
           D  zeros(u_N*u_D,R) ];
    
    % solve minimization problem 
    dparam = M\(-[w*r;D*eta]);
    
    % update parameters
    deta = dparam(1:u_N*u_D,1);
    dx   = dparam(u_N*u_D+1:end,1);
    
    eta = eta + deta;
    x = x +dx;
    
    % check convergence
%     norm_func = norm([w*r;D*eta]);
    norm_dparam = norm(dparam);
    
%     fprintf('iteration:%d norm_dparam:%g norm_func:%g\n',iter,norm_dparam,norm_func);
    
    if 0
        figure(11)
%         plot([u' (u+reshape(eta,size(u)))']);
        plot(u','k.');hold on;
        plot(u+reshape(eta,size(u))','g-');
    end
    
    if norm_dparam <tol
        break;
    end    
end
eta = reshape(eta,size(u));
u_hat = u + eta;
% r = r';

if 0
    figure(51)
    plot([u(1,:)' u_hat(1,:)'])    
end

