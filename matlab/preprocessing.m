function dataOut = preprocessing(dataIn)

% downsample from 20 KHz to 1 KHz
dataSampled = dataIn(1:20:end,:);

% low pass filter
lpf_order = 6;
cutoff_freq = 499;
w = cutoff_freq / 1000;
[b,a] = butter(lpf_order, w);
% freqz(b,a)
% dataIn = randn(1000,1);
dataOut = filter(b,a,dataSampled);

end