function y = SubspaceAngle(H1,H2,thr)

[U1,S1,V1] = svd(H1);
s1 = diag(S1);
ind1 = cumsum(s1)/sum(s1) < thr;
ind1 = [true;ind1(1:end-1)];

[U2,S2,V2] = svd(H2);
s2 = diag(S2);
ind2 = cumsum(s2)/sum(s2) < thr;
ind2 = [true;ind2(1:end-1)];

y = subspace(U1(:,ind1), U2(:,ind2));

end