%Pitch_Tracker_FFT_Main.m
%============== This function demonstrates a pitch tracking algorithm
%============== in a block-based implementation

%--------------- initialization ------------------
fname = 'Toms_diner';
n0 = 2000; %start index
n1 = 210000;

Nfft = 1024;
R = 1; %FFT hop size for pitch estimation
K = 200; % hop size for time resolution of pitch estimation
thres = 50; % threshold for FFT maxima
% checked pitch range in Hz:
fmin = 50;
fmax = 800;
p_fac_thres = 1.05; %threshold for voiced detection;
win = hanning(Nfft)'; % window of FFT
Nx = n1-n0+1+R; % signal length
blocks = floor(Nx/K);
Nx = (blocks-1)*K + Nfft + R;
n1 = n0 + K; % new end index
[X,Fs] = audioread(fname,[n0,n1]);
X = X(:,1)';

%-------------- pitch extraction per block ----------------------
pitches = zeros(1,blocks);
for b=1:blocks
    x = X((b-1)*K+1+(1:Nfft+R));
    [FFTidx, F0_est, F0_corr] = find_pitch_fft(x,win,Nfft,Fs,R,fmin,fmax,thres);
    if ~isempty(F0_corr)
        pitches(b) = F0_corr(1); % take candidate with lowest pitch
    else
        pitches(b) = 0;
    end
end

%--------------- post-processing -----------------------------------
L = 9; % odd number of blocks of mean calculation
D = (L-1)/2; % delay
h = ones(1,L)./L; % impulse response for mean calculation
% -------------- mirror beginning and end for "non-causal" filtering ------
p = [pitches(D+1:-1:2),pitches,pitches(blocks-1:-1:blocks-D)];
y = conv(p,h); % length: blocks+2D+2D
pm = y((1:blocks)+2*D); %cut result

Fac = zeros(1,blocks);
idx = find(pm~=0); % do not divide by zero
Fac(idx) = pitches(idx)./pm(idx);
ii = find(Fac<1 & Fac~=0);
Fac(ii) = 1./Fac(ii); % all non-zeros elements are now > 1
%----------------  voiced/unvoiced detection -----------------
voiced = Fac ~=0 & Fac < p_fc_thres;

T = 40; %time in ms for segment lengths
M = round(T/1000*Fs/K); %min.number of consecutive blocks
[V,p2] = segmentation(voiced,M,pitches);
p2 = V.*p2; % set pitches to zero for unvoiced
