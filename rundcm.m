%   *** Specify the model options and invert model(s) using complex
%       (cross-spectra) spectral data features. Input arguments are
%       filename, model index number, and trial index number. ***

function DCM = rundcm(datafile,modindex)

loadpaths
spm('Defaults','EEG'); % SPM-EEG modality interface, default settings


%% 
%--------------------------------------------------------------------------
% Location priors for dipoles - names and prior mean locations 
%--------------------------------------------------------------------------
%------------------------
if modindex == 1
locs = {
    [-46 -66 30]  'lLPdmn'      %1.
    [49 -63 33]   'rLPdmn'      %2.
    [0 -52 7]     'Prec/PCC'    %3.
    [-1 54 27]    'mPFC'        %4.
        };
DCM.Sname = locs(:,2);

lLPdmn = 1;
rLPdmn = 2;
Prec = 3;
mPFC = 4;
%------------------------
elseif modindex == 2
locs = {
    [-62 -45 30]  'lLPsal'      %1.
    [62 -45 30]   'rLPsal'      %2.
    [0 21 36]     'dACC'        %3.
    [-35 45 30]   'laPFCsal'    %4.
    [32 45 30]    'raPFCsal'    %5.
        };
DCM.Sname = locs(:,2);

lLPsal = 1;
rLPsal = 2;
dACC = 3;
laPFCsal = 4;
raPFCsal = 5;
%------------------------
elseif modindex == 3    
locs = {
    [-50 -51 45]  'lSP'         %1.
    [50 -51 45]   'rSP'         %2.
    [0 24 46]     'dmPFC'       %3.
    [-44 45 0]    'laPFCcen'    %4.
    [44 45 0]     'raPFCcen'    %5.
        };
DCM.Sname = locs(:,2);

lSP = 1;
rSP = 2;
dmPFC = 3;
laPFCcen = 4;
raPFCcen = 5;
%------------------------
elseif modindex == 4
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

DCM.Sname = locs(:,2);

lLPdmn = 1;
rLPdmn = 2;
Prec = 3;
mPFC = 4;
lLPsal = 5;
rLPsal = 6;
dACC = 7;
laPFCsal = 8;
raPFCsal = 9;
lSP = 10;
rSP = 11;
dmPFC = 12;
laPFCcen = 13;
raPFCcen = 14;
%------------------------
end

forward = 1;
backward = 2;
lateral = 3;
DCM.Lpos = cell2mat(locs(:,1))';
Nareas = size(locs,1); 


%% Specify connectivity model - specification of the neuronal model
%--------------------------------------------------------------------------
models = {
        'DMN'
        'SAL'
        'CEN'
        'Full'
           };

%DMN
if modindex == 1 

    DCM.A{forward} = zeros(Nareas,Nareas);
    DCM.A{forward}(Prec,lLPdmn) = 1; %lLPdmn forward connection on Prec
    DCM.A{forward}(mPFC,lLPdmn) = 1; %lLPdmn forward connection on mPFC
    DCM.A{forward}(Prec,rLPdmn) = 1; %rLPdmn forward connection on Prec
    DCM.A{forward}(mPFC,rLPdmn) = 1; %rLPdmn forward connection on mPFC
    DCM.A{forward}(mPFC,Prec) = 1; %Prec forward connection on mPFC
    
    DCM.A{backward} = zeros(Nareas,Nareas);
    DCM.A{backward}(lLPdmn,Prec) = 1; %Prec backward connection on lLPdmn
    DCM.A{backward}(rLPdmn,Prec) = 1; %Prec backward connection on rLPdmn
    DCM.A{backward}(lLPdmn,mPFC) = 1; %mPFC backward connection on lLPdmn
    DCM.A{backward}(rLPdmn,mPFC) = 1; %mPFC backward connection on rLPdmn
    DCM.A{backward}(Prec,mPFC) = 1; %mPFC backward connection on Prec
    
    DCM.A{lateral} = zeros(Nareas,Nareas);
    DCM.A{lateral}(rLPdmn,lLPdmn) = 1; %lLPdmn lateral connection to rLPdmn
    DCM.A{lateral}(lLPdmn,rLPdmn) = 1; %rLPdmn lateral connection to lLPdmn
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    DCM.C = sparse(length(DCM.A{1}),0); %Added C so no error in PEB
    
%-------------------------------------------------------    
%SALIENCE
elseif modindex == 2

    DCM.A{forward} = zeros(Nareas,Nareas);
    DCM.A{forward}(dACC,lLPsal) = 1; %lLPsal forward connection on dACC
    DCM.A{forward}(laPFCsal,lLPsal) = 1; %lLPsal forward connection on laPFCsal
    DCM.A{forward}(dACC,rLPsal) = 1; %rLPsal forward connection on dACC
    DCM.A{forward}(raPFCsal,rLPsal) = 1; %rLPsal forward connection on raPFCsal
    DCM.A{forward}(dACC,laPFCsal) = 1; %laPFCsal forward connection on dACC
    DCM.A{forward}(dACC,raPFCsal) = 1; %raPFCsal forward connection on dACC   
    
    DCM.A{backward} = zeros(Nareas,Nareas);
    DCM.A{backward}(lLPsal,dACC) = 1; %dACC backward connection on lLPsal
    DCM.A{backward}(rLPsal,dACC) = 1; %dACC backward connection on rLPsal
    DCM.A{backward}(laPFCsal,dACC) = 1; %dACC backward connection on laPFCsal
    DCM.A{backward}(raPFCsal,dACC) = 1; %dACC backward connection on raPFCsal
    DCM.A{backward}(lLPsal,laPFCsal) = 1; %laPFCsal backward connection on lLPsal
    DCM.A{backward}(rLPsal,raPFCsal) = 1; %raPFCsal backward connection on rLPsal
    
    DCM.A{lateral} = zeros(Nareas,Nareas);
    DCM.A{lateral}(rLPsal,lLPsal) = 1; %lLPsal lateral connection to rLPsal
    DCM.A{lateral}(lLPsal,rLPsal) = 1; %rLPsal lateral connection to lLPsal
    DCM.A{lateral}(raPFCsal,laPFCsal) = 1; %laPFCsal lateral connection to raPFCsal
    DCM.A{lateral}(laPFCsal,raPFCsal) = 1; %raPFCsal lateral connection to laPFCsal
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    DCM.C = sparse(length(DCM.A{1}),0); %Added C so no error in PEB
    
%-------------------------------------------------------
% CENTRAL EXECUTIVE
elseif modindex == 3 

    DCM.A{forward} = zeros(Nareas,Nareas);
    DCM.A{forward}(laPFCcen,lSP) = 1; %lSP forward connection on laPFCcen
    DCM.A{forward}(dmPFC,lSP) = 1; %lSP forward connection on dmPFC
    DCM.A{forward}(raPFCcen,rSP) = 1; %rSP forward connection on raPFCcen
    DCM.A{forward}(dmPFC,rSP) = 1; %rSP forward connection on dmPFC
    DCM.A{forward}(dmPFC,laPFCcen) = 1; %laPFCcen forward connection on dmPFC
    DCM.A{forward}(dmPFC,raPFCcen) = 1; %raPFCcen forward connection on dmPFC

    DCM.A{backward} = zeros(Nareas,Nareas);
    DCM.A{backward}(lSP,laPFCcen) = 1; %laPFCcen backward connection on lSP
    DCM.A{backward}(rSP,raPFCcen) = 1; %raPFCcen backward connection on rSP
    DCM.A{backward}(lSP,dmPFC) = 1; %dmPFC backward connection on lSP
    DCM.A{backward}(laPFCcen,dmPFC) = 1; %dmPFC backward connection on laPFCcen
    DCM.A{backward}(rSP,dmPFC) = 1; %dmPFC backward connection on rSP
    DCM.A{backward}(raPFCcen,dmPFC) = 1; %dmPFC backward connection on raPFCcen
    
    DCM.A{lateral} = zeros(Nareas,Nareas);
    DCM.A{lateral}(rSP,lSP) = 1; %lSP lateral connection to rSP
    DCM.A{lateral}(lSP,rSP) = 1; %rSP lateral connection to lSP
    DCM.A{lateral}(raPFCcen,laPFCcen) = 1; %laPFCcen lateral connection to raPFCcen
    DCM.A{lateral}(laPFCcen,raPFCcen) = 1; %raPFCcen lateral connection to laPFCcen
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    DCM.C = sparse(length(DCM.A{1}),0); %Added C so no error in PEB
%-------------------------------------------------------
% FULL MODEL
elseif modindex == 4
   
    DCM.A{forward} = zeros(Nareas,Nareas);
    DCM.A{forward}(Prec,lLPdmn) = 1; %lLPdmn forward connection on Prec
    DCM.A{forward}(mPFC,lLPdmn) = 1; %lLPdmn forward connection on mPFC
    DCM.A{forward}(Prec,rLPdmn) = 1; %rLPdmn forward connection on Prec
    DCM.A{forward}(mPFC,rLPdmn) = 1; %rLPdmn forward connection on mPFC
    DCM.A{forward}(mPFC,Prec) = 1; %Prec forward connection on mPFC
    DCM.A{forward}(dACC,lLPsal) = 1; %lLPsal forward connection on dACC
    DCM.A{forward}(laPFCsal,lLPsal) = 1; %lLPsal forward connection on laPFCsal
    DCM.A{forward}(dACC,rLPsal) = 1; %rLPsal forward connection on dACC
    DCM.A{forward}(raPFCsal,rLPsal) = 1; %rLPsal forward connection on raPFCsal
    DCM.A{forward}(dACC,laPFCsal) = 1; %laPFCsal forward connection on dACC
    DCM.A{forward}(dACC,raPFCsal) = 1; %raPFCsal forward connection on dACC 
    DCM.A{forward}(laPFCcen,lSP) = 1; %lSP forward connection on laPFCcen
    DCM.A{forward}(dmPFC,lSP) = 1; %lSP forward connection on dmPFC
    DCM.A{forward}(raPFCcen,rSP) = 1; %rSP forward connection on raPFCcen
    DCM.A{forward}(dmPFC,rSP) = 1; %rSP forward connection on dmPFC
    DCM.A{forward}(dmPFC,laPFCcen) = 1; %laPFCcen forward connection on dmPFC
    DCM.A{forward}(dmPFC,raPFCcen) = 1; %raPFCcen forward connection on dmPFC
    
    DCM.A{backward} = zeros(Nareas,Nareas);
    DCM.A{backward}(lLPdmn,Prec) = 1; %Prec backward connection on lLPdmn
    DCM.A{backward}(rLPdmn,Prec) = 1; %Prec backward connection on rLPdmn
    DCM.A{backward}(lLPdmn,mPFC) = 1; %mPFC backward connection on lLPdmn
    DCM.A{backward}(rLPdmn,mPFC) = 1; %mPFC backward connection on rLPdmn
    DCM.A{backward}(Prec,mPFC) = 1; %mPFC backward connection on Prec
    DCM.A{backward}(lLPsal,dACC) = 1; %dACC backward connection on lLPsal
    DCM.A{backward}(rLPsal,dACC) = 1; %dACC backward connection on rLPsal
    DCM.A{backward}(laPFCsal,dACC) = 1; %dACC backward connection on laPFCsal
    DCM.A{backward}(raPFCsal,dACC) = 1; %dACC backward connection on raPFCsal
    DCM.A{backward}(lLPsal,laPFCsal) = 1; %laPFCsal backward connection on lLPsal
    DCM.A{backward}(rLPsal,raPFCsal) = 1; %raPFCsal backward connection on rLPsal
    DCM.A{backward}(lSP,laPFCcen) = 1; %laPFCcen backward connection on lSP
    DCM.A{backward}(rSP,raPFCcen) = 1; %raPFCcen backward connection on rSP
    DCM.A{backward}(lSP,dmPFC) = 1; %dmPFC backward connection on lSP
    DCM.A{backward}(laPFCcen,dmPFC) = 1; %dmPFC backward connection on laPFCcen
    DCM.A{backward}(rSP,dmPFC) = 1; %dmPFC backward connection on rSP
    DCM.A{backward}(raPFCcen,dmPFC) = 1; %dmPFC backward connection on raPFCcen
    
    DCM.A{lateral} = zeros(Nareas,Nareas);
    DCM.A{lateral}(rLPdmn,lLPdmn) = 1; %lLPdmn lateral connection to rLPdmn
    DCM.A{lateral}(lLPdmn,rLPdmn) = 1; %rLPdmn lateral connection to lLPdmn
    DCM.A{lateral}(rLPsal,lLPsal) = 1; %lLPsal lateral connection to rLPsal
    DCM.A{lateral}(lLPsal,rLPsal) = 1; %rLPsal lateral connection to lLPsal
    DCM.A{lateral}(raPFCsal,laPFCsal) = 1; %laPFCsal lateral connection to raPFCsal
    DCM.A{lateral}(laPFCsal,raPFCsal) = 1; %raPFCsal lateral connection to laPFCsal
    DCM.A{lateral}(rSP,lSP) = 1; %lSP lateral connection to rSP
    DCM.A{lateral}(lSP,rSP) = 1; %rSP lateral connection to lSP
    DCM.A{lateral}(raPFCcen,laPFCcen) = 1; %laPFCcen lateral connection to raPFCcen
    DCM.A{lateral}(laPFCcen,raPFCcen) = 1; %raPFCcen lateral connection to laPFCcen
    
    %Between Network Connection
    DCM.A{forward}(lSP,Prec) = 1; %CEN-DMN
    DCM.A{forward}(rSP,Prec) = 1; %CEN-DMN
    DCM.A{forward}(Prec,dACC) = 1; %DMN-SAL
    
    DCM.A{backward}(Prec,lSP) = 1; %DMN-CEN
    DCM.A{backward}(Prec,rSP) = 1; %DMN-CEN
    DCM.A{backward}(dACC,Prec) = 1; %SAL-DMN
    
    %Every connection is allowed to change
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    DCM.C = sparse(length(DCM.A{1}),0); %Added C so no error in PEB
    
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

if modindex == 4
    DCM.options.Nmodes   = 14;      % number of spatial modes to invert 
else
    DCM.options.Nmodes   = 8; 
end

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

fprintf('\n\n\n*** Processing model %d (%s) ***\n\n\n', modindex, models{modindex});
DCM = spm_dcm_csd(DCM); % Estimate parameters of a DCM (complex) cross-spectral density
save([datafile '_model' (models{modindex}) '.mat'],'DCM')
end
