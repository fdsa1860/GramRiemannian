
function group = indep_dyn_switch_detect_offset(data,norm_used,epsilon,order)

%with offset
[num_frame num_pc] = size(data);
num_frame = num_frame -order;
%assume all coordinates evolve with independent dynamics 
%single input and B \in R^(num_pc x 1)

%num_pc = num_pc*order;
M1 = [zeros(num_frame,1) -eye(num_frame)];
M1 = eye(num_frame)+M1(:,1:end-1);
M1 = sparse(M1(1:end-1,:));
M1 = kron(M1,eye(num_pc*order));

M2 = [zeros(num_frame,1) -eye(num_frame)];
M2 = eye(num_frame)+M2(:,1:end-1);
M2 = sparse(M2(1:end-1,:));
M2 = kron(M2,eye(num_pc));

%M = [M1 M2];
%  S = SPARSE(i,j,s,m,n,nzmax)
A = sparse([],[],[],num_pc*num_frame,order*num_pc*num_frame);
%keyboard
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
num_param = num_frame*num_pc*order;
%keyboard;
delta = 10^-3;
nnzs = [];
cvx_quiet(true);
conv_criteria = 3;
for k = 1:100
  cvx_begin
    variable x_log(num_param)
    variable b(num_frame*num_pc)
    variable z(num_frame-1)
    c1 = reshape(abs(M1*x_log),[num_pc*order,num_frame-1]);
    c2 = reshape(abs(M2*b),[num_pc,num_frame-1]);
    c = [c1;c2];
    minimize( sum( W.*z ) )
    subject to
      z >= max(c)';
      norm(A*x_log - rhs +b,norm_used) <= epsilon;
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
num_pc = num_pc*order;
if isempty(x); display('infeasible!!'); group =[]; return; end

p_est = x(1:num_param);
% figure;
% plot(p_est(1:num_pc:end),'b*');
% % for i = 1:num_pc
% %     title('Segmentation Drama Sequence');
% %     subplot(num_pc,1,i);plot(p_est(i:num_pc:end),'b*');
% %     y = strcat('p_',num2str(i));
% %     ylabel(y);
% % end
% figure;plot(A*x-rhs)

ind1 = find( z > delta );
ind = [1 ind1' num_frame];
l = length(ind);

ind(l) = num_frame+1;
group = [];
for i = 1:l-1;
    group = [group i*ones(1,ind(i+1)-ind(i))];
end
figure; plot(group,'b*');