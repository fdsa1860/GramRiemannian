function cccp = cccpOptimization(cccp)

while norm(cccp.X-cccp.X_pre)>cccp.eta
    cccp = updateX(cccp);
    cccp = updateZ(cccp);
    cccp = updateBeta(cccp);
end

end