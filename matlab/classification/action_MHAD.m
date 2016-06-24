function action_MHAD(data, tr_info, labels, opt)

jointsVel = getVelocity(data.joints);
HH = getHH(jointsVel, opt);
feat = HH;
% feat = getLogHH(HH);

results_dir = fullfile('..','expData','res');
if ~exist(results_dir,'dir')
    mkdir(results_dir);
end

preprocessingTime = toc(opt.tStart);

tr_subjects = tr_info.tr_subjects;
te_subjects = tr_info.te_subjects;

subject_labels = labels.subject_labels;
action_labels = labels.action_labels;

tr_ind = ismember(subject_labels, tr_subjects);
te_ind = ismember(subject_labels, te_subjects);

X_train = feat(tr_ind);
y_train = action_labels(tr_ind);
X_test = feat(te_ind);
y_test = action_labels(te_ind);

[predicted_labels,D2,time,HH_center] = nn(X_train, y_train, X_test, opt);

accuracy = nnz(y_test==predicted_labels)/ length(y_test);
unique_classes = unique(y_test);
n_classes = length(unique_classes);
class_wise_accuracy = zeros(1, n_classes);
confusion_matrix = zeros(n_classes, n_classes);
for i = 1:n_classes
    temp = find(y_test == unique_classes(i));
    if ~isempty(temp)
        class_wise_accuracy(i) =...
            nnz(predicted_labels(temp)==unique_classes(i)) / length(temp);
        confusion_matrix(i, :) = ...
            hist(predicted_labels(temp), unique_classes) / length(temp);
    else
        class_wise_accuracy(i) = 1;
        confusion_matrix(i, i) = 1;
    end
end
trainTime = time.trainTime;
testTime = time.testTime;
runtime = toc(opt.tStart);

save ([results_dir, '/classification_results.mat'],...
    'accuracy', 'class_wise_accuracy','confusion_matrix', '',...
    'trainTime','testTime','preprocessingTime',...
    'runtime');

end