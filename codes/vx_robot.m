%VX_robot.m
%======= this program performs a robotization of a sound
clear; clf;

%----------- user data ---------------------
n1 = 441;
n2 = n1;
s_win = 1024;
[DAFX_in,FS] = audioread("redwheel.wav");

%-------------- initialize windows, arrays, etc -------------
w1 = hanning(s_win,'periodic');
w2 = w1;
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in));
DAFX_out = zeros(length(DAFX_in),1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = zeros(length(DAFX_in),1) - s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %===================================
    f = fft(grain);
    r = abs(f);
    grain = fftshift(real(ifft(r))).*w2;
    %===================================
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

DAFX_out = DAFX_out(s_win+1:s_win+L)/max(abs(DAFX_out));
soundsc(DAFX_out,FS);
