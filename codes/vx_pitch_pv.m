%VX_pitch_pv.m
%============= This program performs pitch shifting 
%============= using the FFT/IFFT approach
clear;clf;

%------- user data -------------
n2 = 512; % synthesis step
pit_ratio = 1.2 %pitch_shifting ratio
s_win = 2048; % analysis window length
[DAFX_in,FS] = audioread('flute2');

%-----------  initialize windows, arrays, etc----------
n1 = round(n2/pit_ratio);
tstretch_ratio = n2/n1;
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1;%synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(length(DAFX_in),1);
omega = 2*pi*n1*[0:hs_win-1]'/s_win;
phi0 = zeros(s_win,1);
psi = zeros(s_win,1);

%------------------- for linear interpolation of a grain of length s_win

lx = floor(s_win*n1/n2);
x = 1 + (0:lx-1)'*s_win/lx;
ix = floor(x);
ix1 = ix +1;
dx = x - ix;
dx1 = 1 - dx;

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = length(DAFX_in)-s_win;
while pin<pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %====================================================================
    f = fft(fftshift(grain));
    r = abs(f);
    phi = angle(f);
    %-------------------- computing phase increment ---------------------
    delta_phi = omega + princarg(phi - phi0 - omega);
    phi0 = phi;
    psi = princarg(psi+delta_phi*tstretch_ratio);
    %----------- synthesizing time scaled grain ------------------------
    ft = (r.*exp(i*psi));
    grain = fftshift(real(ifft(ft))).*w2;
    %------------ interpolating grain --------------------------------
    grain2 = [grain;0];
    grain3 = grain2(ix).*dx1 + grain2(ix).*dx;
    %=====================================================================
    DAFX_out(pout+1:pout+lx) = DAFX_out(pout+1:pout+lx) + grain3;
    pin = pin + n1;
    pout = pout + n1;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%------------------- listening and saving the output --------------------
DAFX_out = DAFX_out(s_win+1:s_win+L)/max(abs(DAFX_out));
soundsc(DAFX_out,FS);
