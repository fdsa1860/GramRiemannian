function d = LERM(X,Y)

d = norm(logm(X) - logm(Y), 'fro');

end
