%   *** Convert EEGlab files into SPM and assign correct fiducials
%   using the default sensor locations (257 reduced to 173 channels ***     

function eeglab2spm(basename,condname) % Input 'basename' is the EEGlab file .set

if ~exist('basename','var') || isempty(basename) || ~exist('condname','var') || isempty(condname)
    error('Both basename and condname must be specified.');
end

loadpaths
chanlocfile = 'GSN-HydroCel-173-spm.mat';

%%
fprintf('Converting from EEGLAB to SPM format...\n');
S = [];
S.dataset = [filepath basename '.set'];
D = spm_eeg_convert(S);

%%
fprintf('Renaming file...\n');
S = [];
S.D = D;
S.outfile = [filepath basename '.mat'];
D = spm_eeg_copy(S);
delete(S.D);

%%
fprintf('Setting channel type to EEG...\n');
S = [];
S.D = D;
S.task = 'settype';
S.ind = 1:size(D,1);
S.type = 'EEG';
D = spm_eeg_prep(S);

%% 
% Added
fprintf('Setting channel units to uV...\n');
S = [];
S.D = D;
D = units(D, D.indchantype('EEG'), 'uV');

%%
fprintf('Loading locations of sensors and fiducials...\n');
load([chanlocpath chanlocfile], 'sens', 'fids');
D = sensors(D,'EEG',sens);
D = fiducials(D,fids);

%%
fprintf('Projecting coordinates to 3D...\n');
S = [];
S.D = D;
S.task = 'project3D';
S.modality = 'EEG';
D = spm_eeg_prep(S);

%%
fprintf('Loading template MRI mesh...\n');
D = spm_eeg_inv_mesh_ui(D,1,1,2);

%%
fprintf('Co-registering EEG and MRI...\n');
MRIfids = D.inv{1}.mesh.fid;
mrifididx = ismember(MRIfids.fid.label, fids.fid.label);
MRIfids.fid.label = MRIfids.fid.label(mrifididx,:);
MRIfids.fid.pnt = MRIfids.fid.pnt(mrifididx,:);
EEGfids           = D.fiducials;
D = spm_eeg_inv_datareg_ui(D, 1, EEGfids, MRIfids, 1);

%% Forward modelling
D.inv{1}.forward = struct([]);
D.inv{1}.forward(1).voltype = 'EEG BEM';
D = spm_eeg_inv_forward(D);
spm_eeg_inv_checkforward(D, 1, 1);

%% Set condition
D = conditions(D, 1:D.ntrials, condname);

%%
fprintf('Saving...\n');
D.save;

%%
fprintf('Done.\n');