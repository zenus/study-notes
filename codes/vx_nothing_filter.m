% VX_het_nothing.m
clear; clf
%===== This program (i) implements a heterodyne filter bank
%====== then (ii) filters sound through the filter bank
%======  and (iii) reconstructs a sound

%-------- user data ------
fig_plot = 0; %use any value except 0 or [] to plot figures 
s_win = 256; %window size;
n_channel = 128; % nb of channels;
s_block = 1024; % computation block size (must be multiple of s_win)
[DAFx_in, FS] = audioread('la.wav');

%------- initialize windows, arryas, etc---------
window = hanning(s_win,'periodic');
s_buffer = length(DAFx_in);
DAFx_in = [DAFx_in; zeros(s_block,1)]/max(abs(DAFx_in)); %0-pad & normalize
DAFx_out = zeros(length(DAFx_in),1);
X = zeros(s_block,n_channel);
z = zeros(s_win, n_channel);
% ----- initialize the heterodyn filters -------
t = (0:s_block-1)'
het = zeros(s_block,n_channel);
for k=1:n_channel
    wk = 2*pi*i(k/s_win);
    het(:,k) = exp(wk*(t+s_win/2));
    het2(:,k) = exp(-wk*t);
end

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pend = length(DAFx_in) - s_block;
while pin < pend
    grain = DAFx_in(pin+1:pin+s_block);
    %======================================================
    %-------------- filtering through the filter bank -----------
    for k=1:n_channel
        [X(:,k),z(:,k)] = filter(window,1,grain.*het(:,k),z(:,k));
    end
    X_tilde = X.*het2;
    res = real(sum(X_tilde,2));
    DAFx_out(pin+1:pin+s_block) = res;
    pin = pin + s_block;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%------------list and saving the output----------------
DAFx_out = DAFx_out(n_channel+1:n_channel+s_buffer)/max(abs(DAFx_out));
soundsc(DAFx_out,FS);
