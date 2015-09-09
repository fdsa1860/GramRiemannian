function z_esti = e_step(G, k, cparam, opt)
% Gamma mixture algorithm -- E step
% This function calculates the z_esti(i,j) based on prior, mean and
% theta and kappa

n = length(G);
z_esti = zeros(k,n);    %Initialization

for j=1:k
    prior = cparam(j).prior;
    Gm = cparam(j).Gm;
    alpha = cparam(j).alpha;
    theta = cparam(j).theta;
    J = HHdist(Gm, G, opt.metric);
    z_esti(j,:) = prior * pdf('gamma',J,alpha,theta);
end
z_esti(z_esti<1e-6) = 1e-6;
s = sum(z_esti);
z_esti = bsxfun(@rdivide, z_esti, s);

end