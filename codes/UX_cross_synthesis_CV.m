%UX_cross_syntheis_CV.m
%============ This funciton performs a cross-syntheis with channel vocoder
clear;

%------------- setting user data ------------
[DAFX_in_sou,FS] = audioread('moore_guitar'); % signal for source extraction
DAFX_in_env = audioread('toms_dinner');%signal for spec. env. extraction
ly = min(length(DAFX_in_sou),length(DAFX_in_env));
DAFX_out = zeros(ly,1); % result signal
r = 0.99; % sound output normalizing ratio
lp = [1, -2*r, r*r]; %low-pass filter used
epsi = 0.00001;

%--------- init bandpass frequencies
f0 = 10; % start freq in Hz
f0 = f0/FS * 2; % normalized freq
fac_third = 2^(1/3); % freq factor for third octave
K = floor(log(1/f0) / log(fac_third)); % number of bands

%---------- performing the vocoding or cross synthesis effect
tic
for k=1:K
    f1 = f0 * fac_third; % upper freq of bandpass
    [b,a] = cheby1(2,3,[f0,f1]);  % Chebyshev-type 1 filter design
    f0 = f1;
    %------ filtering the two signals -----------
    z_sou = filter(b,a,DAFX_in_sou);
    z_env = filter(b,a,DAFX_in_env);
    rms_env = sqrt(filter(1,lp,z_env .* z_env)); %RMS value of sound 2
    rms_sou = sqrt(eps+filter(1,lp,z_sou .* z_sou)); % with whitening
    DAFX_out = DAFX_out + z_sou.*rms_env./rms_sou; % add result to output buffer
end
toc

%---------- playing and saving output sound ---------
soundsc(DAFX_out,FS);

    
    
