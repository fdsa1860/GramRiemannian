function parseMHAD

addpath(genpath(fullfile('..','..','3rdParty','bvh-matlab')));

dataPath = fullfile('~','research','data','MHAD','BerkeleyMHAD','Mocap','SkeletalData');

nSubject = 11;
nAction = 12;
nRep = 5;

count = 1;
data = cell(1, nSubject * nAction * nRep);
label_sub = zeros(1, nSubject * nAction * nRep);
label_act = zeros(1, nSubject * nAction * nRep);
label_rep = zeros(1, nSubject * nAction * nRep);
for si = 1:nSubject
    for ai = 1:nAction
        for ri = 1:nRep
            fileName = sprintf('skl_s%02d_a%02d_r%02d.bvh',si,ai,ri);
            if ~exist(fullfile(dataPath, fileName), 'file')
                continue;
            end
            [skeleton,time] = loadbvh(fullfile(dataPath,fileName));
            curFPS = round(numel(time)/time(end));
            sub_interval = round(curFPS/30); % 30 Frames Per Second;
            % subsample frames
            num_joint = numel(skeleton);
            tmpdata_x = zeros(num_joint,numel(1:sub_interval:numel(time)));
            tmpdata_y = zeros(num_joint,numel(1:sub_interval:numel(time)));
            tmpdata_z = zeros(num_joint,numel(1:sub_interval:numel(time)));
            
            for j = 1:numel(skeleton)
                tmpdata_x(j,:) = skeleton(j).Dxyz(1,1:sub_interval:end);
                tmpdata_y(j,:) = skeleton(j).Dxyz(3,1:sub_interval:end);
                tmpdata_z(j,:) = skeleton(j).Dxyz(2,1:sub_interval:end);
            end
            data_tmp = zeros(size(tmpdata_x,1)*3,size(tmpdata_x,2));
            data_tmp(1:3:end,:) = tmpdata_x;
            data_tmp(2:3:end,:) = tmpdata_y;
            data_tmp(3:3:end,:) = tmpdata_z;
            data{count} = data_tmp;
            
            [si ai ri]
            label_sub(count) = si;
            label_act(count) = ai;
            label_rep(count) = ri;
            count = count + 1;
        end
    end
end

if count <= length(data)
    data(count:end) = [];
    label_sub(count:end) = [];
    label_act(count:end) = [];
    label_rep(count:end) = [];
end

save('MHAD_data_whole.mat','data','label_sub','label_act','label_rep');

end