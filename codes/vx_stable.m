%VX_stable.m
%=========== this program extracts the stable components of a signal
clear;clf;

%----------- user data -----------
test = 0.4;
n1 = 256; %analysis step 
n2 = n1; %synthesis step
s_win = 2048; % analysis window length
[DAFX_in,FS] = audioread('redwheel,wav');

%----------- initialize windows, arrays, etc ----------
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1; %synthesis 
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(length(DAFX_in),1);
devcent = 2*pi*n1/s_win;
vtest = test * devcent;
grain = zeros(s_win,1);
theta1 = zeros(s_win,1);
theta2 = zeros(s_win,1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout= 0;
pend = length(DAFX_in) - s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %===================================
    f = fft(fftshift(grain)));
    theta = angle(f);
    dev = princarg(theta-2*theta1+theta2);
    %----------- set to 0 magnitude values below 'test' threshold
    ft = f.* (abs(dev) < vtest);
    grain = fftshift(real(ifft(ft))).*w2;
    theta2 = theta1;
    theta1 = theta;
    %=======================================
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%----------------- listening and saving the output
DAFX_out = DAFX_out(s_win+1:s_win+L)/max(abs(DAFX_out));
soundsc(DAFX_out,FS);

    
