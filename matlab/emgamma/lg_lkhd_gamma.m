function lg_lkhd = lg_lkhd_gamma (G,k,cparams,opt)

n = length(G);
lkhd = zeros(k,n);
for j=1:k
    prior = cparams(j).prior;
    Gm = cparams(j).Gm;
    alpha = cparams(j).alpha;
    theta = cparams(j).theta;
    J = HHdist(Gm, G, opt.metric);
    lkhd(j,:) = prior * pdf('gamma', J, alpha, theta);
end
l_lkhd = log(sum(lkhd));
lg_lkhd = sum(l_lkhd);

end