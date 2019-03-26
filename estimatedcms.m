function estimatedcms(listname, modinds)

loadpaths
loadsubj
subjlist = eval(listname);

models = {
        'DMN'
        'SAL'
        'CEN'
           };
       
for s = 1:size(subjlist,1)
    for m = 1:length(modinds)
        GCM{s,m} = [filepath subjlist{s,1} '_model' (models{modindex}) '.mat'];
    end
end
% Specify PEB model settings (see batch editor for help on each setting)
M = struct();
M.alpha = 1;
M.beta  = 16;
M.hE    = 0;
M.hC    = 1/16;
M.Q     = 'all';
M.maxit  = 256;
M.X = ones(size(GCM,1),1);

spm_dcm_peb_fit(GCM, M, {'B'});
