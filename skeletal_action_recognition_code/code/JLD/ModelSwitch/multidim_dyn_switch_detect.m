% Switch detection via sparsification for multidimensional regressors:
% y(t) = sum_{i=1}^{order} A_i y(t-i) + noise
% where y \in R^n and A_i's are (nxn)

%%%% inputs %%%%
% data: mxn matrix of y's where m is the time horizon
% norm_used: noise norm (can be any p norm or inf)
% epsilon: bound on noise norm
% order: order of the regressor

%%%% output %%%%
% group: m by 1 vector showing the labels

% NO, 04/08

function group = multidim_dyn_switch_detect(data,norm_used,epsilon,order)

%without offset
[num_frame num_pc] = size(data);
num_frame = num_frame -order;

%num_pc = num_pc^2*order;
M1 = [zeros(num_frame,1) -speye(num_frame)];
M1 = speye(num_frame)+M1(:,1:end-1);
M1 = sparse(M1(1:end-1,:));
M1 = kron(M1,speye(num_pc^2*order));

%  S = SPARSE(i,j,s,m,n,nzmax)
A = sparse([],[],[],num_pc*num_frame,order*num_pc^2*num_frame);

rcount = 1;
ccount = 1;
for i = 1:num_frame
    for j = 1:num_pc
        dummy = data(i:i+order-1,:)';
        A(rcount,ccount:ccount+order*num_pc-1) = dummy(:)';
        rcount = rcount+1;
        ccount = ccount+order*num_pc;
    end
end

rhs = data(order+1:num_frame+order,:)';
rhs = rhs(:);
W = ones(num_frame-1,1);
num_param = num_frame*num_pc^2*order;
%keyboard;
delta = 10^-5;
nnzs = [];
cvx_quiet(true);
conv_criteria = 3;
for k = 1:100
  cvx_begin
    variable x_log(num_param)
    variable z(num_frame-1)
    c = reshape(abs(M1*x_log),[num_pc^2*order,num_frame-1]);
    minimize( sum( W.*z ) )
    subject to
      z >= max(c)';
      norm(A*x_log - rhs,norm_used) <= epsilon;
  cvx_end

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
  end
  % adjust the weights and re-iterate
  W = 1./(delta + z);
end
cvx_quiet(false);

x = x_log;

if isempty(x); display('infeasible!!'); group =[]; return; end
if ~isempty(findstr(cvx_status,'Failed')); display('Solver Failed!!'); group =[]; return; end

ind1 = find( z > delta );
ind = [1 ind1' num_frame];
l = length(ind);

ind(l) = num_frame+1;
group = [];
for i = 1:l-1;
    group = [group i*ones(1,ind(i+1)-ind(i))];
end
figure; plot(group,'b*');