% ------- user data ------------
wlen = 4096;
hopsize = 1024;
lh = 17; % length of the harmonic median filter
lp = 17; % length of the percussive median filter
p = 2;
w1 = hanning(wlen,'periodic');
w2 = w1;
hlh = floor(lh/2) + 1;
th = 2500;
[DAFX_in,FS] = audioread('filename');
L = length(DAFX_in);
DAFX_in = [zeros(wlen,1); DAFX_in; zeros(wlen-mod(L,hopsize),1)] / max(abs(DAFX_in));
DAFX_out1 = zeros(length(DAFX_in),1);
DAFX_out2 = zeros(length(DAFX_in),1);

%----------- initialisations ---------------
grain = zeros(wlen,1);
buffer = zeros(wlen,1h);
buffercomplex = zeros(wlen,lh);
oldperframe = zeros(wlen,1);
onall = [];
onperc = [];

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin =0;
pout = 0;
pend = length(DAFX_in) - wlen;
while pin < pend
    grain = DAFX_in(pin+1:pin+wlen).*w1;
    %==========================================
    fc = fft(fftshift(grain));
    fa = abs(fc);
    % remove oldest frame from buffers and add
    %current frame to buffers
    buffercomplex(:,1:lh-1) = buffercomplex(:,2:end);
    buffercomplex(:,lh) = fc;
    buffer(:,1:lh-1) = buffer(:,2:end);
    buffer(:,lh) = fa;
    % do median filtering within frame to suppress harmonic instruments
    Per = medfilt1(buffer(:,hlh),lp);
    % do median filtering no buffer to suppress percussion instruments
    Har = median(buffer,2);
    % use these Percussion and Harmonic enhanced frames to generate masks
    maskHar = (Har.^p) / (Har.^p + Per.^p);
    maskPer = (Per.^p) / (Har.^p + Per.^p);
    
   %apply masks to middle frame in buffer
   % Note: this is the "current" frame from the point of view of the median
   %filtering 
   curframe =  buffercomplex(:,hlh);
   perframe =  curframe.*maskPer;
   harframe =  curframe.*maskHar;
   grain1 = fftshift(real(ifft(perframe))).*w2;
   grain2 = fftshift(real(ifft(harframe))).*w2;
   % onset detection functions
   % difference of frames
   dall = buffer(:,hlh)-buffer(:,hlh-1);
   dperc = abs(perframe) - oldperframe;
   oall = sum(dall>0);
   operc = sum(dperc>0);
   onall = [onall oall];
   onperc = [onperc operc];
   oldperframe = abs(perframe);
   %=============================================
   DAFX_out1(pout+1:pout+wlen) = DAFX_out1(pout+1:pout+wlen) + grain1;
   DAFX_out2(pout+1:pout+wlen) = DAFX_out2(pout+1:pout+wlen) + grain2;
   pin = pin + hopsize;
   pout = pout + hopsize;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%process onset detection funciton to get beats
[or,oc] = size(onall);
omin = min(onall);
% get peaks
v1 = (onall > [omin,onall(1:(oc-1))]);
% allow for greater-than-or-equal
v2 = (onall >=[onall(2:oc),omin]);
% simple Beta tracking function
omax = onall .* (onall > th).*v1.*v2;
% now do the same for the percussion onset detection function
% process onset detection function to get beats
[opr,opc] = size(onperc);
opmin = min(onperc);
% get peaks
p1 = (onperc > [opmin, onperc(1:(opc-1))]);
% allow for greater-than-or-equal
p2 = (onperc >= [onperc(2:opc),opmin]);
%simple Beat tracking function
opmax = onperc .* (onperc > th).*p1.*p2;
%------------ listening and saving the output ----------------
DAFX_out1 = DAFX_out1((wlen + hopsize*(hlh-1)):length(DAFX_out1))/max(abs(DAFX_out1));
DAFX_out2 = DAFX_out2((wlen + hopsize*(hlh-1)):length(DAFX_out2))/max(abs(DAFX_out2));
soundsc(DAFX_out1,FS);
soundsc(DAFX_out2,FS);


