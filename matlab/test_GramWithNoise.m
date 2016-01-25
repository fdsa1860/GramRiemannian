% test Gram matrix with noise

close all;

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
data_generation;
data_clean = data;
d = num_frame;
N = num_sample * num_sys;
% nc = 30;
Hsize = 30;
% opt.metric = 'binlong';
opt.metric = 'AIRM';
% opt.metric = 'LERM';
% opt.metric = 'JBLD';
% opt.metric = 'KLDM';
opt.sigma = 1e-2;
e = 0;
s = 1e-2;
s = 0;

% metricSet = {'AIRM', 'JBLD', 'LERM', 'KLDM'};
metricSet = {'AIRM'};
% s = 10.^(-7:-2);
s = 0.01:0.01:0.1;
% e = 10.^(-7:0.2:-2);
% e = 0.01:0.01:0.1;
% e = 0.1;
d1 = zeros(length(s), length(e));
d2 = zeros(length(s), length(e));
for si = 1:length(s)
    for ei = 1:length(e);
        for mi = 1:length(metricSet)
            
            fprintf('Processing %d/%d ...\n',ei,length(e));
            opt.sigma = s(si);
            opt.metric = metricSet{mi};
            
            data = data_clean + e(ei)*noise_data;
            %     testData = data(1:2,:);
            testData = data([1 2 501],:);
            
            HH = cell(1, size(testData,1));
            for i = 1:size(testData, 1)
                t = testData(i, :);
                nr = floor(Hsize/size(t,1))*size(t,1);
                nc = size(t,2)-floor(nr/size(t,1))+1;
                if nc<1, error('hankel size is too large.\n'); end
                H1 = hankel_mo(t, [nr, nc]);
                HH1 = H1 * H1';
                HH1 = HH1 / norm(HH1,'fro');
                if strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
                        || strcmp(opt.metric,'KLDM') || strcmp(opt.metric,'JBLD')
                    HH{i} = HH1 + opt.sigma * eye(nr);
                elseif strcmp(opt.metric,'binlong')
                    HH{i} = HH1;
                end
            end
            
            d1(si,ei,mi) = HHdist(HH(1),HH(2),opt);
            d2(si,ei,mi) = HHdist(HH(1),HH(3),opt);
        end
    end
end

figure; hold on;
set(gca,'FontSize',12)
plot(s,d1(:,1,1)','b*','MarkerSize',10);
plot(s,d2(:,1,1)','r*','MarkerSize',10);
xlabel('Regularization value \sigma','FontSize',15);
ylabel('AIRM distance between two instances','FontSize',15);
title('AIRM distance VS regularization value (with clean data)','FontSize',15);
hLegend = legend('intra-class AIRM distance','inter-class AIRM distance');
set(hLegend,'FontSize',15)


% figure; hold on;
% set(gca,'FontSize',12)
% plot(e,d1(1,:,1),'b*','MarkerSize',10);
% plot(e,d1(1,:,2),'b^');
% plot(e,d1(1,:,3),'bx');
% plot(e,d1(1,:,4),'bo');
% plot(e,d2(1,:,1),'r*','MarkerSize',10);
% plot(e,d2(1,:,2),'r^');
% plot(e,d2(1,:,3),'rx');
% plot(e,d2(1,:,4),'ro');
% xlabel('Noise standard deviation \epsilon','FontSize',15);
% ylabel('AIRM distance between two instances','FontSize',15);
% title('AIRM distance VS noise level (with regularization \sigma=0)','FontSize',15);
% hLegend = legend('intra-class AIRM distance','inter-class AIRM distance');
% set(hLegend,'FontSize',15)

% legend('intra-class AIRM distance','intra-class JBLD distance', ...
%     'intra-class LERM distance', ...
%     'inter-class AIRM distance', 'inter-class JBLD distance', ...
%     'inter-class LERM distance' );