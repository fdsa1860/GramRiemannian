function cccp = cccpInit(W,Y,epsilon)

cccp.Y = Y;
cccp.W = W;
cccp.X = zeros(size(W));
cccp.X_pre = inf(size(W));
cccp.Z = zeros(size(W));
cccp.B = zeros(size(W));
cccp.mu = 1;
cccp.muMax = 1e3;
cccp.rho = 1.1;
cccp.epsilon = 3 * epsilon;
cccp.eta = 1e-6; % optimization stop condition
cccp.optVal = inf;

% cccp.X_Pool = {};
% cccp.optVal_Pool = [];

end