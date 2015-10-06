function [dis, Phi, cccp] = gramDist_cccp(G1, G2, opt)

d = size(G1,1);
I = eye(d);
W = (G1 + G2) / 2 + opt.sigma * I;
Y = G1 + opt.sigma * I;
% W = G1 + opt.sigma * I;
% Y = G2 + opt.sigma * I;

cccp = cccpInit(W,Y,opt.epsilon);
cccp = cccpOptimization(cccp);
dis = cccp.optVal;
Phi = cccp.X;

end