%UX_fmove_cepstrum.m
%========== This function performs a formant warping with cepstrum
clear;clf;
%---------- user data ----------------
[DAFX_in,SR] = audioread('la.wav'); % sound file
wraping_coef = 2.0;
n1 = 512; % analysis hop size
n2 = n1; % synthesis hop size
s_win = 2048; % window length
order = 50; % cut quefrency
r = 0.99; % sound output normalizing ratio
%--------- initializations --------------
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1;  %synthesis window
hs_win = s_win/2; % half window size
L = length(DAFX_in); % signal length
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)] / max(abs(DAFX_in));
DAFX_out = zeros(L,1); % output signal
t = 1 + floor((0:s_win-1)*warping_coef); %apply the warping
lmax = max(s_win,t(s_win));

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = L - s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %=======================================
    f = fft(grain)/hs_win; % spectrum  of grain
    flogs = 20 * log10(0.00001 + abs(f)); 
    
    grain1 = DAFX_in(pin+t).* w1; %linear interpolation of grain
    f1 = fft(grain1)/hs_win;
    flogs1 = 20 * log10(0.00001 + abs(f1));
    flog = log(0.00001+abs(f1)) - log(0.00001+abs(f));
    cep = ifft(flog);
    cep_cut = [cep(1)/2;cep(2:order);zeros(s_win-order,1)];
    
    corr = exp(2*real(fft(cep_cut))); % spectral shape
    grain = (real(ifft(f.*corr))).*w2;
    
    fout = fft(grain);
    flogs2 = 20*log10(0.00001 + abs(fout));
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin +n1;
    pout = pout +n2;
end
toc

%----------- listening and saving the output -------------
soundsc(DAFX_out,SR);
