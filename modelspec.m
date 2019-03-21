function DCM = modelspec(m)
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
    
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    %Every connection is allowed to change
    
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
    
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    %Every connection is allowed to change
    
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
    
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    %Every connection is allowed to change
    %---------------------------------------------------------------------
    
    %FULL MODEL
elseif m == 4 % Full Model
    
    %Forward
    DCM.A{1} = zeros(Nareas,Nareas);
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
    
    DCM.B{1} = DCM.A{1} + DCM.A{2} + DCM.A{3};
    %Every connection is allowed to change
    
end