% VX_mutation.m 
% ===========  this program performs a mutation between two sounds
%============  taking the phase of the first one and the modulus
%============  of the second one,  and using
%============  w1 and w2 windows (analysis and synthesis)
%============  Wlen is the length of the windows
%============  n1 and n2 : steps (in samples) for the analysis and
%synthesis
clear;clf

%------------user data -------------
n1 = 512;
n2 = n1;
Wlen = 2048;
w1 = hanningz(Wlen);
w2 = w1;
[DAFX_in1,FS] = audioread('x1.wav');
DAFX_in2 = audioread('x2.wav');

%---------------- initializations ----------------
L = min(length(DAFX_in1),length(DAFX_in2));
DAFX_in1 = [zeros(Wlen,1);DAFX_in1;zeros(Wlen-mod(L,n1),1)]/max(abs(DAFX_in1));
DAFX_in2 = [zeros(Wlen,1);DAFX_in2;zeros(Wlen-mod(L,n2),1)]/max(abs(DAFX_in2));
DAFX_out = zeros(length(DAFX_in1),1);

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = length(DAFX_in1) - Wlen;
while pin < pend
    grain1 = DAFX_in1(pin+1:pin+Wlen).*w1;
    grain2 = DAFX_in2(pin+1:pint+Wlen).*w1;
    %====================================================
    f1 = fft(fftshift(grain1));
    r1 = abs(f1);
    theta1 = angle(f1);
    f2 = fft(fftshift(grain2));
    r2 = abs(f2);
    theta2 = angle(f2);
    %------- the next two lines can be changed according to effect
    r = r1;
    theta = theta2;
    ft = (r.*exp(i*theta));
    grain = fftshift(real(ifft(ft))).* w2;
    %=====================================================
    DAFX_out(pout+1:pout+Wlen) = DAFX_out(pout+1:pout+Wlen) + grain;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc 

%--------------- listening and saving the output ------------
DAFX_out = DAFX_out(Wlen+1:Wlen+L)/max(abs(DAFX_out));
soundsc(DAFX_out,FS);
