%   *** Specify the model options and invert model(s) using complex
%       (cross-spectra) spectral data features. Input arguments are
%       filename, model index number, and trial index number. ***

function fitdcm(datafile,modindex)

loadpaths
spm('Defaults','EEG'); % SPM-EEG modality interface, default settings
     
% models = {
%     'DMN'
%     'SAL'
%     };
% 
% DCM = models{modindex};
% load([filepath DCM '.mat'],'DCM');

%% 
%--------------------------------------------------------------------------
% Location priors for dipoles - names and prior mean locations 
%--------------------------------------------------------------------------

locs = {
    [-46 -66 30]  'lLPdmn'
    [49 -63 33]   'rLPdmn'
    [-62 -45 30]  'lLPsal'
    [62 -45 30]   'rLPsal'
    [0 -52 7]     'Prec/PCC'
    [0 21 36]     'dACC'
    [-35 45 30]   'laPFCsal'
    [32 45 30]    'raPFCsal'
    [-1 54 27]    'mPFC'
    [0 24 46]     'dmPFC'
    [-44 45 0]    'laPFCcen'
    [44 45 0]     'raPFCcen'
    [-50 -51 45]  'lSP'
    [50 -51 45]   'rSP'
    };

DCM.Lpos = cell2mat(locs(:,1))';
DCM.Sname = {'lLPdmn', 'rLPdmn', 'lLPsal','rLPsal', 'Prec', 'dACC', 'laPFC', 'raPFC', ...
'mPFC', 'dmPFC', 'laPFCcen', 'raPFCcen', 'lSP', 'rSP'};
Nareas    = size(locs,1);
% 
%% Specify connectivity model - specification of the neuronal model; instead
%  of radio buttons
%--------------------------------------------------------------------------
models = {
          'DMN'
          'SAL'
          'CEN'
          'Full'
                };
for m = modindex

%---------------------------------------------------------------------
%DMN
    if m == 1 

    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(5,1) = 1; %lLPdmn forward connection on Prec
    DCM.A{1}(9,1) = 1; %lLPdmn forward connection on mPFC
    DCM.A{1}(5,2) = 1; %rLPdmn forward connection on Prec
    DCM.A{1}(9,2) = 1; %rLPdmn forward connection on mPFC
    DCM.A{1}(9,5) = 1; %Prec forward connection on mPFC
    
    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(1,5) = 1; %Prec backward connection on lLPdmn
    DCM.A{2}(2,5) = 1; %Prec backward connection on rLPdmn
    DCM.A{2}(1,9) = 1; %mPFC backward connection on lLPdmn
    DCM.A{2}(2,9) = 1; %mPFC backward connection on rLPdmn
    DCM.A{2}(5,9) = 1; %mPFC backward connection on Prec
    
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(2,1) = 1; %lLPdmn lateral connection to rLPdmn
    DCM.A{3}(1,2) = 1; %rLPdmn lateral connection to lLPdmn
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};     
    
%---------------------------------------------------------------------
%SALIENCE
    elseif m == 2

    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(6,3) = 1; %lLPsal forward connection on dACC
    DCM.A{1}(7,3) = 1; %lLPsal forward connection on laPFCsal
    DCM.A{1}(6,4) = 1; %rLPsal forward connection on dACC
    DCM.A{1}(8,4) = 1; %rLPsal forward connection on raPFCsal
    DCM.A{1}(6,7) = 1; %laPFCsal forward connection on dACC
    DCM.A{1}(6,8) = 1; %raPFCsal forward connection on dACC

    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(3,6) = 1; %dACC backward connection on lLPsal
    DCM.A{2}(4,6) = 1; %dACC backward connection on rLPsal
    DCM.A{2}(7,6) = 1; %dACC backward connection on laPFCsal
    DCM.A{2}(8,6) = 1; %dACC backward connection on raPFCsal
    DCM.A{2}(3,7) = 1; %laPFCsal backward connection on lLPsal
    DCM.A{2}(4,8) = 1; %raPFCsal backward connection on rLPsal
    
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(4,3) = 1; %lLPsal lateral connection to rLPsal
    DCM.A{3}(3,4) = 1; %rLPsal lateral connection to lLPsal
    DCM.A{3}(8,7) = 1; %laPFCsal lateral connection to raPFCsal
    DCM.A{3}(7,8) = 1; %rPFCsal lateral connection to laPFCsal
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    
%---------------------------------------------------------------------
%CENTRAL EXECUTIVE 
    elseif m == 3 

    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(11,13) = 1; %lSP forward connection on laPFCcen
    DCM.A{1}(10,13) = 1; %lSP forward connection on dmPFC
    DCM.A{1}(12,14) = 1; %rSP forward connection on raPFCcen
    DCM.A{1}(10,14) = 1; %rSP forward connection on dmPFC
    DCM.A{1}(10,11) = 1; %laPFCcen forward connection on dmPFC
    DCM.A{1}(10,12) = 1; %raPFCcen forward connection on dmPFC

    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(13,11) = 1; %laPFCcen backward connection on lSP
    DCM.A{2}(14,12) = 1; %raPFCcen backward connection on rSP
    DCM.A{2}(13,10) = 1; %dmPFC backward connection on lSP
    DCM.A{2}(11,10) = 1; %dmPFC backward connection on laPFCcen
    DCM.A{2}(14,10) = 1; %dmPFC backward connection on rSP
    DCM.A{2}(12,10) = 1; %dmPFC backward connection on raPFCcen
    
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(14,13) = 1; %lSP lateral connection to rSP
    DCM.A{3}(13,14) = 1; %rSP lateral connection to lSP
    DCM.A{3}(12,11) = 1; %laPFCcen lateral connection to raPFCcen
    DCM.A{3}(11,12) = 1; %raPFCcen lateral connection to laPFCcen
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    
%---------------------------------------------------------------------  
%FULL MODEL
    elseif m == 4 
    
    %Forward    
    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(5,1) = 1; %lLPdmn forward connection on Prec
    DCM.A{1}(9,1) = 1; %lLPdmn forward connection on mPFC
    DCM.A{1}(5,2) = 1; %rLPdmn forward connection on Prec
    DCM.A{1}(9,2) = 1; %rLPdmn forward connection on mPFC
    DCM.A{1}(9,5) = 1; %Prec forward connection on mPFC
    DCM.A{1}(6,3) = 1; %lLPsal forward connection on dACC
    DCM.A{1}(7,3) = 1; %lLPsal forward connection on laPFCsal
    DCM.A{1}(6,4) = 1; %rLPsal forward connection on dACC
    DCM.A{1}(8,4) = 1; %rLPsal forward connection on raPFCsal
    DCM.A{1}(6,7) = 1; %laPFCsal forward connection on dACC
    DCM.A{1}(6,8) = 1; %raPFCsal forward connection on dACC
    DCM.A{1}(11,13) = 1; %lSP forward connection on laPFCcen
    DCM.A{1}(10,13) = 1; %lSP forward connection on dmPFC
    DCM.A{1}(12,14) = 1; %rSP forward connection on raPFCcen
    DCM.A{1}(10,14) = 1; %rSP forward connection on dmPFC
    DCM.A{1}(10,11) = 1; %laPFCcen forward connection on dmPFC
    DCM.A{1}(10,12) = 1; %raPFCcen forward connection on dmPFC

    %Between Network Connections
    DCM.A{1}(5,13) = 1; %lSP forward connection on Prec CEN-DMN
    DCM.A{1}(5,14) = 1; %rSP forward connection on Prec CEN-DMN
    DCM.A{1}(6,5) = 1; %Prec forward connection on dACC DMN-SAL

    %Backward
    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(1,5) = 1; %Prec backward connection on lLPdmn
    DCM.A{2}(2,5) = 1; %Prec backward connection on rLPdmn
    DCM.A{2}(1,9) = 1; %mPFC backward connection on lLPdmn
    DCM.A{2}(2,9) = 1; %mPFC backward connection on rLPdmn
    DCM.A{2}(5,9) = 1; %mPFC backward connection on Prec
    DCM.A{2}(3,6) = 1; %dACC backward connection on lLPsal
    DCM.A{2}(4,6) = 1; %dACC backward connection on rLPsal
    DCM.A{2}(7,6) = 1; %dACC backward connection on laPFCsal
    DCM.A{2}(8,6) = 1; %dACC backward connection on raPFCsal
    DCM.A{2}(3,7) = 1; %laPFCsal backward connection on lLPsal
    DCM.A{2}(4,8) = 1; %raPFCsal backward connection on rLPsal
    DCM.A{2}(13,11) = 1; %laPFCcen backward connection on lSP
    DCM.A{2}(14,12) = 1; %raPFCcen backward connection on rSP
    DCM.A{2}(13,10) = 1; %dmPFC backward connection on lSP
    DCM.A{2}(11,10) = 1; %dmPFC backward connection on laPFCcen
    DCM.A{2}(14,10) = 1; %dmPFC backward connection on rSP
    DCM.A{2}(12,10) = 1; %dmPFC backward connection on raPFCcen 

    %Between Network Connections
    DCM.A{2}(13,5) = 1; %Prec backward connection on lSP DMN-CEN
    DCM.A{2}(14,5) = 1; %Prec backward connection on rSP DMN-CEN
    DCM.A{2}(5,6) = 1; %dACC backward connection on Prec SAL-DMN

    %Lateral
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(2,1) = 1; %lLPdmn lateral connection to rLPdmn
    DCM.A{3}(1,2) = 1; %rLPdmn lateral connection to lLPdmn
    DCM.A{3}(4,3) = 1; %lLPsal lateral connection to rLPsal
    DCM.A{3}(3,4) = 1; %rLPsal lateral connection to lLPsal
    DCM.A{3}(8,7) = 1; %laPFCsal lateral connection to raPFCsal
    DCM.A{3}(7,8) = 1; %raPFCsal lateral connection to laPFCsal
    DCM.A{3}(14,13) = 1; %lSP lateral connection to rSP
    DCM.A{3}(13,14) = 1; %rSP lateral connection to lSP
    DCM.A{3}(12,11) = 1; %laPFCcen lateral connection to raPFCcen
    DCM.A{3}(11,12) = 1; %raPFCcen lateral connection to laPFCcen

    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
      
   end
end
%--------------------------------------------------------------------------
%%

% Model specification
DCM.xY.Dfile = [filepath datafile '.mat'];  % data file
DCM.options.analysis = 'CSD';  % analyze evoked responses/cross-spectral densities
%(data deature to be modeled)
DCM.options.model    = 'ERP';  % ERP model (neural mass model)
%DCM.options.model   = 'CMC';  % CMC model (neural mass model)
DCM.options.spatial  = 'IMG';  % spatial model (forward model)
%DCM.options.spatial = 'LFP';  % LFP if source reconstructed data
%(forward model)
%DCM.options.trials   = [];% Change back to [1 2] -index of ERPs within ERP/indices of trials
DCM.options.trials   = [1 2]; 
DCM.options.Tdcm(1)  = 0;      % start of peri-stimulus time to be modelled (ms)
DCM.options.Tdcm(2)  = 10000;  % end of peri-stimulus time to be modelled (ms)
DCM.options.Nmodes   = 8;      % number of spatial modes to invert (10 for large 
                               % scale in Razi et al.(2017)
DCM.options.h        = 1;      % number of DCT components
%DCM.options.onset    = 100;    % selection of onset (prior mean)
DCM.options.D        = 1;      % down-sampling
%DCM.options.dur = 128;        % stimulus dispersion (standard deviations) in ms
DCM.options.han = 0;           % hanning
DCM.options.Fdcm  = [1 45];    % frequency windows in Hz

% DCM.xU.X = [];

%contrast vector
DCM.xU.X = [0 1]';
DCM = spm_dcm_erp_data(DCM,0); % prepares structures for forward model
DCM = spm_dcm_erp_dipfit(DCM); % prepares structures for ECD forward model
DCM = spm_dcm_csd_data(DCM); % gets cross-spectral density data-features using a VAR model
DCM.options.DATA = 0;

%%
% Fitting of DCM models

fprintf('\n\n\n*** Processing model %d (%s) ***\n\n\n', modindex, models{m});
% DCM = spm_dcm_csd(DCM); % Estimate parameters of a DCM (complex) cross-spectral density
save([datafile '_model' models{m} '.mat'],'DCM')
end
