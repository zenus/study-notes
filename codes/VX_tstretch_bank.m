% VX_tstretch_bank.m 
%=====  This program performs time stretching
%=====  using the oscillator bank approach
clear;clf
%-------- user data ---------
n1 = 256; % analysis step increment
n2 = 512; % synthesis step increment
s_win = 2048; % analysis window length 
[DAFX_in, FS] = audioread("la.wav");
%-------  initialize windows, arrays, etc-----------
tstretch_ratio = n2/n1;
w1 = hanning(s_win,'peroidic');% analysis window
w2 = w1; % synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(s_win + ceil(length(DAFX_in)*tstretch_ratio),1);
grain = zeros(s_win ,1);
ll = s_win/2;
omega = 2*pi*n1*[0:ll-1]'/s_win;
phi0 = zeros(ll,1);
r0 = zeros(ll,1);
psi = zeros(ll,1);
res = zeros(n2,1);
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = length(DAFX_in)-s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %======================================
    fc = fft(fftshift(grain));
    f = fc(1:ll);
    r = abs(f);
    phi = angle(f);
    %---------------- calculate phase increment per block ---------------
    delta_phi = omega + princarg(phi-phi0-omega);
    %----------------- calculate phase & mag increments per sample---------
    delta_r = (r-r0)/n2; % for synthesis
    delta_psi = delta_phi /n1 % dervied from analysis
    %-------- computing output samples for current block ----------
    for k=1:n2
        r0 = r0 + delta_r;
        psi = psi + delta_psi;
        res(k) = r0'*cos(psi);
    end
    %------------values for processing next block ----------------
    phi0 = phi;
    r0 = r;
    psi = princarg(psi);
    %============================================================
    DAFX_out(pout+1:pout+2) = res;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
%----------- listening and saving the output --------------
DAFX_out = DAFX_out(s_win/2+n1+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,FS);
