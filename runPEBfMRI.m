%% PEB 
%% Collate DCMs into a GCM file
 
cd 'C:\Users\rji4\Desktop\MATLAB\DCM\fMRI Tutorial on DCM & PEB\'
dm = load('design_matrix.mat')
X = dm.X;
X_labels = dm.labels;

% Load GCM
GCM=load('C:\Users\rji4\Desktop\MATLAB\DCM\fMRI Tutorial on DCM & PEB\analyses\GCM_two_models_pre_estimated.mat');
GCM=GCM.GCM;
%% 
% % Fully estimate model 1 if not done already

% GCM(:,1) = spm_dcm_fit(GCM(:,1)); %No need because already fitted the full model 
% 
% % % Use Bayesian Model Reduction to rapidly estimated DCMs 2-N for each subject if applicable
% if size(GCM_coad,2) > 1
%    GCM_coad = spm_dcm_bmr(GCM_coad);
% end
% 
% if size(GCM_mami,2) > 1
%    GCM_mami = spm_dcm_bmr(GCM_mami);
% end   
% Might only work for fMRI - which dcm fitting function is used?
% Alternatively, replace the above lines with this code to alternate between estimating
% DCMs and estimating group effects. This is slower, but can draw subjects out 
% of local optima towards the group mean.
% GCM = spm_dcm_peb_fit(GCM); % iteratively re-estimates all subjects' DCMs using the 
                            % group-average connectivity as priors.

% Write results
% save('GCM_coad_anaesthesia.mat','GCM_coad');
% save('GCM_mami_anaesthesia.mat','GCM_mami');
%% 
% Specify PEB model settings (see batch editor for help on each setting)
M = struct();
M.alpha = 1;
M.beta  = 16;
M.hE    = 0;
M.hC    = 1/16;
M.Q     = 'all';
M.maxit  = 256;

% Specify design matrix for N subjects. It should start with a constant column
M.X      = X;
M.Xnames = X_labels;

% Choose field
field = {'B'};

% Estimate model
[PEB_B,RCM_B] = spm_dcm_peb(GCM,M,field); %In Friston 2016 PEB = spm_dcm_bmc_peb
                                               %GCM_Updated: DCMs of all
                                               %subjects with group-level priors.

save('PEB_B.mat','PEB_B','RCM_B');

%% 

% Search over nested PEB models.

[BMA_B, BMR] = spm_dcm_peb_bmc(PEB_B(1)); % prune away any parameters from the PEB which don't contribute
                                      % to the model evidence.
                                      % BMR: To see which connections were switched on or off in the model
                                      

%BMA = spm_dcm_bmc_peb(PEB(1));% Instead,asks which combination of connectivity parameters provides 
                               % the best estimate of between-subject effects (e.g. age or 
                               % clinical scores). In other words, it scores every combination
                               % of connectivity structures and regressors
                               % (covariates). This, if interest lies in
                               % covariates (instead of connections). 
%% 

% Review results
spm_dcm_peb_review(BMA,GCM_DCM)
