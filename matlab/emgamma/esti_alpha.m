
function k = esti_alpha(x, ez, prior)

% estimate k or alpha
% solve the equation:
% log(alpha)-psi(alpha) = log(sum( E(z_(ij)) * x_i )
% - (1/pi_j) * sum( E(z_{ij} * log(x_i) ) - log(pi_j)

% reference from wikipedia "gamma distribution"

iter_max = 1000;
tol = 1e-6;

N = length(ez);
s = log(ez*x')-ez*log(x')/(prior*N)-log(prior*N);
k0 = (3-s+sqrt((s-3)^2+24*s))/(12*s);
e0 = log(k0)-psi(k0)-s;

k = k0;
e = e0;
for iter = 1:iter_max
    fprintf('estimate alpha iter is %d ...\n',iter);
    k = k - e/(1/k-psi(1,k));
    e = log(k)-psi(k)-s;
    if abs(e) < tol
        break;
    end
end

end