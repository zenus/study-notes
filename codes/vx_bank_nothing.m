%VX_bank_nothing.m
% ======= This program performs an FFT analysis and oscillator bank
% synthesis

clear;clf;

%-----------user data ------------
n1 = 200; % analysis step 
n2 = n1; %synthesis step
s_win = 2048; %window size 
[DAFx_in,FS] = audioread('la.wav');

%----------- initialize windows ,arrays, etc--------
w1 = hanning(s_win,'periodic'); % input wav
w2 = w1;
L = length(DAFx_in); 
DAFx_in = [zeros(s_win,1); DAFx_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFx_in));
DAFx_out = zeros(length(DAFx_in),1);
ll = s_win/2;
omega = 2*pi*n1*[0:ll-1]'/s_win;
phi0 = zeros(ll,1);
r0 = zeros(ll,1);
psi = zeros(ll,1);
grain = zeros(s_win,1);
res = zeros(n2,1);
tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin =0;
pout = 0;
pend = length(DAFx_in) - s_win;

while pin<pend
    grain = DAFx_in(pin+1:pin+s_win).*w1;
    %===================================
    grain = DAFx_in(pin+1:pin+s_win).*w1;
    %===================================
    fc = fft(fftshift(grain));
    f = fc(1:ll);  %positive frequency spectrum
    r = abs(f);    %magnitudes
    phi = angle(f); %phase
    %-------  unwrapped phase difference on each bin for a n2 step
    delta_phi = omega + princarg(phi-phi0-omega);
    %---- phase and magnitude increment, for linear
    % interpolation and reconstruction
    delta_r = (r-r0)/n1; %magnitude increment
    delta_psi = delta_phi/n1; %phase increment
    for k=1:n2 %compute the sum of weighted cosine
        r0 = r0 + delta_r;
        psi = psi + delta_psi;
        res(k) = r0'*cos(psi);
    end
     
    %--------for next time -------
    phi0 = phi;
    r0 = r;
    psi = princarg(psi);
    %=============================
    DAFx_out(pout+1:pout+n2) = DAFx_out(pout+1:pout+2) + res;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc
%----------listening and saving the output -------------------
DAFx_out = DAFx_out(s_win/2+n1+1:s_win/2+n1+L) / max(abs(DAFx_out));
soundsc(DAFx_out,FS);

    
