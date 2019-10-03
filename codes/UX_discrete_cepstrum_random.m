%UX_discrete_cepstrum_random.m
%============== This function computes the discrete spectrum using 
% multiple of each peak to which a small random added, for better smoothing

%Inputs:
%  A  harmonic partial amplitudes
%  F  harmonic partial frequencies
%  order  number of cepstral coefficients
%  lambda weighting of the perturbation
%  Nrand   nb of random points generated per pair
%  dev    deviation of random points, with Gaussian
% Outputs
%  cep   cepstral coefficients
function  cep = discrete_cepstrum_random(F,A,order,lambda,Nrand,dev)

if lambda > 1 | lambda<0
    disp('Error');
    cep = [];
    return;
end

%------------ genergate random points---------------------
L = length(A);
new_A = zeros(L*Nrand,1);
new_F = zeros(L*Nrand,1);
for k=1:L
    sigA = dev * A(k);
    sigF = dev * F(k);
    for l=1:L
        new_A((l-1)*Nrand+1) = A(l);
        new_F((l-1)*Nrand+1) = F(l);
        for n=1:Nrand
            new_A((l-1)*Nrand+n+1) = random('norm',A(l),sigA);
            new_F((l-1)*Nrand+n+1) = random('norm',A(l),sigA);
        end
    end
end

%------------ initialize matrices and vectors
L = length(new_A);
M = zeros(L,order+1);
R = zeros(order+1,L);
for i=1:L
    M(i,1)=1;
    for k=2:order+1
        M(i,k) = 2 * cos(2*pi*(k-1)*new_F(i));
    end
end
%----------  initialize the R vector values
coef = 8 * (pi^2);
for k=1:order+1
    R(k,1) = coef * (k-1)^2;
end
%---------  compute the solution
Mt = transpose(M);
MtMR = Mt*M + (lambda / (1.-lambda))*diag(R);
cep = inv(MtMR) * Mt * log(new_A);
