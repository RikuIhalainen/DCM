%   *** Specify the model options and invert model(s) using complex 
%       (cross-spectra) spectral data features. Input arguments are 
%       filename, model index number, and trial index number. ***

function fit_DCM(file,modindex)
%%
paths % Load filepath from paths.m% 
spm('Defaults','EEG'); % SPM-EEG modality interface, default settings


% Load model
    models % Load model list
    scheme = list{modindex};
    load(scheme);
        A = DCM.A;
        B = DCM.B;
        Lpos = DCM.Lpos;
        Sname = DCM.Sname;

%%
% Model specification
    DCM.xY.Dfile = [filepath file '.mat'];  % data file  
    DCM.options.analysis = 'CSD';  % analyze evoked responses/cross-spectral densities 
                                   %(data deature to be modeled)
    DCM.options.model    = 'ERP';  % ERP model (neural mass model)
    %DCM.options.model   = 'CMC';  % CMC model (neural mass model)
    DCM.options.spatial  = 'IMG';  % spatial model (forward model)
    %DCM.options.spatial = 'LFP';  % LFP if source reconstructed data
                                   %(forward model)
    DCM.options.trials   = 1 %[1 2];  % index of ERPs within ERP/indices of trials
    DCM.options.Tdcm(1)  = 0;      % start of peri-stimulus time to be modelled (ms)
    DCM.options.Tdcm(2)  = 10000;  % end of peri-stimulus time to be modelled (ms)
    DCM.options.Nmodes   = 8;      % number of spatial modes to invert
    DCM.options.h        = 1;      % number of DCT components
    %DCM.options.onset    = 100;    % selection of onset (prior mean)
    DCM.options.D        = 1;      % down-sampling
    %DCM.options.dur = 128;        % stimulus dispersion (standard deviations) in ms
    DCM.options.han = 0;           % hanning
    DCM.options.Fdcm  = [1 45];    % frequency windows in Hz

    DCM.Lpos  = Lpos;
    DCM.Sname = Sname;

    DCM.A = A;
    DCM.B = B;
    
  DCM.XU.X = [];
    %DCM.xU.X = [zeros(1,60) ones(1,60)];
    DCM  = spm_dcm_erp_data(DCM); % prepares structures for forward model
    DCM = spm_dcm_erp_dipfit(DCM,0); % prepares structures for ECD forward model
    DCM = spm_dcm_csd_data(DCM); % gets cross-spectral density data-features using a VAR model
    DCM.options.DATA = 0;    

%%
% Fitting of DCM models
    fprintf('\n\n\n*** Processing model %d (%s) ***\n\n\n', modindex, list{modindex} );       
    load([filepath file '.mat'])
    DCM = spm_dcm_csd(DCM); % Estimate parameters of a DCM (complex) cross-spectral density
    save([file '_model' num2str(modindex) '.mat'],'DCM')
end
