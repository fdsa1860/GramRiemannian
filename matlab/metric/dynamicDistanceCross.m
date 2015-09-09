function D = dynamicDistanceCross(HHp1, HHp2, order_info1, order_info2, alpha)

if nargin < 5
    alpha = 1;
end
if nargin < 3
    order_info1 = [];
    order_info2 = [];
end

m = numel(HHp1);
n = numel(HHp2);
D = zeros(m, n);

for i = 1:m
    for j = 1:n
        if isempty(order_info1) || isempty(order_info2)
            D(i, j) = abs(2 - norm(HHp1{i} + HHp2{j}, 'fro'));
        elseif order_info1(i) == 0 || order_info2(j) == 0
            D(i, j) = 0;
        else
            D(i, j) = abs(2 - norm(HHp1{i} + HHp2{j}, 'fro'));
        end
        D(i, j) = D(i, j) + alpha * abs(order_info1(i) - order_info2(j));
    end
end

end