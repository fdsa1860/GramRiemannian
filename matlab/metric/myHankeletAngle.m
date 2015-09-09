function y = myHankeletAngle(seg1,seg2,thr)

%% my hankelet angle

D = size(seg1,2);
assert(size(seg2,2)==D);

nr = 16;
dc1 = kron(ones(nr/2,1),[1;0]);
dc2 = kron(ones(nr/2,1),[0;1]);

H1 = hankel_mo(seg1',[nr size(seg1,1)-nr/D+1]);
for i = 1:size(H1,2)
    temp = H1(:,i);
    temp = temp - (temp'*dc1)/(dc1'*dc1)*dc1 - (temp'*dc2)/(dc2'*dc2)*dc2;
    temp = temp/norm(temp);
    H1(:,i) = temp;
end
H1 = H1/sqrt(size(H1,2));

H2 = hankel_mo(seg2',[nr size(seg2,1)-nr/D+1]);
for i = 1:size(H2,2)
    temp = H2(:,i);
    temp = temp - (temp'*dc1)/(dc1'*dc1)*dc1 - (temp'*dc2)/(dc2'*dc2)*dc2;
    temp = temp/norm(temp);
    H2(:,i) = temp;
end
H2 = H2/sqrt(size(H2,2));

% H1_p = bsxfun(@rdivide, H1, sqrt(sum(H1.^2))) / sqrt(size(H1,2));
% H2_p = bsxfun(@rdivide, H2, sqrt(sum(H2.^2))) / sqrt(size(H2,2));
H1_p = H1/norm(H1,'fro');
H2_p = H2/norm(H2,'fro');
[U1,S1,V1] = svd(H1_p);
[U2,S2,V2] = svd(H2_p);
y = 1 - sum(sum(((U1*sqrt(S1))'*(U2*sqrt(S2))).^2));


%% estimate order
if nargin == 3
    s1 = svd(H1_p);
    s2 = svd(H2_p);
    ind1 = cumsum(s1)/sum(s1) < thr;
    ind2 = cumsum(s2)/sum(s2) < thr;
    if nnz(ind1) ~= nnz(ind2)
        y = 1;
    end
end

end