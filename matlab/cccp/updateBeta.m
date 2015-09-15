function cccp = updateBeta(cccp)

B = cccp.B + cccp.X - cccp.Z;
if cccp.mu < cccp.muMax
    B = B / cccp.rho;
end
cccp.B = B;

end