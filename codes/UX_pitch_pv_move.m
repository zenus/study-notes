%UX_pitch_pv_move.m
%============ This function performs a pitch-shifting that preserves the spectral enveloppe
clear;

%------------- user data -------------------
[DAFX_in,SR] = audioread('la.wav'); % sound file
n1 = 512; % analysis hop size
n2 = 256; 
s_win = 2048;
order = 50;
coef = 0.99;

%-------------- initializations --------------
w1 = hanning(s_win,'periodic');
w2 = w1;
tscal = n2/n1;
s_win2 = s_win / 2;
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
%------ for phase unwrapping 
omega = 2*pi*n1*[0:s_win-1]'/s_win;
phi0 = zeros(s_win,1);
psi = zeros(s_win,1);
%------  for linear interpolation of a grain of length s_win
lx = floor(s_win*n1/n2);
DAFX_out = zeros(lx+length(DAFX_in),1);
x = 1 + (0:lx-1)'*s_win/lx;
ix = floor(x);
ix1 = ix +1;
dx = x -ix;
dx1= 1 -dx;
warp = n1/n2 ; % warpinf coefficient  = 1/tscal
t = 1 + floor((0:s_win-1)*warp);
lmax = max(s_win,t(s_win));

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = L - lmax;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    f = fft(fftshift(grain));
    r = abs(f);
    phi = angle(f);
    %--------- unwrapping the phase -------------
    delta_phi = omega + princarg(phi - phi0 -omega);
    phi0 = phi;
    psi = princarg(psi + delta_phi * tscal);
    %---------- moving formant--------------------
    grain1 = DAFX_in(pin+t).*w1;
    f1 = fft(grain1)/s_win2;
    flog = log(0.00001 + abs(f1)) - log(0.00001 + abs(f));
    cep  = ifft(flog);
    cep_cut = [cep(1)/2;cep(2:order);zeros(s_win-order,1)];
    corr = exp(2*real(fft(cep_cut))); % correction enveloppe
    %----------- spec env modif.: computing output FT and grain -------
    ft = (r.* corr.*exp(i*psi));
    grain = fftshift(real(ifft(ft))).*w2;
    %------------ pitch-shifting: interpolating output grain -----------
    grain2 = [grain:0];
    grain3 = grain2(ix).*dx1 + grain2(ix1).*dx;
    %===================================================================
    DAFX_out(pout+1:pout+lx) = DAFX_out(pout+1:pout+lx) + grain3;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%-------------- listening and saving the output -------------
DAFX_out = coef * DAFX_out(s_win+1:s_win+L)/max(abs(DAFX_out));
soundsc(DAFX_out,SR);
