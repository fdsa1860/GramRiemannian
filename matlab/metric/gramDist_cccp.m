function dis = gramDist_cccp(G1, G2)

d = size(G1,1);
I = eye(d);
W = G1 + G2 + sigma * I;
Y = G1 + sigma * I;



cccp = cccpInit(I);
cccp = cccpOptimization(cccp);

end