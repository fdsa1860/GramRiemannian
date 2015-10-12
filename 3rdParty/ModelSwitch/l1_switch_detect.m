
function group = l1_switch_detect(data,norm_used,epsilon)

[num_frame num_pc] = size(data);

M1 = [zeros(num_frame,1) -speye(num_frame)];
M1 = [speye(num_frame)+M1(:,1:end-1)];
M1 = sparse(M1(1:end-1,:));
M1 = kron(M1,eye(num_pc));

A = []; %A is sparse, there is a more efficient way to fill it
for i = 1:num_frame
    A = blkdiag(A, data(i,:));
end

A = sparse(A);

rhs = epsilon*ones(num_frame,1);

W = ones(num_frame-1,1);
num_param = num_frame*num_pc;
delta = 10^-3; %regularization constant
nnzs = [];
cvx_quiet(true); %if you want to see what the solver is doing comment out this
conv_criteria = 3; %if number of zeros do not change in the last 3 iterations
                   % declare convergence
for k = 1:100
  cvx_begin
    variable x_log(num_param)
    variable z(num_frame-1)
    c = reshape(abs(M1*x_log),[num_pc,num_frame-1]);
    minimize( sum( W.*z ) )
    subject to
      z >= max(c)';
      norm(A*x_log - 1,norm_used) <= epsilon;
  cvx_end

  % display new number of nonzeros in the solution vector
  nonzeros = find( z > delta )'
  nnz = length(nonzeros);
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

p_est = x(1:num_param);

%some informative plots..

%plots of the entries of normal vector, might help to understand
%which hyperplanes are close to each other

%figure;
%plot(p_est(1:num_pc:end),'b*');
%keyboard
% for i = 1:num_pc
%     title('Segmentation Drama Sequence');
%     subplot(num_pc,1,i);plot(p_est(i:num_pc:end),'b*');
%     y = strcat('p_',num2str(i));
%     ylabel(y);
% end

%figure;plot(A*x-1) %plot of residual errors

ind1 = find( z > delta );
ind = [1 ind1' num_frame];
l = length(ind);
ind(l) = num_frame+1;
group = [];
for i = 1:l-1;
    group = [group i*ones(1,ind(i+1)-ind(i))];
end
figure; plot(group,'b*'); %plot of final segmentation