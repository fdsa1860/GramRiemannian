% draw an curve surface

sigma = 1;
x = -1:0.01:1;
y = -1:0.01:1;
[xx,yy] = meshgrid(x,y);
zz = exp(-(xx.^2+yy.^2)/(2*sigma));
surf(xx,yy,zz);
grid off;
axis off;