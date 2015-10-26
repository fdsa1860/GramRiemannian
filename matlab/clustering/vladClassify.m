function [total_accuracy, cw_accuracy, confusion_matrices] =...
    vladClassify(data, tr_ind, te_ind, opt)

% slide window
numWords = 20;
noiseBound = 2;
%         [feat_tr,fl_tr] = chopFeature(data.features(tr_ind));
%         [feat_tr,fl_tr] = breakFeature(data.features(tr_ind));
[feat_tr,fl_tr] = breakFeature2(data.features(tr_ind));
%         [feat_tr, fl_tr] = filterStaticData(feat_tr, fl_tr, noiseBound);
HH_tr = getHH(feat_tr, opt);
%         [label,HH_centers,sD,cparams] = ncutJLD(HH_tr,numWords,opt);
tic
[label,HH_centers,sD] = kmeansJLD(HH_tr,numWords,opt);
toc
%         feat_tr = bowFeature(HH_centers, HH_tr, fl_tr, opt);
feat_tr = vladFeature(HH_centers, HH_tr, fl_tr, opt);
%         [feat_te,fl_te] = chopFeature(data.features(te_ind));
%         [feat_te,fl_te] = breakFeature(data.features(te_ind));
[feat_te,fl_te] = breakFeature2(data.features(te_ind));
%         [feat_te, fl_te] = filterStaticData(feat_te, fl_te, noiseBound);
HH_te = getHH(feat_te,opt);
%         feat_te = bowFeature(HH_centers, HH_te, fl_te, opt);
feat_te = vladFeature(HH_centers, HH_te, fl_te, opt);

X_train = feat_tr;
y_train = action_labels(tr_ind);
X_test = feat_te;
y_test = action_labels(te_ind);
[total_accuracy, cw_accuracy, confusion_matrices] =...
    svm_one_vs_all(X_train, X_test, y_train, y_test, C_val);

end