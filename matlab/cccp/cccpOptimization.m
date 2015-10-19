function cccp = cccpOptimization(cccp)

while norm(cccp.X-cccp.X_pre)>cccp.eta && cccp.mu < cccp.muMax
    cccp = updateX(cccp);
%     cccp = updateX_concave(cccp);
    cccp = updateZ(cccp);
    cccp = updateBeta(cccp);
    cccp = updateMu(cccp);
    A = cccp.W-cccp.X;
    B = cccp.Y;
    cccp.optVal = log(det(0.5*A+0.5*B))-0.5*log(det(A))-0.5*log(det(B));
%     cccp.optVal
%     cccp.X_Pool{end+1} = cccp.X;
%     cccp.optVal_Pool(end+1) = cccp.optVal;
end

end