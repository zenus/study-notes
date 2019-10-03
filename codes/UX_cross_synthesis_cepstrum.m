%UX_cross_syntheis_cepstrum.m
%============ This function performs a cross-synthesis with cepstrum
clear all; close all;

%---------- user data --------------
[DAFX_sou,SR] = audioread('moore_guitar.wav'); % sound1:source/excitation
DAFX_env = audioread('toms_diner.wav'); %sound2: spectral enveloppe

s_win = 1024; % window size;
n1 = 256; % step increment;
order_sou = 30; % cut quefrency for sound 1
order_env = 30 % cut quefrency for sound 2
r = 0.99     % sound output normalizing ratio

%-------- initialisations ------------
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1; % synthesis window
hs_win = s_win/2; % half of window
grain_sou = zeros(s_win,1); % gain of extracting source
grain_env = zeros(s_win,1); % gain of extracting spec enveloppe
pin = 0; % start index
L = min(length(DAFX_sou),length(DAFX_env));
pend = L - s_win; % end index
DAFX_sou = [zeros(s_win,1);DAFX_sou;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_sou));
DAFX_env = [zeros(s_win,1);DAFX_env;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_env));
DAFX_out = zeros(L,1);

%--------- cross synthesis ---------------
while pin < pend
    grain_sou = DAFX_sou(pin+1:pin+s_win).*w1;
    grain_env = DAFX_env(pin+1:pin+s_win).*w1;
    f_sou = fft(grain_sou); % FT of source
    f_env=  fft(grain_env)/hs_win; % FT of filter
    %------- computing cepstrum ------------
    flog = log(0.00001 + abs(f_env));
    cep = ifft(flog); % cep of sound2
    flog_sou = log(0.00001 + abs(f_sou));
    cep_sou = ifft(flog_sou);
    %-------- liftering cepstrum ------------
    cep_cut = zeros(s_win,1);
    cep_cut(1:order_env) = [cep(1)/2;cep(2:orde_env)];
    flog_cut = 2 * real(fft(cep_cut));
    cep_cut_sou = zeros(s_win,1);
    cep_cut_sou(1:order_sou) = [cep_sou(1)/2;cep_sou(2:order_sou)];
    flog_cut_sou = 2 * real(fft(cep_cut_sou));
    %-------- computing spectral enveloppe ----------
    f_env_out = exp(flog_cut-flog_cut_sou); % spectral shape of sound 2
    grain = (real(ifft(f_sou.*f_env_out))).*w2; %resynthesis grain
    DAFX_out(pin+1:pin+s_win) = DAFX_out(pin+1:pin+s_win) + grain;
    pin = pin + n1;
end

DAFX_out = DAFX_out(s_win+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,FS);
