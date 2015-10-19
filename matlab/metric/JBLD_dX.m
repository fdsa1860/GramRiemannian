function dJdX = JBLD_dX(X, Y)

dJdX = X * inv(X+Y) * X - X / 2;

end