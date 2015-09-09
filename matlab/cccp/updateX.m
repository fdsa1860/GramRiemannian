function cccp = updateX(cccp)

M = 2*(cccp.W-cccp.X+cccp.Y) - 2*cccp.mu*(cccp.W-cccp.Z+cccp.B);
[V,D] = eig(M);
d = diag(D);
sig = ((d.^2+8*cccp.mu).^0.5 - d)/(4*cccp.mu);
Sigma = diag(sig);
S = V*Sigma*V';
cccp.X = cccp.W - S;

end