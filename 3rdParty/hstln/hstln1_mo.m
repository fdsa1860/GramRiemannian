function [x,eta,r,iter] = hstln1_mo(u,R,x0)

% u : DxN input signal
% R : order of the system
% x0: (optional) initial estimate of system parameters

% parameters 
% TODO: make them parameters of function so user can change them
tol = 10e-6;
maxiter = 10;
w = 10e8;

[u_D,u_N] = size(u);
nc = R+1;
nr = (u_N-nc+1)*u_D;

% make the input sequence hankel
Ab = mex_hankel_mo(u,[nr nc]);

A = Ab(:,1:end-1);
b = Ab(:,end);


% initializations
if nargin>2
    x=x0;
else
    x = A\b;
end    
P1 = [zeros(nr,R*u_D) eye(nr,nr) ];
% P0 = [eye((u_N-1)*u_D) zeros((u_N-1)*u_D,u_D)];
eta = zeros(u_D*u_N,1);
D = eye(u_N*u_D);
%!!!
Yrow = zeros(1,u_D*(u_N-1));

deta = randn(u_N*u_D,1);
dx   = randn(R,1);




for iter=1:maxiter
    
    % form matrices 
    E   = mex_hankel_mo(reshape(eta,size(u)),[nr nc-1]);
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
    
    % solve minimization problem with l1
    L1_c = [zeros(u_D*u_N+R,1); ones(2*u_D*u_N-R,1)];     % cost
    L1_A = [M -eye(2*u_D*u_N-R); -M -eye(2*u_D*u_N-R)];     % constraints
    L1_b = [ -[w*r;D*eta]  ; [w*r;D*eta] ];                 % .....
    L1_X = linprog(L1_c,L1_A,L1_b);
    dparam = L1_X(1:u_D*u_N+R,1);

%      dparam = M\(-[w*r;D*eta]);
    
    
%     dparam = l1decode_pd([deta;dx],M,[],(-[w*r;D*eta]));
    
    % update parameters
    deta = dparam(1:u_N*u_D,1);
    dx   = dparam(u_N*u_D+1:end,1);
    
    eta = eta + deta;
    x = x +dx;
    
    % check convergence
%     norm_func = norm([w*r;D*eta]);
    norm_dparam = norm(dparam);
    
    fprintf('iteration:%d norm_dparam:%f\n',iter,norm_dparam);
    if 1
        figure(11)
        t_eta = reshape(eta,size(u));
        plot([u' (u+t_eta)']);
    end


    if norm_dparam <tol
        break;
    end    
end
eta = reshape(eta,size(u));
r = r';

