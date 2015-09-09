function y = myHankeletAngle2(seg1,seg2,thr)

%% binlong's hankelet angle

D = size(seg1,2);
assert(size(seg2,2)==D);

nr = 4;
% nc = 4;

Hu1 = hankel_mo(seg1(:,1)',[nr size(seg1,1)-nr+1]);
Hv1 = hankel_mo(seg1(:,2)',[nr size(seg1,1)-nr+1]);
Hu2 = hankel_mo(seg2(:,1)',[nr size(seg2,1)-nr+1]);
Hv2 = hankel_mo(seg2(:,2)',[nr size(seg2,1)-nr+1]);
Hu1_p = Hu1 / (norm(Hu1*Hu1','fro')^0.5);
Hv1_p = Hv1 / (norm(Hv1*Hv1','fro')^0.5);
Hu2_p = Hu2 / (norm(Hu2*Hu2','fro')^0.5);
Hv2_p = Hv2 / (norm(Hv2*Hv2','fro')^0.5);
y = 2-0.5*norm(Hu1_p*Hu1_p'+Hu2_p*Hu2_p', 'fro')-0.5*norm(Hv1_p*Hv1_p'+Hv2_p*Hv2_p', 'fro');

%% estimate order
if nargin == 3
    s1 = svd([Hu1_p Hv1_p]);
    s2 = svd([Hu2_p Hv2_p]);
    ind1 = cumsum(s1)/sum(s1) < thr;
    ind2 = cumsum(s2)/sum(s2) < thr;
    if nnz(ind1) ~= nnz(ind2)
        y = pi/2;
    end
end

end