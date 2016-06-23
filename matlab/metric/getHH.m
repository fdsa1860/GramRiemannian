
function HH = getHH(features,opt)

s = size(features{1});

if ~exist('opt','var')
    opt.H_structure = 'HHt';
    opt.metric = 'JBLD';
end

HH = cell(1,length(features));
for i=1:length(features)
%     t = diff(features{i},[],2);
    t = features{i};
    if strcmp(opt.H_structure,'HtH')
        Hsize = opt.H_rows;
        nc = Hsize;
        nr = size(t,1)*(size(t,2)-nc+1);
        if nr<1, error('hankel size is too large.\n'); end
        Ht = blockHankel(t,[nr nc]);
        HHt = Ht' * Ht;
    elseif strcmp(opt.H_structure,'HHt')
        Hsize = opt.H_rows * s(1);
        nr = floor(Hsize/size(t,1))*size(t,1);
        nc = size(t,2)-floor(nr/size(t,1))+1;
        if nc<1, error('hankel size is too large.\n'); end
        Ht = blockHankel(t,[nr nc]);
        HHt = Ht * Ht';
    end
    HHt = HHt / norm(HHt,'fro');
    if strcmp(opt.metric,'JBLD') || strcmp(opt.metric,'JBLD_denoise') ...
            || strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
            || strcmp(opt.metric,'KLDM')
        I = opt.sigma*eye(size(HHt));
        HH{i} = HHt + I;
    elseif strcmp(opt.metric,'binlong') || strcmp(opt.metric,'SubspaceAngle') ||...
            strcmp(opt.metric,'SubspaceAngleFast')
        HH{i} = HHt;
    end
end

end