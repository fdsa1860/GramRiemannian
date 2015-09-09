function cccp = cccpInit(I)

cccp.X = I;
cccp.Y = I;
cccp.W = I;
cccp.Z = I;
cccp.B = zeros(size(I));
cccp.mu = 1;
cccp.rho = 1.1;
cccp.eta = 1; % optimization stop condition

cccp.X_pre = zeros(d);

end