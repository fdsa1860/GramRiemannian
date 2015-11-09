function plotData()

e = 0:0.2:5;

figure(1);clf;
hold on;
load ../expData/Synthetic/res_Binlong_r10.mat;
plot(e,avg_total_accuracy,'rv');
hold on;
load ../expData/Synthetic/res_AIRM_r10_sigma001.mat;
plot(e,avg_total_accuracy,'b+');
load ../expData/Synthetic/res_LERM_r10_sigma001.mat;
plot(e,avg_total_accuracy,'csquare');
load ../expData/Synthetic/res_JBLD_r10_sigma001.mat;
plot(e,avg_total_accuracy,'ko');
load ../expData/Synthetic/res_KLDM_r10_sigma001.mat;
plot(e,avg_total_accuracy,'mx');
hold off;
legend('Hankelet Angle', 'H-AIRM', 'H-LERM', 'H-JBLD', 'H-KLDM')
xlabel('Noise level: white noise standard deviation');
ylabel('Classification accuracy (r=10)');
hold off;

figure(2);clf;
hold on;
load ../expData/Synthetic/res_Binlong_r5.mat;
plot(e,avg_total_accuracy,'ro');
load ../expData/Synthetic/res_Binlong_r10.mat;
plot(e,avg_total_accuracy,'rv');
load ../expData/Synthetic/res_Binlong_r20.mat;
plot(e,avg_total_accuracy,'rx');
load ../expData/Synthetic/res_Binlong_r30.mat;
plot(e,avg_total_accuracy,'rsquare');
load ../expData/Synthetic/res_JBLD_r5_sigma001.mat;
plot(e,avg_total_accuracy,'go');
load ../expData/Synthetic/res_JBLD_r10_sigma001.mat;
plot(e,avg_total_accuracy,'gv');
load ../expData/Synthetic/res_JBLD_r20_sigma001.mat;
plot(e,avg_total_accuracy,'gx');
load ../expData/Synthetic/res_JBLD_r30_sigma001.mat;
plot(e,avg_total_accuracy,'gsquare');
legend('Hankelet Angle, r=5', 'Hankelet Angle, r=10',...
    'Hankelet Angle, r=20','Hankelet Angle, r=30',...
    'H-JBLD, r=5', 'H-JBLD, r=10','H-JBLD, r=20','H-JBLD, r=30')
xlabel('Noise level: white noise standard deviation');
ylabel('Classification accuracy');
hold off;

figure(3);clf;
hold on;
load ../expData/Synthetic/res_Binlong_r5.mat;
plot(e,avg_total_accuracy,'bo');
load ../expData/Synthetic/res_Binlong_r10.mat;
plot(e,avg_total_accuracy,'go');
load ../expData/Synthetic/res_Binlong_r20.mat;
plot(e,avg_total_accuracy,'ro');
load ../expData/Synthetic/res_Binlong_r30.mat;
plot(e,avg_total_accuracy,'mo');
load ../expData/Synthetic/res_JBLD_r5_sigma001.mat;
plot(e,avg_total_accuracy,'bv');
load ../expData/Synthetic/res_JBLD_r10_sigma001.mat;
plot(e,avg_total_accuracy,'gv');
load ../expData/Synthetic/res_JBLD_r20_sigma001.mat;
plot(e,avg_total_accuracy,'rv');
load ../expData/Synthetic/res_JBLD_r30_sigma001.mat;
plot(e,avg_total_accuracy,'mv');
legend('Hankelet Angle, r=5', 'Hankelet Angle, r=10',...
    'Hankelet Angle, r=20','Hankelet Angle, r=30',...
    'H-JBLD, r=5', 'H-JBLD, r=10','H-JBLD, r=20','H-JBLD, r=30')
xlabel('Noise level: white noise standard deviation');
ylabel('Classification accuracy');
hold off;

end