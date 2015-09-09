function X = unhankel_mo(H,dim)

if nargin<2
    dim=1;
end

[nr,nc] = size(H);

% TODO: Write this averaging unfold part faster

cidx = [0 : nc-1 ];
ridx = [1 : nr]';

I = ridx(:,ones(nc,1)) + dim*cidx(ones(nr,1),:);  % Hankel subscripts 

N = nr/dim + nc - 1;
X = zeros(dim,N);
c = 1;
for j=1:N
    for i=1:dim
        d = [H(I==c)];
        X(i,j) = sum(d)/length(d);
        c = c+1;
    end
end