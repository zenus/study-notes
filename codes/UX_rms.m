clear;clf;
%-------  user data ------------------
[DAFX_in,FS] = audioread('x1.wav');
hop = 256; % hop size between two FFTS
WLen = 1024; % length of the windows
w = hanningz(WLen);
%---------  some initializations -------
WLen2 = WLen /2;
normW = norm(w,2);
pft = 1;
lf = floor(((length(DAFX_in) - WLen)/hop));
feature_rms = zeros(lf,1);
tic
%=======================================
pin = 0;
pend = length(DAFX_in) - WLen;

while pin < pend
    grain = DAFX_in(pin+1:pin+WLen).*w;
    feature_rms(pft) = norm(grain,2)/normW;
    pft = pft +1 ;
    pin = pin + hop;
end
%=============================================
toc
