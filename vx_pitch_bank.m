%VX_pitch_bank.m
%======= This program performs pitch shifting
%======= using the oscillator bank approach
clear;clf;

%------- user data --------
n1 = 512; %analysis step 
pit_ratio = 1.2 %pitch-shifting ratio
s_win = 2048;% analysis window length
[DAFX_in,FS] = audioread('la.wav');

%------- initialize windows, arrays, etc -----------
w1 = hanning(s_win,'peroidic');%analysis window
w2 = w1; %synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(length(DAFX_in),1);
grain = zeros(s_win,1);
hs_win = s_win/2;
omega = 2*pi*n1*[0:hs_win-1]'/s_win;
phi0 = zeros(hs_win,1);
r0 = zeros(hs_win,1);
psi = phi0;
res = zeros(n1,1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin=0;
pout=0;
pend = length(DAFX_in)-s_win;

while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
%==========================================================
    fc = fft(fftshift(grain));
    f  = fc(1:hs_win);
    r  = abs(f);
    phi = angle(f);
    %------- compute phase & mangitude increments --------
    delta_phi = omega + princarg(phi-phi0-omega);
    delta_r = (r-r0)/n1;
    delta_psi =  pit_ratio * delta_phi/n1;
    %-------- compute output buffer -----------
    for n=1:n1
        r0 = r0 + delta_r;
        psi = psi + delta_psi;
        res(k) = r0' * cos(psi);
    end
    %--------- store for next block -------------
    phi0 = phi;
    r0 = r;
    psi = princarg(psi);
    %============================================
    DAFX_out(pout+1:pout+n1) = DAFX_out(pout+1:pout+n1)+res;
    pin = pin +n1;
    pout = pout + n1;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%--------- listening and saving the output -------
DAFX_out = DAFX_out(hs_win+n1+1:hs_win+n1+L)/max(abs(DAFX_out));
soundsc(DAFX_out,FS);

    
