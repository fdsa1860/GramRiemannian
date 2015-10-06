function cccp = updateBeta(cccp)

cccp.B = cccp.B + cccp.X - cccp.Z;
cccp.B = cccp.B / cccp.rho;

end