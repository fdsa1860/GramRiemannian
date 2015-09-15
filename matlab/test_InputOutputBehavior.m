addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
data_generation;
data_clean = data;
n = 500;
d = num_frame;
N = n * num_sys;
nc = 30;
opt.metric = 'JLD';
% opt.metric = 'binlong';
opt.sigma = 1e-3;
% opt.sigma = 0;
opt.epsilon = 1e-1;

data = data_clean + opt.epsilon * noise_data;
% data = data_clean + e * randn(size(data));

% HH = cell(1,size(data,1));
% for i = 1:size(data,1)
%     H1 = hankel_mo(data(i,:),[d-nc+1, nc]);
%     HH1 = H1' * H1;
%     HH1 = HH1 / norm(HH1,'fro');
%     if strcmp(opt.metric,'JLD')
%         HH{i} = HH1 + opt.sigma * eye(nc);
% %         [U,S,V] = svd(HH1);
% %         s = diag(S);
% %         ind = s<opt.sigma;
% %         if any(ind)
% %             R = opt.sigma*V(:,ind)'*V(:,ind);         
% %         else
% %             R = zeros(size(HH1));
% %         end
% %         HH{i} = HH1 + R;
% %         HH{i} = HH1;
%     elseif strcmp(opt.metric,'binlong')
%         HH{i} = HH1;
%     end
% end

y1 = data(1,1:70);
Hy1 = hankel_mo(y1,[length(y1)-nc+1, nc]);
HHy1 = Hy1' * Hy1;
HHy1 = HHy1 / norm(HHy1,'fro');
y2 = data(1,20:90);
Hy2 = hankel_mo(y2,[length(y2)-nc+1, nc]);
HHy2 = Hy2' * Hy2;
HHy2 = HHy2 / norm(HHy2,'fro');
y3 = data(1000,:);
Hy3 = hankel_mo(y3,[length(y3)-nc+1, nc]);
HHy3 = Hy3' * Hy3;
HHy3 = HHy3 / norm(HHy3,'fro');
y4 = data_clean(1,1:70);
Hy4 = hankel_mo(y4,[length(y4)-nc+1, nc]);
HHy4 = Hy4' * Hy4;
HHy4 = HHy4 / norm(HHy4,'fro');

HHy1_hat = pcaClean(HHy1);
HHy4_hat = pcaClean(HHy4);
% y1_hat = hstlnClean(y1);

% dis = HHdist({HHy1_hat},{HHy2},opt.metric);
[dis, Phi, cccp] = gramDist_cccp(pcaClean(HHy1), HHy3, opt);
