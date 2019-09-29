%VX_tstretch_int_pv.m
%==========  This program performs integer ratio time stretching
%========== using the FFT-IFFT approach
clear;clf

%---------  user data ------------
n1 = 64; % analysis step
n2 = 512; % synthesis step
s_win = 2048; %analysis window length
[DAFX_in,FS]=audioread('la.wav');

%---------- initialize windows, arrays, etc -------
tstretch_ratio = n2/n1;
w1 = hanning(s_win,'periodic'); %analysis window
w2 = w1;%synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(s_win+ceil(length(DAFX_in)*tstretch_ratio),1);
omega = 2*pi*n1*[0:s_win-1]'/s_win;
phi0 = zeros(s_win,1);
psi= zeros(s_win,1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin =0;
pout = 0;
pend = length(DAFX_in) - s_win;

while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %===================================
    f = fft(fftshift(grain));
    r = abs(f);
    phi = angle(f);
    ft = (r.*exp(i*tstretch_ratio*phi));
    grain = fftshift(real(ifft(ft))).*w2;
    %=================================== 
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin +n1;
    pout = pout + n2;
end

%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%------------ listening and saving the output ---------
DAFX_out = DAFX_out(s_win+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,FS);

