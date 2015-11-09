% sythetic test

dbstop error;

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

rng('default');
data_generation;
data_clean = data;
n = 500;
d = num_frame;
N = n * num_sys;
nc = 30;
% opt.metric = 'binlong';
% opt.metric = 'AIRM';
% opt.metric = 'LERM';
opt.metric = 'JBLD';
% opt.metric = 'KLDM';
opt.sigma = 1e-2;

e = 0:0.2:5;
% e = 2;
% p = zeros(1,length(e));
% opt.sigma = 10.^(-6:-1);
% p = zeros(1,length(opt.sigma));
avg_total_accuracy = zeros(1,length(e));
avg_confusion_matrices = cell(1,length(e));
for k = 1:length(e);
% for k = 1;
    
    fprintf('Processing %d/%d ...\n',k,length(e));
    
    data = data_clean + e(k)*noise_data;
%     data = data_clean + e*randn(size(data));
    
    % HH = cell(1,size(data,1));
    % for i = 1:size(data,1)
    %     H1 = hankel_mo(data(i,:),[d-nc+1, nc]);
    %     HH1 = H1' * H1;
    %     HH1 = HH1 / norm(HH1,'fro');
    %     if strcmp(opt.metric,'JBLD')
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
    
    total_accuracy = zeros(1, num_fold);
    confusion_matrices = cell(1, num_fold);
    for fold=1:num_fold
        
        trainData = [];
        testData = [];
        y_train = [];
        y_test = [];
        for i = 1:num_sys
            trainData = [trainData data(index_train(:,fold)+(i-1)*n,:)'];
            y_train = [y_train label(index_train(:,fold)+(i-1)*n)'];
            testData = [testData data(index_test(:,fold)+(i-1)*n,:)'];
            y_test = [y_test label(index_test(:,fold)+(i-1)*n)'];
        end
        
        
        %% training
        % nc = 5;
        HH = cell(1,size(trainData,2));
        for i = 1:size(trainData,2)
            H1 = hankel_mo(trainData(:,i)',[d-nc+1, nc]);
            H1_p = H1 / (norm(H1*H1','fro')^0.5);
            HH1 = H1_p' * H1_p;
            if strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
                    || strcmp(opt.metric,'KLDM') || strcmp(opt.metric,'JBLD')
                HH{i} = HH1 + opt.sigma(1) * eye(nc);
            elseif strcmp(opt.metric,'binlong')
                HH{i} = HH1;
            end
        end
        
        % NN
        if strcmp(opt.metric,'binlong')
            D = HHdist(HH, [], opt);
            centerInd = findCenters(D, y_train);
            HH_centers = HH(centerInd);
        else
            HH_centers = cell(1, num_sys);
            for i = 1:num_sys
                %     HH_centers{i} = BhattacharyyaMean(HH{(i-1)*size(index_train,1)+1:i*size(index_train,1)});
                if strcmp(opt.metric,'AIRM')
                    HH_centers{i} = karcher(HH{y_train==i});
                elseif strcmp(opt.metric,'LERM')
                    HH_centers{i} = logEucMean(HH{y_train==i});
                elseif strcmp(opt.metric,'JBLD')
                    HH_centers{i} = steinMean(cat(3,HH{y_train==i}));
                elseif strcmp(opt.metric,'KLDM')
                    HH_centers{i} = jefferyMean(HH{y_train==i});
                end
            end
        end
        
        % % kmeans
        % rng('default');
        % tic;
        % [predicted_label,HH_centers,sD] = kmeansJLD(HH,6,opt);
        % toc
        
        % % ncut
        % tic;
        % [predicted_label,HH_centers,sD] = ncutJLD(HH,6,opt);
        % toc
        
        %% testing
        HH_test = cell(1,size(testData,2));
        for i = 1:size(testData,2)
            H1 = hankel_mo(testData(:,i)',[d-nc+1, nc]);
            H1_p = H1 / (norm(H1*H1','fro')^0.5);
            HH1 = H1_p' * H1_p;
            if strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
                    || strcmp(opt.metric,'KLDM') || strcmp(opt.metric,'JBLD')
                HH_test{i} = HH1 + opt.sigma(1) * eye(nc);
            elseif strcmp(opt.metric,'binlong')
                HH_test{i} = HH1;
            end
        end
        
        D2 = HHdist(HH_centers,HH_test,opt);
        [~,predicted_label] = min(D2);
        
        %% eval
        % gt = kron(1:num_sys,ones(1,unit_train));
        gt = kron(1:num_sys,ones(1,unit_test));
        % gt = label';
        % v = perms(1:num_sys);
        % acc = zeros(1,size(v,1));
        % for i = 1:length(acc)
        %     acc(i) = nnz(v(i,predicted_label)==gt)/length(gt);
        % end
        % [accuracy,ind] = max(acc);
        % % accuracy
        % predicted_label = v(ind,predicted_label);
        
        accuracy = nnz(predicted_label==gt)/length(gt);
        
        % M = confusionmat(gt,label)/unit_train;
        % M = confusionmat(gt,tmp)/n;
        
        n_classes = 6;
        unique_classes = unique(gt);
        class_wise_accuracy = zeros(1, n_classes);
        confusion_matrix = zeros(n_classes, n_classes);
        for i = 1:n_classes
            temp = find(gt == unique_classes(i));
            if ~isempty(temp)
                class_wise_accuracy(i) =...
                    nnz(predicted_label(temp)==unique_classes(i)) / length(temp);
                confusion_matrix(i, :) = ...
                    hist(predicted_label(temp), unique_classes) / length(temp);
            else
                class_wise_accuracy(i) = 1;
                confusion_matrix(i, i) = 1;
            end
        end
        
        total_accuracy(fold) = accuracy;
        confusion_matrices{fold} = confusion_matrix;
        
    end
    
    avg_total_accuracy(k) = mean(total_accuracy);
    avg_confusion_matrices{k} = mean(cat(3,confusion_matrices{1:end}),3);
end

if ~exist('../expData/Synthetic','dir')
    mkdir('../expData/Synthetic');
end
save ../expData/Synthetic/res.mat avg_total_accuracy avg_confusion_matrices e

%% display
plot(avg_total_accuracy,'*');
% plotConfusionMatrix(avg_confusion_matrices{1});
% xlabel('predicted labels');
% ylabel('groundtruth');
