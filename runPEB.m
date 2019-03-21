%% PEB 
%% Collate DCMs into a GCM file
 
GCM = {
         
       'coad_modelFull.mat';
       'mami_modelFull.mat';
%        'milou_modelFull.mat';
%        'jemi_modelFull.mat';
%        'jerome_modelFull.mat';
%        'knar_modelFull.mat';
%        'mini_modelFull.mat';
%        'maju_modelFull.mat';
%        'sege_modelFull.mat';
%        'saco_modelFull.mat';
       
       };

 
%% 
% % Fully estimate model 1 if not done already

GCM(:,1) = spm_dcm_fit(GCM(:,1)); %No need because already fitted the full model 

%Use Bayesian Model Reduction to rapidly estimated DCMs 2-N for each subject if applicable
if size(GCM,2) > 1
   GCM = spm_dcm_bmr(GCM);
end

% Might only work for fMRI - which dcm fitting function is used?
% Alternatively, replace the above lines with this code to alternate between estimating
% DCMs and estimating group effects. This is slower, but can draw subjects out 
% of local optima towards the group mean.
% GCM = spm_dcm_peb_fit(GCM); % iteratively re-estimates all subjects' DCMs using the 
                            % group-average connectivity as priors.

% Write results
save('GCM_anaesthesiaTEST.mat','GCM');

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
N = size(GCM,1);
constant = ones(N,1);
% difference = [ones(1,1); ones(1,1)*-1];

M.X = [constant]; 

% Choose field
field = {'B'};

% Estimate model
[PEB, GCM_Updated] = spm_dcm_peb(GCM,M,field); %In Friston 2016 PEB = spm_dcm_bmc_peb
                                               %GCM_Updated: DCMs of all
                                               %subjects with group-level priors.
                                               
PEB(1).Ep = PEB(1).Ep .* 10^6;                                               
save('PEB_anaesthesia2.mat','PEB');
%% 

% Search over nested PEB models.

[BMA, BMR] = spm_dcm_peb_bmc(PEB(1)); % prune away any parameters from the PEB which don't contribute
                                      % to the model evidence.
                                      % BMR: To see which connections were switched on or off in the model
                                      

%BMA = spm_dcm_bmc_peb(PEB(1));% Instead,asks which combination of connectivity parameters provides 
                               % the best estimate of between-subject effects (e.g. age or 
                               % clinical scores). In other words, it scores every combination
                               % of connectivity structures and regressors
                               % (covariates). This, if interest lies in
                               % covariates (instead of connections). 
%% 
% Filenames -> DCM structures
% GCM = spm_dcm_load(GCM);

% for m = 1:length(GCM)
%     GCM_DCM{m,:} = load(GCM{m,:});
% end

% Review results
spm_dcm_peb_review(BMA,GCM);
