function [u_hat,eta,x] = incremental_hstln_mo(u,Rmax,eta_max,Omega)

[u_D,u_N] = size(u);

if nargin<4
    Omega = ones(1,u_N);
    

end
    
u_N_1 = sum(Omega);
    

for R=1:Rmax
    [u_hat,eta,x] = hstln_mo(u,R,'',Omega);
    
    norm_eta = sqrt(sum(sum(eta.^2,1).*Omega));
    if norm_eta/u_N_1 < eta_max
        break;
    end
end