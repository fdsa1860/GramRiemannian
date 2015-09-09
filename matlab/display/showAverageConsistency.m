% show average consistency

% training data
load ../expData/avgConsistency_bsds_train_SW_h7_HHt_binary
ac_train_sw_HHt_binary = avgConsistency;

load ../expData/avgConsistency_bsds_train_SW_h7_HHt_s3_w10
ac_train_sw_HHt_s3_w10 = avgConsistency;

load ../expData/avgConsistency_bsds_train_SW_h7_HHt_s3_w20
ac_train_sw_HHt_s3_w20 = avgConsistency;

load ../expData/avgConsistency_bsds_train_SW_h7_HHt_s3_w30
ac_train_sw_HHt_s3_w30 = avgConsistency;

load ../expData/avgConsistency_bsds_train_SW_h7_HtH_s5_w10
ac_train_sw_HtH_s5_w10 = avgConsistency;

load ../expData/avgConsistency_bsds_train_SW_h7_HtH_s5_w20
ac_train_sw_HtH_s5_w20 = avgConsistency;

load ../expData/avgConsistency_bsds_train_SW_h7_HtH_s5_w30
ac_train_sw_HtH_s5_w30 = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HtH_binary
ac_train_ms_HtH_binary = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HtH_s5_w10
ac_train_ms_HtH_s5_w10 = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HtH_s5_w20
ac_train_ms_HtH_s5_w20 = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HtH_s5_w30
ac_train_ms_HtH_s5_w30 = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HHt_w10
ac_train_ms_HHt_w10 = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HHt_w20
ac_train_ms_HHt_w20 = avgConsistency;

load ../expData/avgConsistency_bsds_train_MS_h10_HHt_w30
ac_train_ms_HHt_w30 = avgConsistency;

figure(1);
hold on;
[~, ind] = sort(ac_train_sw_HHt_binary);
plot(ac_train_sw_HHt_binary(ind),'g*-');
plot(ac_train_sw_HHt_s3_w10(ind),'bx-');
plot(ac_train_sw_HHt_s3_w20(ind),'b+-');
plot(ac_train_sw_HHt_s3_w30(ind),'bo-');
plot(ac_train_sw_HtH_s5_w10(ind),'rx-');
plot(ac_train_sw_HtH_s5_w20(ind),'r+-');
plot(ac_train_sw_HtH_s5_w30(ind),'ro-');
% plot(ac_train_ms_HtH_binary(ind),'gx-');
plot(ac_train_ms_HHt_w10(ind),'kx-');
plot(ac_train_ms_HHt_w20(ind),'k+-');
plot(ac_train_ms_HHt_w30(ind),'ko-');
plot(ac_train_ms_HtH_s5_w10(ind),'cx-');
plot(ac_train_ms_HtH_s5_w20(ind),'c+-');
plot(ac_train_ms_HtH_s5_w30(ind),'co-');
hold off;
legend('ideal(w=1)','SW,HH^T,w=10','SW,HH^T,w=20','SW,HH^T,w=30',...
    'SW,H^TH,w=10','SW,H^TH,w=20','SW,H^TH,w=30',...
    'MS,HH^T,w=10','MS,HH^T,w=20','MS,HH^T,w=30',...
    'MS,H^TH,w=10','MS,H^TH,w=20','MS,H^TH,w=30','Location','NorthEastOutside');
xlabel('BSDS training images indices');
ylabel('Average consistency value');
title('Comparing average consistency values with different strategies of dynamic labeling');

% plot(ac_train_ms_s5_w30./ac_train_sw_binary,'*-');

ac_train_sw_HHt_binary_mean = mean(ac_train_sw_HHt_binary);
ac_train_sw_HHt_s3_w10_mean = mean(ac_train_sw_HHt_s3_w10);
ac_train_sw_HHt_s3_w20_mean = mean(ac_train_sw_HHt_s3_w20);
ac_train_sw_HHt_s3_w30_mean = mean(ac_train_sw_HHt_s3_w30);
ac_train_sw_HtH_s5_w10_mean = mean(ac_train_sw_HtH_s5_w10);
ac_train_sw_HtH_s5_w20_mean = mean(ac_train_sw_HtH_s5_w20);
ac_train_sw_HtH_s5_w30_mean = mean(ac_train_sw_HtH_s5_w30);
% mean(ac_train_ms_HtH_binary);
ac_train_ms_HHt_w10_mean = mean(ac_train_ms_HHt_w10);
ac_train_ms_HHt_w20_mean = mean(ac_train_ms_HHt_w20);
ac_train_ms_HHt_w30_mean = mean(ac_train_ms_HHt_w30);
ac_train_ms_HtH_s5_w10_mean = mean(ac_train_ms_HtH_s5_w10);
ac_train_ms_HtH_s5_w20_mean = mean(ac_train_ms_HtH_s5_w20);
ac_train_ms_HtH_s5_w30_mean = mean(ac_train_ms_HtH_s5_w30);

ac_train_sw_HHt_binary_mean
ac_train_sw_HHt_s3_w10_mean
ac_train_sw_HHt_s3_w20_mean
ac_train_sw_HHt_s3_w30_mean
ac_train_sw_HtH_s5_w10_mean
ac_train_sw_HtH_s5_w20_mean
ac_train_sw_HtH_s5_w30_mean
ac_train_ms_HHt_w10_mean
ac_train_ms_HHt_w20_mean
ac_train_ms_HHt_w30_mean
ac_train_ms_HtH_s5_w10_mean
ac_train_ms_HtH_s5_w20_mean
ac_train_ms_HtH_s5_w30_mean

% % testing data
% load ../expData/avgConsistency_bsds_test_SW_h7_binary.mat
% ac_test_sw_binary = avgConsistency;
% 
% load ../expData/avgConsistency_bsds_test_SW_h7_w10.mat
% ac_test_sw_w10 = avgConsistency;
% 
% load ../expData/avgConsistency_bsds_test_MS_h10_binary.mat
% ac_test_ms_binary = avgConsistency;
% 
% load ../expData/avgConsistency_bsds_test_MS_h10_s5_w10.mat
% ac_test_ms_s5_w10 = avgConsistency;
% 
% load ../expData/avgConsistency_bsds_test_MS_h10_s5_w30
% ac_test_ms_s5_w30 = avgConsistency;
% 
% load ../expData/avgConsistency_bsds_test_MS_h10_s6_w30
% ac_test_ms_s6_w30 = avgConsistency;
% 
% figure(2);
% hold on;
% [~, ind] = sort(ac_test_sw_binary);
% plot(ac_test_sw_binary(ind),'g*-');
% plot(ac_test_sw_w10(ind),'b*-');
% plot(ac_test_ms_binary(ind),'k*-');
% plot(ac_test_ms_s5_w10(ind),'y*-');
% plot(ac_test_ms_s5_w30(ind),'c*-');
% plot(ac_test_ms_s6_w30(ind),'m*-');
% hold off;