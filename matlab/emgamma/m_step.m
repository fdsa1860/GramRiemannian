function cparam = m_step(G,z,cparam,opt)
% Gamma mixture algorithm -- M step

% function m_step calculates mu, covariance, and prior according to z(i,j)

n = size(z,2);
k = size(z,1);

% [~,ind] = max(z);

for j=1:k    
    prior = sum(z(j,:),2) / n;
    w = z(j,:) / (n * prior);
    Gm = karchermean_weighted(G, w);
%     Gm = BhattacharyyaMean_weighted(G{1:end},w);
    dist = HHdist(cparam(j).Gm, G, opt.metric);
    alpha = esti_alpha(dist, z(j,:), prior);
    theta = (z(j,:)*dist')/(alpha*prior*n);

%     prior = nnz(ind==k) / n;
% %     cparam(j).Gm{1} = BhattacharyyaMean(G{1:end});
%     Gm = karcher(G{1:end});
%     dist = HHdist(cparam(j).Gm, G, opt.metric);
%     param = gamfit(dist);
%     alpha = param(1);
%     beta = param(2);

    cparam(j).prior = prior;
    cparam(j).Gm{1} = Gm;
    cparam(j).alpha = alpha;
    cparam(j).theta = theta;
end

end
        