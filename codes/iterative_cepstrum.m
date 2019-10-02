%function [env,source] = iterative_cepstrum(FT,NF,order,eps,niter,Delat)
%=============== This function computes the spectral enveloppe using the
%iteractive cepstrum method

%Inputs:
% -FT [NF*1 | complex]  Fourier transform X(NF,k)
% -NF [1*1 | int]  number of frequency bins
% -order [1*1 | float ]  cepstrum truncation order
% -eps [1*1 | float ]  bias
% -niter[1*1 | int]  maximum number of iterations
% -Delta[1*1 | float]  spectral enevelop difference threshold

%outputs
% -env [NFx1 | float]  magnitude of spectral enveloppe
% -source [NFx1 | complex] complex source
function [env,source] = iterative_cepstrum(FT,NF,order,eps,niter,Delta)

%-------------- initializing --------------------
EP = FT;

%------  computing iterative cepstrum -------------
for k=1:niter
    flog = log(max(eps,abs(Ep)));
    cep = ifft(flog);
    cep_cut = [cep(1)/2;cep(2:order);zeros(NF-order,1)];
    flog_cut = 2*real(fft(cep_cut));
    env = exp(flog_cut);
    Ep = max(env,Ep);
    %------------ convergence criterion ----------------
    if(max(abs(Ep)) <= Delta) break; end
end

%-------------- computing source from enveloppe ------------
source  = FT./env;
    

