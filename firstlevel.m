function firstlevel(listname)

loadpaths
loadsubj

subjlist = eval(listname);

modellist = [4];
for s = 1:size(subjlist,1)
    for m = 1:length(modellist)
        basename = subjlist{s,1};
        GCM{s,1} = [filepath basename sprintf('_m%02d.mat',modellist(m))];
    end
end

% % Filenames -> DCM structures
% GCM = spm_dcm_load(GCM);
% 
% % Estimate DCMs (this won't effect original DCM files)
% GCM = spm_dcm_fit(GCM);
% 
% save GCM.mat GCM