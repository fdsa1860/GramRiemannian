function y = hankeletAngle(seg1,seg2,thr)

%% binlong's hankelet angle

D = size(seg1,2);
assert(size(seg2,2)==D);

% nr = 4;
nc = 10;

% % take out mean
% seg1 = bsxfun(@minus, seg1, mean(seg1));
% seg2 = bsxfun(@minus, seg2, mean(seg2));

% H1 = hankel_mo(seg1',[nr size(seg1,1)-nr/D+1]);
% H2 = hankel_mo(seg2',[nr size(seg2,1)-nr/D+1]);
H1 = hankel_mo(seg1',[(size(seg1,1)-nc+1)*D, nc]);
H2 = hankel_mo(seg2',[(size(seg2,1)-nc+1)*D, nc]);

H1_p = H1 / (norm(H1'*H1,'fro')^0.5);
H2_p = H2 / (norm(H2'*H2,'fro')^0.5);

% y = 2 - norm(H1_p*H1_p' + H2_p*H2_p', 'fro');
y = 2 - norm(H1_p'*H1_p + H2_p'*H2_p, 'fro');

%% estimate order
if nargin == 3
    s1 = svd(H1_p);
    s2 = svd(H2_p);
    ind1 = cumsum(s1)/sum(s1) < thr;
    ind2 = cumsum(s2)/sum(s2) < thr;
    if nnz(ind1) ~= nnz(ind2)
        y = pi/2;
    end
end

end