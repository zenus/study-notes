%UX_fomove_cepstrum.m
%===== This function performs a formant warping with cepstrum
clear;clf;

%------- user data -------
[DAFX_in,SR] = audioread('la.wav');
n1 = 512;
n2 = n1;
s_win = 2048;
order = 50;
r = 0.99;

%-------- initializations ------
w1 = hanning(s_win,'periodic');
w2 = w1;
hs_win = s_win/2;
L = length(DAFX_in);
DAFX_in= [zeros(s_win,1);DAFX_in; (s_win-mod(L,n1))]/max(abs(DAFX_in));
DAFX_out = zeros(L,1);
x0 = floor(min((1+(0:hs_win)/warping_coef),1+hs_win));
x = [x0,x0(hs_win:-1:2)]; % symmetric extension

tic 
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = L - s_win;

while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %===================================
    f = fft(grain)/hs_win;
    flog = log(0.00001 + abs(f));
    cep = ifft(flog);
    cep_cut = [cep(1)/2;cep(2:order);zeros(s_win-order,1)];
    flog_cut1 = 2 * real(fft(cep_cut));
    flog_cut2 = flog_cut1(x);
    corr = exp(flog_cut2 - flog_cut1);
    grain = (real(ifft(f.*corr))).*w2;
    %=====================================
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin +n1;
    pout = pout +n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%----------------- listening and saving the output ---------------
soundsc(DAFX_out,SR);
