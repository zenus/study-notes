%VX_specpan.m
%=============== This program makes a spectral panning of a sound
clear;clf;

%------------------ user data ------------------------
n1 = 512; %analysis step
n2 = n1;  %synthesis step
s_win = 2048; % analysis window length
[DAFX_in,FS] = audioread('redwheel.wav');

%----------- initialize windows, arrays, etc ----------
w1 = hanning(s_win,'periodic'); %analysis window
w2 = w1; % synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(length(DAFX_in),2);
hs_win = s_win/2;
coef = sqrt(2)/2;
%------ control: clipped sine wave with a few peroids; in [-pi/4, pi/4]
theta = min(1,max(-1,2*sin((0:hs_win)/s_win*200)))'.*pi/4;
%------- preserving phase symmetry ------------------------------
theta = [theta(1:hs_win+1);flipud(theta(1:hs_win-1))];

tic 
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin =0;
pout = 0;
pend = length(DAFX_in) - s_win;

while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %===================================
    f = fft(grain);
    %---------  compute left and right spectrum with Blumlein law at 45
    ftL = coef * f .*(cos(theta) + sin(theta));
    ftR = coef * f.*(cos(thea)-sin(theta));
    grainL= (real(ifft(ftL))).*w2;
    grainR = (real(ifft(ftR))).*w2;
    %===========================================
    DAFX_out(pout+1:pout+s_win,1) = DAFX_out(pout+1:pout+s_win,1) + grainL;
    DAFX_out(pout+1:pout+s_win,2) = DAFX_out(pout+1:pout+s_win,1) + grainR;
    pin = pin + n1;
    pout = pout+n2;
end
toc
%-------------------- listening and saving the output ----------------
DAFX_out = DAFX_out(s_win+1:s_win+L,:)/max(max(abs(DAFX_out)));
soundsc(DAFX_out,FS);
