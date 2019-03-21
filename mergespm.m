function mergespm(filelist,outfilename)

loadpaths

fprintf('\nMerging the following files:\n');
for f = 1:length(filelist)
    file2merge = [filepath filelist{f} '.mat'];
    fprintf('%s\n',file2merge);
    S.D{f} = spm_eeg_load(file2merge);
end

outfilename = [filepath outfilename '.mat'];
fprintf('\ninto this file:\n%s\n',outfilename);

S.recode = 'same';
D = spm_eeg_merge(S);

S = [];
S.D = D;
S.outfile = outfilename;
spm_eeg_copy(S);
delete(D);

fprintf('Done.\n');