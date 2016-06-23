theta = pi/30;
reg = conv([1 -2*cos(theta) 1],[1 1]);
reg = reg/reg(1);
sysOrd = length(reg)-1;
L = 100;
y = zeros(1,sysOrd+L);
y(1:sysOrd) = rand(1,sysOrd);
for i = 1:L
    y(sysOrd+i) = -fliplr(reg(2:end))*y(i:sysOrd+i-1)';
end
% Hy = blockHankel(y,sysOrd+1,30);
Hy1 = blockHankel(y(1:50),[4,22]);
Hy2 = blockHankel(y(51:100),[4,22]);
G1 = Hy1*Hy1'+1e-4*eye(size(Hy1,1));
G2 = Hy2*Hy2'+1e-4*eye(size(Hy2,1));

% nG1 = G1/norm(G1,'fro') + 1e-4*eye(size(G1));
% nG2 = G2/norm(G2,'fro') + 1e-4*eye(size(G2));
L1 = chol(G1+1e-4*eye(size(G1)));
L2 = chol(G2+1e-4*eye(size(G1)));
L12 = chol((G1+G2)/2+1e-4*eye(size(G1)));
dist1 = sum(log(diag(L12)))*2-sum(log(diag(L1)))-sum(log(diag(L2)));
dist1 = log(det((G1+G2)/2+1e-4*eye(size(G1))))-0.5*log(det(G1+1e-4*eye(size(G1))))-0.5*log(det(G2+1e-4*eye(size(G1))));
dist2 = log(det((nG1+nG2)/2+1e-4*eye(size(nG1))))-0.5*log(det(nG1+1e-4*eye(size(nG1))))-0.5*log(det(nG2+1e-4*eye(size(nG1))));
%%
theta2 = pi/10;
reg2 = conv([1 -2*cos(theta2) 1],[1 -0.3]);
reg2 = reg2/reg2(1);
sysOrd2 = length(reg2)-1;
L2 = 50;
y2 = zeros(1,sysOrd2+L2);
y2(1:sysOrd2) = randn(1,sysOrd2);
for i = 1:L2
    y2(sysOrd2+i) = -fliplr(reg2(2:end))*y2(i:sysOrd2+i-1)';
end
Hy2 = blkhankel(y2,sysOrd2+1);
Hy12 = blkhankel(y2(1:25),sysOrd2+1);
Hy22 = blkhankel(y2(26:50),sysOrd2+1);
G12 = Hy12*Hy12';
G22 = Hy22*Hy22';

dist112 = log(det((G1+G12)/2+1e-4*eye(size(G1))))-0.5*log(det(G1+1e-4*eye(size(G1))))-0.5*log(det(G12+1e-4*eye(size(G1))));
dist212 = log(det((G2+G12)/2+1e-4*eye(size(G2))))-0.5*log(det(G2+1e-4*eye(size(G2))))-0.5*log(det(G12+1e-4*eye(size(G1))));