%% PEB 
%% Collate DCMs into a GCM file
 
GCM_maju = {
            'maju_01_modelFull.mat';
            'maju_03_modelFull.mat';
            };
        
GCM_saco = {
            'saco_01_modelFull.mat';
            'saco_03_modelFull.mat';
            };        

GCM_sege = {
            'sege_01_modelFull.mat';
            'sege_03_modelFull.mat';
            }; 
        
GCM_mini = {
            'mini_01_modelFull.mat';
            'mini_03_modelFull.mat';
            };        

GCM_knar = {
            'knar_01_modelFull.mat';
            'knar_03_modelFull.mat';
            };
        
GCM_jemi = {
            'jemi_01_modelFull.mat';
            'jemi_03_modelFull.mat';
            };        
        
GCM_jerome = {
            'jerome_01_modelFull.mat';
            'jerome_03_modelFull.mat';
            };        

GCM_coad = {
            'coad_01_modelFull.mat';
            'coad_03_modelFull.mat';
            };
        
GCM_mami = {
            'mami_01_modelFull.mat';
            'mami_03_modelFull.mat';
            };
        
GCM_milou = {
            'milou_01_modelFull.mat';
            'milou_03_modelFull.mat';
            };


%% 
% % Fully estimate model 1 if not done already


% GCM_coad(:,1) = spm_dcm_fit(GCM_coad(:,1)); %No need because already fitted the full model 
%
 
% % % Use Bayesian Model Reduction to rapidly estimated DCMs 2-N for each subject if applicable

% if size(GCM_coad,2) > 1
%    GCM_coad = spm_dcm_bmr(GCM_coad);
% end

% Might only work for fMRI - which dcm fitting function is used?
% Alternatively, replace the above lines with this code to alternate between estimating
% DCMs and estimating group effects. This is slower, but can draw subjects out 
% of local optima towards the group mean.
% GCM = spm_dcm_peb_fit(GCM); % iteratively re-estimates all subjects' DCMs using the 
                            % group-average connectivity as priors.

% Write results
save('GCM_coad_anaesthesia.mat','GCM_coad');
save('GCM_mami_anaesthesia.mat','GCM_mami');
save('GCM_milou_anaesthesia.mat','GCM_milou');
save('GCM_maju_anaesthesia.mat','GCM_maju');
save('GCM_jerome_anaesthesia.mat','GCM_jerome');
save('GCM_jemi_anaesthesia.mat','GCM_jemi');
save('GCM_knar_anaesthesia.mat','GCM_knar');
save('GCM_mini_anaesthesia.mat','GCM_mini');
save('GCM_saco_anaesthesia.mat','GCM_saco');
save('GCM_sege_anaesthesia.mat','GCM_sege');
%% 
% Specify PEB model settings (see batch editor for help on each setting)
M = struct();
M.alpha = 1;
M.beta  = 16;
M.hE    = 0;
M.hC    = 1/16;
M.Q     = 'all';

% Specify design matrix for N subjects. It should start with a constant column
constant = ones(2,1);
difference = [ones(1,1); ones(1,1)*-1];

M.X = [constant,difference]; 

% Choose field
field = {'B'};

% Estimate model
[PEBcoad, GCM_Updated_1] = spm_dcm_peb(GCM_coad,M); %In Friston 2016 PEB = spm_dcm_bmc_peb
                                                    %GCM_Updated: DCMs of all
                                                    %subjects with group-level priors.
[PEBmami, GCM_Updated_2] = spm_dcm_peb(GCM_mami,M);
[PEBmilou, GCM_Updated_3] = spm_dcm_peb(GCM_milou,M);
[PEBmaju, GCM_Updated_4] = spm_dcm_peb(GCM_maju,M);
% [PEBjerome, GCM_Updated_5] = spm_dcm_peb(GCM_jerome,M);
% [PEBjemi, GCM_Updated_6] = spm_dcm_peb(GCM_jemi,M);
% [PEBknar, GCM_Updated_7] = spm_dcm_peb(GCM_knar,M);
% [PEBmini, GCM_Updated_8] = spm_dcm_peb(GCM_mini,M);
% [PEBsaco, GCM_Updated_9] = spm_dcm_peb(GCM_saco,M);
% [PEBsege, GCM_Updated_10] = spm_dcm_peb(GCM_sege,M);


% save('PEB_coad_anaesthesia.mat','PEBcoad');
% save('PEB_mami_anaesthesia.mat','PEBmami');
% save('PEB_milou_anaesthesia.mat','PEBmilou');
% save('PEB_maju_anaesthesia.mat','PEBmaju');
% save('PEB_jerome_anaesthesia.mat','PEBjerome');
% save('PEB_jemi_anaesthesia.mat','PEBjemi');
% save('PEB_knar_anaesthesia.mat','PEBknar');
% save('PEB_mini_anaesthesia.mat','PEBmini');
% save('PEB_saco_anaesthesia.mat','PEBsaco');
% save('PEB_sege_anaesthesia.mat','PEBsege');
%% Group PEB
PEBS = {
        PEBcoad;
        PEBmami;
        PEBmilou;
        PEBmaju
        PEBjerome;
        PEBjemi;
        PEBknar;
        PEBmini;
        PEBsaco;
        PEBsege;
        };
% 
% 
  N = size(PEBS,2);
  M.X = ones(M,1);
% 
% PEB = spm_dcm_peb(PEBS,M);

save('PEB_Group.mat','PEB');
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
GCM_all = [GCM_coad; GCM_jemi; GCM_jerome; GCM_knar; GCM_maju; GCM_mami; ...
GCM_milou; GCM_mini; GCM_saco; GCM_sege];
% 
% for m = 1:length(GCM_both)
%     GCM_DCM{m,:} = load(GCM_both{m,:});  
% end
% Review results
spm_dcm_peb_review(BMA,GCM_maju)
