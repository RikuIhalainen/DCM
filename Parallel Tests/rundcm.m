%   *** Specify the model options and invert model(s) using complex
%       (cross-spectra) spectral data features. Input arguments are
%       filename, model index number, and trial index number. ***

function fitdcm(datafile,modindex)

loadpaths
spm('Defaults','EEG'); % SPM-EEG modality interface, default settings


%% 
%--------------------------------------------------------------------------
% Location priors for dipoles - names and prior mean locations 
%--------------------------------------------------------------------------

locs = {
    [-46 -66 30]  'lLPdmn'      %1.
    [49 -63 33]   'rLPdmn'      %2.
    [0 -52 7]     'Prec/PCC'    %3.
    [-1 54 27]    'mPFC'        %4.
    
    [-62 -45 30]  'lLPsal'      %5.
    [62 -45 30]   'rLPsal'      %6.
    [0 21 36]     'dACC'        %7.
    [-35 45 30]   'laPFCsal'    %8.
    [32 45 30]    'raPFCsal'    %9.
    
    [-50 -51 45]  'lSP'         %10.
    [50 -51 45]   'rSP'         %11.
    [0 24 46]     'dmPFC'       %12.
    [-44 45 0]    'laPFCcen'    %13.
    [44 45 0]     'raPFCcen'    %14.
    
    };

netnodes = {
    'DMN' [1 2 3 4];
    'SAL' [5 6 7 8 9];
    'CEN' [10 11 12 13 14];
            };
        
DCM.Lpos = cell2mat(locs(netnodes{modindex,2},1))';
DCM.Sname = locs(netnodes{modindex,2},2);
Nareas    = length(locs(netnodes{modindex,2},1)); 
% 
%% Specify connectivity model - specification of the neuronal model
%--------------------------------------------------------------------------

%DMN
if modindex == 1 

    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(3,1) = 1; %lLPdmn forward connection on Prec
    DCM.A{1}(4,1) = 1; %lLPdmn forward connection on mPFC
    DCM.A{1}(3,2) = 1; %rLPdmn forward connection on Prec
    DCM.A{1}(4,2) = 1; %rLPdmn forward connection on mPFC
    DCM.A{1}(4,3) = 1; %Prec forward connection on mPFC
    
    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(1,3) = 1; %Prec backward connection on lLPdmn
    DCM.A{2}(2,3) = 1; %Prec backward connection on rLPdmn
    DCM.A{2}(1,4) = 1; %mPFC backward connection on lLPdmn
    DCM.A{2}(2,4) = 1; %mPFC backward connection on rLPdmn
    DCM.A{2}(3,4) = 1; %mPFC backward connection on Prec
    
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(2,1) = 1; %lLPdmn lateral connection to rLPdmn
    DCM.A{3}(1,2) = 1; %rLPdmn lateral connection to lLPdmn
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};     
%-------------------------------------------------------    
%SALIENCE
elseif modindex == 2
    
    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(7,5) = 1; %lLPsal forward connection on dACC
    DCM.A{1}(8,5) = 1; %lLPsal forward connection on laPFCsal
    DCM.A{1}(7,6) = 1; %rLPsal forward connection on dACC
    DCM.A{1}(9,6) = 1; %rLPsal forward connection on raPFCsal
    DCM.A{1}(7,8) = 1; %laPFCsal forward connection on dACC
    DCM.A{1}(7,9) = 1; %raPFCsal forward connection on dACC   
    
    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(5,7) = 1; %dACC backward connection on lLPsal
    DCM.A{2}(6,7) = 1; %dACC backward connection on rLPsal
    DCM.A{2}(8,7) = 1; %dACC backward connection on laPFCsal
    DCM.A{2}(9,7) = 1; %dACC backward connection on raPFCsal
    DCM.A{2}(5,8) = 1; %laPFCsal backward connection on lLPsal
    DCM.A{2}(6,9) = 1; %raPFCsal backward connection on rLPsal
    
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(6,5) = 1; %lLPsal lateral connection to rLPsal
    DCM.A{3}(5,6) = 1; %rLPsal lateral connection to lLPsal
    DCM.A{3}(9,8) = 1; %laPFCsal lateral connection to raPFCsal
    DCM.A{3}(8,9) = 1; %rPFCsal lateral connection to laPFCsal
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
%-------------------------------------------------------
% CENTRAL EXECUTIVE
elseif modindex == 3 

    DCM.A{1} = zeros(Nareas,Nareas);
    DCM.A{1}(13,10) = 1; %lSP forward connection on laPFCcen
    DCM.A{1}(12,10) = 1; %lSP forward connection on dmPFC
    DCM.A{1}(14,11) = 1; %rSP forward connection on raPFCcen
    DCM.A{1}(12,11) = 1; %rSP forward connection on dmPFC
    DCM.A{1}(12,13) = 1; %laPFCcen forward connection on dmPFC
    DCM.A{1}(12,14) = 1; %raPFCcen forward connection on dmPFC

    DCM.A{2} = zeros(Nareas,Nareas);
    DCM.A{2}(10,13) = 1; %laPFCcen backward connection on lSP
    DCM.A{2}(11,14) = 1; %raPFCcen backward connection on rSP
    DCM.A{2}(10,12) = 1; %dmPFC backward connection on lSP
    DCM.A{2}(13,12) = 1; %dmPFC backward connection on laPFCcen
    DCM.A{2}(11,12) = 1; %dmPFC backward connection on rSP
    DCM.A{2}(14,12) = 1; %dmPFC backward connection on raPFCcen
    
    DCM.A{3} = zeros(Nareas,Nareas);
    DCM.A{3}(11,10) = 1; %lSP lateral connection to rSP
    DCM.A{3}(10,11) = 1; %rSP lateral connection to lSP
    DCM.A{3}(14,13) = 1; %laPFCcen lateral connection to raPFCcen
    DCM.A{3}(13,14) = 1; %raPFCcen lateral connection to laPFCcen
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};

end
%--------------------------------------------------------------------------
%%

% Model specification
DCM.xY.Dfile = [filepath datafile '.mat'];  % data file
DCM.options.analysis = 'CSD';  % analyze evoked responses/cross-spectral densities

DCM.options.model    = 'ERP';  % ERP model (neural mass model)
%DCM.options.model   = 'CMC';  % CMC model (neural mass model)
DCM.options.spatial  = 'IMG';  % spatial model (forward model)
%DCM.options.spatial = 'LFP';  % LFP if source reconstructed data
                               %(forward model)
% DCM.options.trials  = [1];
DCM.options.trials   = [1 2]; 
DCM.options.Tdcm(1)  = 0;      % start of peri-stimulus time to be modelled (ms)
DCM.options.Tdcm(2)  = 10000;  % end of peri-stimulus time to be modelled (ms)
DCM.options.Nmodes   = 8;      % number of spatial modes to invert (10 for large 
                               % scale in Razi et al.(2017)
DCM.options.h        = 1;      % number of DCT components
%DCM.options.onset   = 100;    % selection of onset (prior mean)
DCM.options.D        = 1;      % down-sampling
%DCM.options.dur     = 128;    % stimulus dispersion (standard deviations) in ms
DCM.options.han      = 0;      % hanning
DCM.options.Fdcm     = [1 45]; % frequency windows in Hz



%contrast vector
% DCM.xU.X = [];
DCM.xU.X = [0 1]';
DCM = spm_dcm_erp_data(DCM,0); % prepares structures for forward model
DCM = spm_dcm_erp_dipfit(DCM); % prepares structures for ECD forward model
DCM = spm_dcm_csd_data(DCM); % gets cross-spectral density data-features using a VAR model
DCM.options.DATA = 0;

%%
% Fitting of DCM models

fprintf('\n\n\n*** Processing model %d (%s) ***\n\n\n', modindex, (netnodes{modindex,1}));
DCM = spm_dcm_csd(DCM); % Estimate parameters of a DCM (complex) cross-spectral density
save([datafile '_model' (netnodes{modindex,1}) '.mat'],'DCM')
end
