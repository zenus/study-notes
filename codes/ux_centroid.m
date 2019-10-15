% UX_centroid.m
% feature_centroid1 and 2 are centroids
% calculate by two different methods
clear;clf;
% --------- USER DATA ----------------
[DAFx_in,FS] = wavread('x1.wav');
hop = 256; %hop size between two FFTS
Wlen = 1024; %length of the windows
w = hanningz(Wlen);
%---------- some initializations -------
Wlen2 = Wlen/2;
tx = (1:Wlen/2+1)';
normW = norm(w,2);
coef = (Wlen/(2*pi));
pft = 1;
lf = floor((length(DAFx_in) - Wlen)/hop);
feature_rms = zeros(lf,1);
feature_centroid = zeros(lf,1);
feature_centroid2 = zeros(lf,1);
tic
%==========================================
pin = 0;
pend = length(DAFX_in) - Wlen;
while pin < pend
    grain = DAFX_in(pin+1:pin+Wlen).*w;
    feature_rms(pft) = norm(grain,2)/normW;
    f = fft(grain)/Wlen2;
    fx = abs(f(tx));
    feature_centroid(pft) = sum(fx.*(tx-1))/sum(fx);
    fx2 = fx.fx;
    feature_centroid2(pft) = sum(fx2.*(tx-1))/sum(fx2);
    grain2 = diff(DAFX_in(pin+1:pin+Wlen+1)).*w;
    feature_deriv(pft) = coef * norm(grain2,2) / norm(grain,2);
    pft = pft +1;
    pin = pin + hop;
end
