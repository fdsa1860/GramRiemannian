%% accExample3

clear;clc;close all;

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

% dataDir = '../../../data/bearing_IMS/1st_test';
% dataDir = '../../../data/bearing_IMS/2nd_test';
% files = dir(fullfile(dataDir, '*.*.*.*'));
% N = length(files);
% data = cell(1,N);
% for n = 1:N
%     dat = load(fullfile(dataDir,files(n).name));
%     data{n} = preprocessing(dat);
%     n
% end
%%
% data = load('../expData/bearingData1'); data=data.data; nChnl = 8;
data = load('../expData/bearingData2','data'); data=data.data; nChnl = 4;

N = length(data);
opt.metric = 'JLD';
opt.sigma = 1e-3;
opt.epsilon = 1e-2;

nr = 10;
% k = 4;
HH = cell(nChnl,N);
for k = 1:nChnl
    for n = 1:N
        Ht = hankel_mo(data{n}(:,k)',[nr, length(data{n}(:,k))-nr+1]);
        HHt = Ht * Ht';
        HH{k,n} = HHt / norm(HHt,'fro');
    end
end
%%
D = zeros(nChnl, N);
for i = 1:nChnl
    for j = 1:N
        D(i,j) = gramDist_cccp(pcaClean(HH{i,1}), HH{i,j}, opt);
    end
end

%% display
figure;
set(gcf,'color','white')
subplot(411);plot(D(1,:));ylabel('bearing 1');ylim([0 0.3]);
subplot(412);plot(D(2,:));ylabel('bearing 2');ylim([0 0.3]);
subplot(413);plot(D(3,:));ylabel('bearing 3');ylim([0 0.3]);
subplot(414);plot(D(4,:));ylabel('bearing 4');ylim([0 0.3]);
export_fig ../bearingData2.pdf -native

% figure;
% subplot(811);plot(D(1,:));ylabel('bearing 1');ylim([0 1]);
% subplot(812);plot(D(2,:));ylabel('bearing 1');ylim([0 1]);
% subplot(813);plot(D(3,:));ylabel('bearing 2');ylim([0 1]);
% subplot(814);plot(D(4,:));ylabel('bearing 2');ylim([0 1]);
% subplot(815);plot(D(5,:));ylabel('bearing 3');ylim([0 1]);
% subplot(816);plot(D(6,:));ylabel('bearing 3');ylim([0 1]);
% subplot(817);plot(D(7,:));ylabel('bearing 4');ylim([0 1]);
% subplot(818);plot(D(8,:));ylabel('bearing 4');ylim([0 1]);