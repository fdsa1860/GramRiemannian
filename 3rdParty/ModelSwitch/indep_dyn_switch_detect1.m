
function [x group] = indep_dyn_switch_detect1(data,norm_used,epsilon,order,draw)

%without offset
[num_frame num_pc] = size(data);
num_frame = num_frame -order;
%assume all coordinates evolve with independent dynamics


%num_pc = num_pc*order;
M1 = [zeros(num_frame,1) -eye(num_frame)];
M1 = eye(num_frame)+M1(:,1:end-1);
M1 = sparse(M1(1:end-1,:));
M1 = kron(M1,eye(num_pc*order));

%  S = SPARSE(i,j,s,m,n,nzmax)
A = sparse([],[],[],num_pc*num_frame,order*num_pc*num_frame);
%A=zeros(num_pc*num_frame,order*num_pc*num_frame);
rcount = 1;
ccount = 1;
for i = 1:num_frame
    for j = 1:num_pc
        A(rcount,ccount:ccount+order-1) = data(i:i+order-1,j)';
        rcount = rcount+1;
        ccount = ccount+order;
    end
end

rhs = data(order+1:num_frame+order,:)';
rhs = rhs(:);
W = ones(num_frame-1,1);
num_param = num_frame*order;
%keyboard;
delta = 10^-5;
nnzs = [];
cvx_quiet(true);
conv_criteria = 3;
for k = 1:100
    cvx_begin
    variable x_log(num_param)
    variable z(num_frame-1)
    mx_log = reshape(x_log,[order,num_frame]);
    mx_log = repmat(mx_log,num_pc,1);
    mx_log = mx_log(:);
    c = reshape(abs(M1*mx_log),[num_pc*order,num_frame-1]);
    minimize( sum( W.*z ) )
    subject to
    z >= max(c)';
    norm(A*mx_log - rhs,norm_used) <= epsilon;
    cvx_end
    
    if ~isempty(findstr(cvx_status,'Failed'))
        if exist('z_pre')
            x_log=x_log_pre;
            z=z_pre;
            break;
        else
            display('Solver Failed!');group =[];x=[]; return;
        end
    else
        x_log_pre=x_log;
        z_pre=z;
    end
    
    % display new number of nonzeros in the solution vector
    nnz = length(find( z > delta ));
    nnzs = [nnzs nnz];
    fprintf(1,'   found a solution with %d nonzeros...\n', nnz);
    if nnz==0
        break
    elseif (k>=conv_criteria)
        if sum(diff(nnzs(k-conv_criteria+1:k)))==0
            break
        end
        if nnzs(end)>nnzs(end-1)
            fprintf('hello!there must be something wrong!\n')
            break;
        end
    end
    % adjust the weights and re-iterate
    W = 1./(delta + z);
end
cvx_quiet(false);

x = x_log;
% num_pc = num_pc*order;
if isempty(x); display('infeasible!!'); group =[]; return; end
% if ~isempty(findstr(cvx_status,'Failed')); display('Solver Failed!');group =[]; return; end

p_est = x(1:num_param);
ind1 = find( z > delta );
% ind = [1 ind1' num_frame];
ind = [0 ind1' num_frame]; % modified by xikang
l = length(ind);

% ind(l) = num_frame+1;
group = [];
for i = 1:l-1;
    group = [group i*ones(1,ind(i+1)-ind(i))];
end

if ~exist('draw','var')
    draw = false;
end

if draw
    figure;
    plot(p_est(1:order:end),'b*');
    for i = 1:order
        title('Segmentation Drama Sequence');
        subplot(order,1,i);plot(p_est(i:order:end),'b*');
        y = strcat('p_',num2str(i));
        ylabel(y);
    end
    % figure;plot(A*x-rhs)
    figure; plot(group,'b*');
end