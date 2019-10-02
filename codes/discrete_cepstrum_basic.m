% function cep = discrete_cepstrum_basic(F,A,order)
%================ This function computes the discrete spectrum regardless
% of matrix conditioning and singularity

% Input
% A  harmonic partical amplitudes
% F  harmonic partical frequenceies
% order number of cepstral coefficients

%outputs 
% cep  cepstral coefficients
function cep = discrete_cepstrum_basic(F,A,order)

%----- initialize matrices and vectors ------------------
L = length(A);
M = zeros(L,order+1);
M = zeros(L,L);
R = zeros(order+1,1);
W = zeros(L,L);

for i=1:L
    M(i,1) = 0.5;
    for k=2:order+1
        M(i,k) = cos(2*pi*(k-1)*F(i));
    end
    W(i,i) =1;
end

M =2.*M;

%---------------- compute the solution, regardless of the matrix
%conditioning
Mt = transpose(M);
MtWMR = Mt*W*M
cep  = inv(MtWMR) * Mt * W * log(A);


    
