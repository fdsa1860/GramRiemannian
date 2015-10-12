
function [epsilon param] = greedy_switch(data, order, norm_used)

[N T] = size(data);

H = [];

for i = 1:N
    dummy = hankel(data(i,1:order+1),data(i,order+1:T));
    dummy = [ones(1, size(dummy,2));dummy];
    H = cat(3,H,dummy);
end
%keyboard;
cvx_begin
    variable p(N,order+1) %include an affine term
    variable epsilon_eta(N)
    minimize norm(epsilon_eta,2)
    subject to
    for i = 1:N
      norm([p(i,:) 1]*H(:,:,i),norm_used) <= epsilon_eta(i);
    end
cvx_end

epsilon = epsilon_eta;
param = p(:);