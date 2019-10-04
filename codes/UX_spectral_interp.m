%UX_spectral_interp.m
%=============== This function performs a spectral interpolation with
%cepstrum

% k: spectral mix, calculated at every step in this example, as started
% with gain = 0 for sound 1 and gain = 1 for sound2
% finished with gain=1 for sound1 and gain=0 for sound2
% so we move from sound1 to sound2;
clear;


%------------- user data --------------
[DAFX_in,SR] = audioread('clarie_oubli_voix,wav');
DAFX_in2 = audioread('clarie_oubli_flute.wav');
n1= 512;
n2= n1;
s_win = 2048;
w1 = hanning(s_win,'periodic');
w2 = w1;
cut = 50;

%-------------  initializations ------------
L = min(length(DAFX_in1),length(DAFX_in2));
DAFX_in1 = [zeros(s_win,1);DAFX_in1;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in1));
DAFX_in2 = [zeros(s_win,1);DAFX_in2;zeros(s_win-mod(L,n1),1)]/max(abs(DAFX_in2));
DAFX_out = zeros(length(DAFX_in1),1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = L - s_win;
while pin < pend
    %---------- k factor (spectral mix) wich varies betwwen 0 and 1
    k = pin / pend;
    kp = 1-k;
    grain1 = DFAX_in1(pin+1:pin+s_win).*w1;
    grain2= DFAX_in2(pint+1:pint+s_win).*w2;
    %=======================================
    f1 = fft(fftshift(grain1));
    flog = log(0.00001 + abs(f1));
    cep = fft(flog);
    cep_coupe = [cep(1)/2;cep(2:cut);zeros(s_win-cut,1)];
    flog_coupe1 = 2 * real(ifft(cep_coupe));
    spec1 = exp(flog_coupe1);
    %=========================================
    f2 = fft(fftshift(grain2));
    flog = log(0.00001 + abs(f2));
    cep = fft(flog);
    cep_coupe = [cep(1)/2;cep(2:cut);zeros(s_win-cut,1)];
    flog_coupe2 = 2 * real(ifft(cep_coupe));
    spec2 = exp(flog_coupe2);
    %-------------- interpolating the spectral shapes in dBS-------------
    spec  = exp(kp*flog_coupe1 + k*flog_coupe2);
    %--------------- computing the output spectrum and grain ------------
    ft = (kp*f1./spec1 + k*f2./spec2).*spec
    grain = fftshift(real(ifft(ft))).*w2;
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    pin = pin +n1;
    pout = pout +n2;
end

%----------------- listening and saving the output ---------------
soundsc(DAFX_out,SR);
