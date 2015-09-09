% Calculate the dynamic distances between any two Hankel matrices
% Input:
%    X: data that contains the normalized Hankel matrix
%    alpha: the weight of the order difference in the distance metric
% Output:
%    D: the distance matrix

function D = dynamicDistanceSigma(X, alpha)

if nargin < 2
    alpha = 0;
end

n = numel(X);
D = zeros(n);

for i = 1:n
    X(i).HH = X(i).HH + 1e-6*eye(size(X(i).HH));
end

for i = 1:n
    for j = i+1:n
        if isempty(X(i).sigma) || isempty(X(j).sigma)
%             D(i, j) = abs(2 - norm(X(i).HH + X(j).HH, 'fro'));
            D(i, j) = log(det((X(i).HH+X(j).HH)/2)) - 0.5*log(det(X(i).HH*X(j).HH));
        elseif all(X(i).sigma == 0) || all(X(j).sigma == 0)
            D(i, j) = 0;
        else
%             D(i, j) = abs(2 - norm(X(i).HH + X(j).HH, 'fro'));
            D(i, j) = log(det((X(i).HH+X(j).HH)/2)) - 0.5*log(det(X(i).HH*X(j).HH));
        end
        D(i, j) = D(i, j) + alpha * norm(X(i).sigma - X(j).sigma);
    end
end

D = D + D';

end