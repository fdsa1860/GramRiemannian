function cccp = updateZ(cccp)

Z = cccp.X + cccp.B;
I = eye(size(Z));
[V,D] = eig(Z,I);
d = diag(D);
d(d<0) = 0;
Sigma = diag(d);
Z = V*Sigma*V';
Z = (Z + Z') / 2;

h = norm(Z);
if h > cccp.epsilon
    scale = cccp.epsilon / h;
    Z = Z * scale;
end

cccp.Z = Z;

end