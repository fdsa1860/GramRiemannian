function [predicted_labels,D2,time] = nn2(X_train, y_train, y_subject_train, X_test, opt)

tStart = tic;

unique_classes = unique(y_train);
n_classes = length(unique_classes);

unique_subjects = unique(y_subject_train);
n_subjects = length(unique_subjects);

if strcmp(opt.metric,'binlong')
    D = HHdist(X_train,X_train,opt); % uncomment if opt.metric=='binlong'
    centerInd = findCenters(D,y_train); % uncomment if opt.metric=='binlong'
    HH_center = X_train(centerInd); % uncomment if opt.metric=='binlong'
elseif strcmp(opt.metric,'JBLD') || strcmp(opt.metric,'JLD_denoise')
    HH_center = cell(1, n_classes);
    %         cparams(1:n_classes) = struct ('prior',0,'alpha',0,'theta',0);
    for ai = 1:n_classes
        X_tmp = X_train(y_train==unique_classes(ai));
        HH_center{ai} = steinMean(cat(3,X_tmp{1:end}));
%                     HH_center{ai} = incSteinMean(cat(3,X_tmp{1:end}));
        %             d = HHdist(HH_center(ai),X_tmp,opt.metric);
        %             d(abs(d)<1e-6) = 1e-6;
        % %             phat = gamfit(d);
        %             phat = mle(d,'pdf',@gampdf,'start',[1 1],'lowerbound',[0 0],'upperbound',[1.5 inf]);
        %             cparams(ai).alpha = min(100,phat(1));
        %             if isinf(cparams(ai).alpha), keyboard;end
        %             cparams(ai).theta = max(0.01,phat(2));
        %             cparams(ai).prior = length(X_tmp) / length(X_train);
        fprintf('processed %d/%d\n',ai,n_classes);
    end
elseif strcmp(opt.metric,'AIRM')
    HH_center = cell(1, n_classes);
    for ai = 1:n_classes
        X_tmp = X_train(y_train==unique_classes(ai));
        HH_center{ai} = karcher(X_tmp{1:end});
    end
elseif strcmp(opt.metric,'LERM')
    HH_center = cell(1, n_classes);
    for ai = 1:n_classes
        X_tmp = X_train(y_train==unique_classes(ai));
        HH_center{ai} = logEucMean(X_tmp{1:end});
    end
elseif strcmp(opt.metric,'KLDM')
    HH_center = cell(1, n_classes * n_subjects);
    y_center = zeros(n_classes * n_subjects, 1);
    count = 1;
    for ai = 1:n_classes
        for si = 1:n_subjects
            X_tmp = X_train(y_train==unique_classes(ai) & y_subject_train==unique_subjects(si));
            if isempty(X_tmp), continue; end
            HH_center{count} = jefferyMean(X_tmp{1:end});
            y_center(count) = ai;
            count = count + 1;
        end
    end
    HH_center(count:end) = [];
    y_center(count:end) = [];
end

time.trainTime = toc(tStart);

% test NN
tStart = tic;

D2 = HHdist(HH_center,X_test,opt);
[~,ind] = min(D2);
% predicted_labels = unique_classes(ind);
predicted_labels = y_center(ind);

time.testTime = toc(tStart);

%         % test gamma voting
%         D2 = HHdist(HH_center,X_test,opt.metric);
%         P2 = zeros(size(D2));
%         for ai = 1:size(D2,1)
%             P2(ai,:) = gampdf(D2(ai,:),...
%                 cparams(ai).alpha, cparams(ai).theta);
%         end
%         [~,ind] = max(P2);
%         predicted_labels = unique_classes(ind);



end