% Calculate the dynamic distances between any two Hankel matrices
% Input:
%    HHp: the normalized Hankel matrix
%    index: determine which ones as the referent index and then
%              calculate the distances between the referent index and others
%    order_info: the order information (the rank of H)
% Output:
%    D: the distance matrix

% Created by Xiao Zhang
% modified by Xikang Zhang on Sep. 6, 2014, to consider the special case of
% lines, for which H contains all zeros

function D = dynamicDistance(HHp, index, order_info, alpha)

if nargin < 4
    alpha = 1;
end
if nargin < 3
    order_info = [];
end

n = numel(HHp);
m = numel(index);
D = zeros(m, n);

for i = 1:m
    for j = 1:n
        if isempty(order_info)
            D(i, j) = abs(2 - norm(HHp{i} + HHp{j}, 'fro'));
        elseif order_info(index(i)) == 0 || order_info(j) == 0
            D(i, j) = 0;
        else
            D(i, j) = abs(2 - norm(HHp{i} + HHp{j}, 'fro'));
        end
        D(i, j) = D(i, j) + alpha * abs(order_info(index(i)) - order_info(j));
    end
end

end