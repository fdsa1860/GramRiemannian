function y = mySubspaceAngle_vel(seg1,seg2,thr)

D = size(seg1,2);
assert(size(seg2,2)==D);

% nr = 8;
nc = 4;

v1 = diff(seg1);
v2 = diff(seg2);

% % gauss filter
% sigma = 2;
% winSize = 10;
% x = linspace(-winSize / 2, winSize / 2, winSize);
% G = exp(-x .^ 2 / (2 * sigma ^ 2));
% G = G / sum(G);
% DOG = (-x / sigma ^ 2) .* G;
% % DOG = conv(G,[1 0 -1],'same');
% v1 = conv2(seg1', DOG, 'valid')';
% v2 = conv2(seg2', DOG, 'valid')';

% H1 = hankel_mo(v1',[nr size(v1,1)-nr/2+1]);
H1 = hankel_mo(v1',[(size(v1,1)-nc+1)*D, nc]);
% seg1 = seg1 - repmat(mean(seg1),size(seg1,1),1);
% H1 = hankel_mo(seg1',[nr size(seg1,1)-nr/2+1]);

% dc1 = kron(ones(nr/2,1),[1;0]);
% dc2 = kron(ones(nr/2,1),[0;1]);
% for i = 1:size(H1,2)
%     temp = H1(:,i);
%     temp = temp - (temp'*dc1)/(dc1'*dc1)*dc1 - (temp'*dc2)/(dc2'*dc2)*dc2;
%     temp = temp/norm(temp);
%     H1(:,i) = temp;
% end
% H1 = H1/sqrt(size(H1,2));

[U1,S1,V1] = svd(H1);
s1 = diag(S1);
ind1 = cumsum(s1)/sum(s1) < thr;
ind1 = [true;ind1(1:end-1)];


% H2 = hankel_mo(v2',[nr size(v2,1)-nr/2+1]);
H2 = hankel_mo(v2',[(size(v2,1)-nc+1)*D, nc]);
% seg2 = seg2 -  repmat(mean(seg2),size(seg2,1),1);
% H2 = hankel_mo(seg2',[nr size(seg2,1)-nr/2+1]);

% for i = 1:size(H2,2)
%     temp = H2(:,i);
%     temp = temp - (temp'*dc1)/(dc1'*dc1)*dc1 - (temp'*dc2)/(dc2'*dc2)*dc2;
%     temp = temp/norm(temp);
%     H2(:,i) = temp;
% end
% H2 = H2/sqrt(size(H2,2));

[U2,S2,V2] = svd(H2);
s2 = diag(S2);
ind2 = cumsum(s2)/sum(s2) < thr;
ind2 = [true;ind2(1:end-1)];
if nnz(ind1)==nnz(ind2)
    y = subspace(V1(:,ind1),V2(:,ind2));
else
    y = pi/2;
end

% ind = ind1 | ind2;
% y = subspace(U1(:,ind),U2(:,ind));

end