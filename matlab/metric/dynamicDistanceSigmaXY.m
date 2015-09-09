% Calculate the dynamic distances between any two Hankel matrices
% Input:
%    X: data that contains the normalized Hankel matrix
%    alpha: the weight of the order difference in the distance metric
% Output:
%    D: the distance matrix

function D = dynamicDistanceSigmaXY(X, alpha)

if nargin < 2
    alpha = 0;
end

n = numel(X);
D = zeros(n);

for i = 1:n
    for j = i+1:n
        if isempty(X(i).sigma) || isempty(X(j).sigma)
            D(i, j) = abs(2-0.5*norm(X(i).HHx+X(j).HHx,'fro')-0.5*norm(X(i).HHx+X(j).HHx,'fro'));
        elseif all(X(i).sigma == 0) || all(X(j).sigma == 0)
            D(i, j) = 0;
        else
            D(i, j) = abs(2-0.5*norm(X(i).HHx+X(j).HHx,'fro')-0.5*norm(X(i).HHx+X(j).HHx,'fro'));
        end
        D(i, j) = D(i, j) + alpha * norm(X(i).sigma - X(j).sigma);
    end
end

D = D + D';

end