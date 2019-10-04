%UX_interp_move.m
%=============== This function performs a pitch-shifting that perserves the
% spectral enveloppe
clear; 

%------------- user data --------------------
[DAFX_in,SR] = audioread('la.wav');
n1 = 400;
n2 = 256;
s_win = 2048;
order = 50;
coef = 0.99;

%------------ initializations -------------------
w1 = hanning(s_win,'periodic');
w2 = w1;
tscal = n2/n1;
L = length(DAFX_in);
hs_win = s_win/2;
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1]/max(abs(DAFX_in));
    
%--------- for linear interpolaction of a grain of length s_win
lx = floor(s_win*n1/n2);
DAFX_out = zeros(ceil(tscal*length(DAFX_in)),1);
x = 1 + (0:s_win-1)'*lx/s_win;
ix = floor(x);
ix1 = ix + 1;
dx = x - ix;
dx1 = 1 -dx;
warp = n1/n2; %warpinf coefficient = 1/tscal
lmax = max(s_win,lx);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = L - lmax;
while pin < pend
grain1 = (DAFX_in(pin+ix).*dx1 + DAFX_in(pin+ix1).*dx).*w1;
f1 = fft(grain1)/hs_win;

grain2 = (DAFX_in(pin+1:pin+s_win).*w1;
f2 = fft(grain2)/hs_win;

%----------- correction factor for spectral enveloppe -----------
flog = log(0.00001 + abs(f2)) - log(0.00001 + abs(f1));
cep = ifft(flog);
cep_cut = [cep(1)/2;cep(2:order);zeros(s_win-order,1)];
corr = exp(2*real(fft(cep_cut)));
%------------ so now make the formant move ---------------
grain = fftshift(real(ifft(f1.*corr))).*w2;
%===============================================================
DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
pin = pin + n1;
pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

DAFX_out = coef * DAFX_out(s_win+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,SR);

