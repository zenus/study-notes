% VX_stretch_real_pv.m
% ========== This program performs time stretching
%=========== using the  FFT-IFFT approach, for real ratios
clear;clf;

%------ user data ----------
n1 = 200; %analysis step
n2 = 512; %analysis step
s_win = 2048;
[DAFX_in,FS] = audioread('la.wav');

%-------- initialize windows, arrays, etc --------
tstretch_ratio = n2/n1;
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1;
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(s_win+ceil(length(DAFX_in)*tstretch_ratio),1);
omega = 2*pi*n1*[0:s_win-1]'/s_win;
phi0 = zeros(s_win,1);
psi = zeros(s_win,1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin =0;
pout = 0;
pend = length(DAFX_in)-s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %====================================
    f = fft(fftshift(grain)));
    r = abs(f);
    phi = angle(f);
    %--------- computing input phase increment ----------
    delta_phi = omega + princarg(phi-phi0-omega);
    %---------- comouting synthesis Fourier transform & grain ----
    psi = princarg(psi+delta_phi*tstretch_ratio);
    %----------- comouting synthesis Fourier transform & grain ----
    ft = (r.*exp(i*psi));
    grain = fftshift(real(ifft(ft))).*w2;
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win)+grain;
    %-------- for next block ---------
    phi0 = phi;
    pin = pin + n1;
    pout = pout +n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

DAFX_out = DAFX_out(s_win+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,FS);

