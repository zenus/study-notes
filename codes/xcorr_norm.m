function [rxx_norm, rxx, rxx0] = xcorr_norm[xp, lmin, lmax, Nblock)
%======= This function computes the normalized autocorrelation
%Inputs:
%     xp: input block
%     lmin: min of tested lag range
%     lmax: max of tested lag range
%     Nblock: block size
%
%     Outputs:
%      rxx_norm : normalized autocorr. sequence
%      rxx : autocorr. sequence
%      rxx0 : energy of delayed blocks

%---------- initializations -------------------------
x = xp((1:Nblock)+lmax);    %input block without pre-samples
lags = lmin:lmax;            % testd lag range
Nlag = length(lags);         % no. of lags

%----------- empty output variables ------------------
rxx = zeros(1,Nlag);
rxx0 = zeros(1,Nlag);
rxx_norm = zeros(1,Nlag);

%------------ computes autocorrelation(s) --------------
for v=1:Nlag
    ii = lags(v); % tested lag
    rxx0(v) = sum(xp((1:Nblock)+lmax-lags(v)).^2);
    %------- energy of delayed block
    rxx(v) = sum(x.*xp((1:Nblock)+lmax-lags(v)));
end
rxx_norm = rxx.^2./rxx0;
