%VX_gab_nothing.m
%====  This program performs sigal convolution with gaborets
clear;clf;

%------------user data ---------------
n1 = 128; %analysis step
n2 = n1; %synthesis step
s_win = 512; %window size
[DAFx_in,FS] = audioread('la.wav');

%------  initialize windows, arrays, etc---------------
window = hanning(s_win,'peroidics'); %input window
nChannel = s_win/2;
L = length(DAFx_in);
DAFx_in =[zeros(s_win,1);DAFx_in;zeros(s_win-mod(L,n1),1)] / max(abs(DAFx_in));
DAFx_out = zeros(length(DAFx_in));

%--------- initialize calculation of gaborets ------------
t = (-s_win/2:s_win/2 -1 );
gab = zeros(nChannel,s_win);
for k=1:nChannel
    wk = 2*pi*i*(k/s_win);
    gab(k,:) = window'.*exp(wk*t);
end

tic 
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = length(DAFx_in) - s_win;

while pin<pend
    grain = DAFx_in(pin+1:pin+s_win);
    %===============================
    %------- compute vector corresponding to a vertical line
    vec = gab*grain;
    %-------- reconstruction from the vector to a grain
    res = real(gab'*vec);
    %=================================
    DAFx_out(pout+1:pout+s_win) = DAFx_out(pout+1:pout+s_win) + res;
    pin = pin + n1;
    pout = pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc
DAFx_out = DAFx_out(s_win+1:s_win+L)/max(abs(DAFx_out));
soundsc(DAFx_out,FS);



