% UX_cross_syntheis_lpc.m
% ======== This function performs a cross-synthesis with LPC
clear;

%-------- user data ------------
[DAFX_in_sou,FS] = audioread('moore_guitar.wav'); % sound 1: source/excitation
DAFX_in_env = audioread('toms_diner.wav'); % sound 2: spectral env
long = 400; % block length for calculation of conefficients
hopsize=  160; % hop size
env_order = 20; % order of the LPC for source signal
source_order = 6; % order of the LPC for excitation signal
r = 0.99; % sound output normalizing ratio
 
%-------- initializations ----------
ly = min(length(DAFX_in_souce),length(DAFX_in_env));
DAFX_in_sou = [zeros(env_order,1);DAFX_in_sou;zeros(env_order-mod(ly,hopsize),1)] /max(abs(DAFX_in_sou));
DAFX_in_env = [zeros(env_order,1);DAFX_in_env;zeros(env_order-mod(ly,hopsize),1)] /max(abs(DAFX_in_env));

DAFX_out = zeros(ly,1); % result sound
exc = zeros(ly,1); % excitation sound
w = hanning(long,'periodic'); % window
N_frames = floor((ly-env_order-long)/hopsize); % number of frames

%-------- Perform ross-syntheis ----------
tic
for j=1:N_frames
    k = env_order + hopsize*(j-1); % offset of the buffer
    % !!!! important: function "lpc" does not give correct results for
    % matlab 6
    
    [A_env,g_env] = calc_lpc(DAFX_in_env(k+1:k+long).*w,env_order);
    [A_sou,g_sou] = calc_lpc(DAFX_in_sou(k+1:k+long).*w,source_order);
    gain(j) = g_env;
    ae = -A_env(2:env_order+1); % lpc coeff. of excitation
    for n=1:hopsize
        excitation1 = (A_sou/g_sou) * DAFX_in_sou(k+n:-1:k+n-source_order);
        exc(k+n) = excitation1;
        DAFX_out(k+n) = ae * DAFX_out(k+n-1:-1:k+n-env_order) + g_env * excitation1;
    end
end
toc

%-----------playing and saving output signal -----------------
DAFX_out = DAFX_out(env_order+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,FS);

