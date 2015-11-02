
function HH = getHH(features,opt)

s = size(features{1});
Hsize = opt.H_rows * s(1);

if ~exist('opt','var')
    opt.H_structure = 'HHt';
    opt.metric = 'JBLD';
end

HH = cell(1,length(features));
for i=1:length(features)
    t = diff(features{i},[],2);
%     t = features{i};
%     if size(t,1)>1000, t=t(idx,:); end % debug only, comment out in release code
    if strcmp(opt.H_structure,'HtH')
        nc = Hsize;
        nr = size(t,1)*(size(t,2)-nc+1);
        if nr<1, error('hankel size is too large.\n'); end
        Ht = hankel_mo(t,[nr nc]);
        HHt = Ht' * Ht;
    elseif strcmp(opt.H_structure,'HHt')
        nr = floor(Hsize/size(t,1))*size(t,1);
        nc = size(t,2)-floor(nr/size(t,1))+1;
        if nc<1, error('hankel size is too large.\n'); end
        Ht = hankel_mo(t,[nr nc]);
        HHt = Ht * Ht';
    end
    HHt = HHt / norm(HHt,'fro');
    if strcmp(opt.metric,'JBLD') || strcmp(opt.metric,'JBLD_denoise') ...
            || strcmp(opt.metric,'AIRM') || strcmp(opt.metric,'LERM')...
            || strcmp(opt.metric,'KLDM')
        I = opt.sigma*eye(size(HHt));
        HH{i} = HHt + I;
    elseif strcmp(opt.metric,'binlong')
        HH{i} = HHt;
    end
end


% data = reshape(data,s(1)*s(2),s(3));



% count = 1;
% while count <= size(data,1)
%     if all(data(count,:)==0), data(count,:) = []; continue; end
%     count = count + 1;
% end
% t = diff(data,[],2);
% if strcmp(opt.H_structure,'HtH')
%     nc = Hsize;
%     nr = size(t,1)*(size(t,2)-nc+1);
%     if nr<1, error('hankel size is too large.\n'); end
%     Ht = hankel_mo(t,[nr nc]);
%     HHt = Ht' * Ht;
% elseif strcmp(opt.H_structure,'HHt')
%     nr = floor(Hsize/size(t,1))*size(t,1);
%     nc = size(t,2)-floor(nr/size(t,1))+1;
%     if nc<1, error('hankel size is too large.\n'); end
%     Ht = hankel_mo(t,[nr nc]);
%     HHt = Ht * Ht';
% end
% HHt = HHt / norm(HHt,'fro');
% %     HHt = t * t';
% I = 0.9*eye(size(HHt));
% HH = HHt + I;

end