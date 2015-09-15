function cccp = updateMu(cccp)

cccp.mu = cccp.mu * cccp.rho;
if cccp.mu > cccp.muMax
    cccp.mu = cccp.muMax;
end

end