%UX_discrete_cepstrum_reg.m
% function cep = discrete_cepstrum_reg(F,A,order,lambda)
%=========== This function computes the difference spectrum using a 
%regulariztion function

%Inputs  
%     F harmonic partial frequncies
%     A harmonic partial amplitudes
%     order number of cepstral coefficients
%     lambda  weighting of the perturbation
%Output
%     cep  cepstral  coefficients
function cep = discrete_cepstrum_reg(F,A,order,lambda)

%------------ reject incorrect lambda values
if lambda > 1 | lambda < 0
    disp('Error');
    cep = [];
    return ;
end

%---------- initialize matrices and vectors 
L = length(A);
M  = zeros(L,order+1);
R = zeros(order+1,1);
for i=1:L
    M(i,1)=1;
    for k=2:order+1
        M(i,k) = 2 * cos(2*pi*(k-1)*F(i));
    end
end

%---------- initialize the R vector values
coef = 8*(pi^2);
for k=1:order+1
    R(k,1) = coef * (k-1)^2;
end

%----------- compute the solution

Mt = transpose(M);
MtMR = Mt*M + (lambda/(1.-lambda))*diag(R);
cep = inv(MtMR) * Mt * log(A);

