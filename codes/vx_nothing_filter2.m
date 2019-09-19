% VX_filter_noting.m 
clear; clf

%====== This program (i) performs a complex-valued filter bank
%======  then (ii) filters a sound throught the filter bank
%======  and (iii) reconstructs a sound


% --------------user data ---------
fig_plot = 0; % user any value except 0 or []  to plot figures
s_win = 256; % window size
nChannel = 128; % nb of channels;
n1 = 1024; % block size for calculation
[DAFx_in,FS] = audioread('la.wav');

%------------ initialize windows, array ,etc------------
window = hanning(s_win, 'periodic');
L = length(DAFx_in);
DAFx_in = [DAFx_in;zeros(n1,1)]/max(abs(DAFx_in)); % 0-pad & normalize
DAFx_out = zeros(length(DAFX_in),1);
X_tilde = zeros(n1,nChannel);
z = zeros(s_win-1,nChannel);

%------- initialize the complex-valued filter bank-------
t = (-s_win/2:s_win/2-1)';
filt =zeros(s_win,nChannel);
for k=1:nChannel
    wk = 2*pi*i*(k/s_win);
    filt(:,k) = window.*exp(wt*t);
end
tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pend = length(DAFx_in) - n1;
while pin < pend
    grain = DAFx_in(pin+1:pin+n1);
    %===========================================
    %---------------filtering-------------------
    for k=1:nChannel
        [X_tilde(:,k),z(:,k)] = filter(filt(:,k),1,grain,z(:,k));
    end
    %-----------sound reconstruction ------------
    res = real(sum(X_tilde,2));
    %==============================================
    DAFx_out(pin+1:pin+n1) = res;
    pin = pin + n1;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc
%------------ listening and saving the output -------------
DAFx_out = DAFx_out(nChannel+1:nChannel+L)/max(abs(DAFx_out);
