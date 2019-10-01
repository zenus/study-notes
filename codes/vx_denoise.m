%VX_denoise.m
%=========== This program makes a denoising of a sound
clear; clf;

%------------ user data -----------------------------
n1 = 512; % analysis step
n2 = n1; % synthesis step
s_win = 2048 % analysis window length
[DAFX_in,FS] = audioread('redwheel.wav');

%------------- initialize windows, arrays, etc----------
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1; % synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(length(DAFX_in),1);
hs_win = s_win /2;
coef = 0.01;
freq = (0:1:299)/s_win * 44100;

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = length(DAFX_in) - s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %====================================
    f = fft(grain);
    r = abs(f)/hs_win;
    ft = f.* r./(r+coef);
    grain = (real(ifft(ft))).*w2;
    %=====================================
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc
%---------------- listening and saving the output -------------
DAFX_out = DAFX_out(s_win+1:s_win+L)/max(abs(DAFX_out));
soundsc(DAFX_out,FS);


    
    
