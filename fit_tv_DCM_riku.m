%   *** Dynamic Causal Modeling for Cross-Spectral Densities ***
% -------------------------------------------------------------------------

%%
% Load subject list and loop through it

% loadsubj
% numsubj = size(allsubj,1);

 for s = 1:numsubj    
%     subjname = allsubj{s};
%     fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s,subjname); 
     
% ------------------------------------------------------------------------- 
%%
%  *** NEURONAL MODELS ***

%  *** Option 1 - Loads model list and estimates the models in that list.
%      Template models need to be created first via GUI (e.g. DMN.mat) ***

%  *** Option 2 - Models and connections are defined in code ***

% -------------------------------------------------------------------------
%%
%   Option 1

    models % Load model list
    DCMs = size(mod,1);
    for m = 1:DCMs
        scheme = mod{m};
        fprintf('\n\n\n*** Processing model %d (%s) ***\n\n\n', m, list{m} );        

        spm('Defaults','EEG') % SPM-EEG modality interface, default settings
        
% -------------------------------------------------------------------------

% Load models
        cd C:\Users\rji4\Desktop\MATLAB\DCM\Anaesthesia 
        load(scheme)
        A = DCM.A;
        B = DCM.B;
        Lpos = DCM.Lpos;
        Sname = DCM.Sname;
        
% Specify data        
        fold = dir(fullfile(['spmeeg_coad_01.mat'])) %for loop, change to 'subjname'
        clear DCM

% -------------------------------------------------------------------------
%%
%   Option 2 - Define neural field models & connections


% -------------------------------------------------------------------------

        %% uncomment when you have to relabel the conditions labels/epochs of the trials
        % for i = 1:60
        % tmp{i} = num2str(i);end
        % D = spm_eeg_load('[fold(i).name(1:end-4)]')
        % D = conditions(D,1:60,tmp);
        % D.conditions
        % D.save
        % clear D
% -------------------------------------------------------------------------
%%
% Specify models
        for isub = 1:length(fold)

            for iwin = 1%:60 % windows/epochs

            DCM.xY.Dfile = [fold(isub).name(1:end-4)]  % data file  
            DCM.options.analysis = 'CSD';  % analyze evoked responses/cross-spectral densities 
                                           %(data deature to be modeled)
            DCM.options.model    = 'ERP';  % ERP model (neural mass model)
            %DCM.options.model    = 'CMC';  % CMC model (neural mass model)
            DCM.options.spatial  = 'IMG';  % spatial model (forward model)
            %DCM.options.spatial  = 'LFP';  % LFP if source reconstructed data
                                           %(forward model)
            DCM.options.trials   = [iwin]; % index of ERPs within ERP/indices of trials
            DCM.options.Tdcm(1)  = 0;      % start of peri-stimulus time to be modelled (ms)
            DCM.options.Tdcm(2)  = 10000;  % end of peri-stimulus time to be modelled (ms)
            DCM.options.Nmodes   = 8;      % number of spatial modes to invert
            DCM.options.h        = 1;      % number of DCT components
            DCM.options.onset    = 100;    % selection of onset (prior mean)
            DCM.options.D        = 1;      % down-sampling
            %DCM.options.dur = 128;         % stimulus dispersion (standard deviations) in ms
            DCM.options.han = 0;           % hanning
            DCM.options.Fdcm  = [1 48];    % frequency windows in Hz

            DCM.Lpos  = Lpos;
            DCM.Sname = Sname;

            DCM.A = A;
            DCM.B = B;
            DCM  = spm_dcm_erp_data(DCM); % prepares structures for forward model
            DCM = spm_dcm_erp_dipfit(DCM,0); % prepares structures for ECD forward model
            DCM = spm_dcm_csd_data(DCM); % gets cross-spectral density data-features using a VAR model
            DCM.options.DATA = 0;
            save(['DCM_trial' num2str(iwin) '_sub' num2str(isub) '_model' num2str(m)],'DCM')
            end
        end
    end

% -------------------------------------------------------------------------
%%

% Fitting of DCM models
        fprintf('\n\n\n*** Processing model %d (%s) ***\n\n\n', m, list{m} );
        fold2 = dir(fullfile([pwd '/DCM*']))
        for isub = 1:length(fold2)

            load([fold2(isub).name(1:end-4)])
            DCM = spm_dcm_csd(DCM) % Estimate parameters of a DCM (complex) cross-spectral density
            save([fold2(isub).name(1:end-4) '_results'],'DCM');

        end
%end
% -------------------------------------------------------------------------

%% If source reconstructed data, to change 'D'
 
% methods('meeg')
 
% D = clone(D,['/home/frederik/data/EEG_rest/spm_data/spm_meeg_' fold(i).name(1:end-4)],[Nsources Ntime Ntrials],1)
% D = source_recon_mat_file; %%%put in source reconstructed data
% D = chantype(D, [1:size(source_recon_mat_file,1)], 'LFP')
% D.save;

% -------------------------------------------------------------------------

%%
% *** Parametric Empirical Bayes (PEB) ***

% Collate DCMs into a GCM file
% GCM = {'DCM_trial1_subject1_model1.mat','DCM_trial1_subject1_model2.mat'...
      ...'DCM_trial1_subject2_model1.mat','DCM_trial1_subject2_model2.mat'};
% ensure that the first model for each subject is a 'full' model containing all 
% connections of interest. Any subsequent models should be 'nested' models.

% Fully estimate model 1 (should be the full model)
% GCM(:,1) = spm_dcm_fit(GCM(:,1));

% Use Bayesian Model Reduction to rapidly estimate DCMs 2-N for each
% subject 
% if size(GCM,2) > 1
%    GCM = spm_dcm_bmr(GCM);
 %end

% Alternatively, replace with this code to alternate between estimating
% DCMs and estimating group effects. Slower, but can draw subjects out of
% local optima towards the group mean.
% GCM = spm_dcm_peb_fit(GCM);

% Write results
% save('GCM_example.mat', 'GCM');
% -------------------------------------------------------------------------
% *** Estimate a second level PEB model

% Specify PEB model settings
% M = struct();
% M.alpha = 1;
% M.beta = 16;
% M.hE = 0;
% M.hC = 1/16;
% M.Q = 'all';

% Specify design matrix for N subjects. Should start with a constant column
% M.X = ones(N,1);

% Choose field
% field = {'A'};

% Estimate model
% PEB = spm_dcm_peb(GCM,M,field);

% save('PEB_example.mat','PEB');
% -------------------------------------------------------------------------

% *** Compare the full PEB to nested PEB models (for specific hypotheses) ***

% BMA = spm_dcm_peb_bmc(PEB(1), GCM(1,:));
% -------------------------------------------------------------------------

% *** Search over nested PEB models (prune away parameters) ***

% Search over nested PEB models
% BMA = spm_dcm_peb_bmc(PEB(1));
% -------------------------------------------------------------------------

% *** Review results ***

% spm_dcm_peb_review(BMA,GCM)
% -------------------------------------------------------------------------

% *** Leave-one-out cross validation ***

% Perform
% spm_dcm_loo(GCM,M,field);

% A PEB model will now be estimated while leaving out a subject, and will 
% be used to predict the first between-subjects effect (after the constant 
% column) in the design matrix, based on the specific connections chosen
% -------------------------------------------------------------------------
