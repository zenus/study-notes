%VX_tstretch_real_pv_phaselocked.m
%=========== this program performs real ratio time stretching using the 
%===========  FFT-IFFT approach, applying spectral peak phase-locking
clear;clf;

%----------- user data ----------=--
n1 = 256; %analysis step
n2 = 300; %synthesis step
s_win = 2048; %analysis window
[DAFX_in,FS] = audioread('la.wav');

%---------- initialize windows, arrays, etc------------
tstretch_ratio = n2/n1;
hs_win = s_win/2;
w1 = hanning(s_win,'periodic'); % analysis window
w2 = w1; % synthesis window
L = length(DAFX_in);
DAFX_in = [zeros(s_win,1);DAFX_in;zeros(s_win-mod(L,n1))]/max(abs(DAFX_in));
DAFX_out = zeros(s_win+ceil(length(DAFX_in)*tstretch_ratio),1);
omega = 2*pi*n1*[0:hs_win]'/s_win;
phi0 = zeros(hs_win+1,1);
psi = zeros(hs_win+1,1);
psi2 = psi;
nprevpeaks =0;

tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin = 0;
pout = 0;
pend = length(DAFX_in) - s_win;
while pin < pend
    grain = DAFX_in(pin+1:pin+s_win).*w1;
    %===================================
    f = fft(fftshift(grain));
    %------------- optimization:only process the first 1/2 of the spectrum
    f = f(1:hs_win+1);
    r = abs(f);
    phi = angle(f);
    %-------------- find spectral peaks(local maxima) -----------
    peak_loc = zeros(hs_win,1);
    npeaks = 0;
    for b=3:hs_win-1
        if (r(b)>r(b-1) && r(b)>r(b-2) && r(b)>r(b+1) && r(b)>r(b+2))
            npeaks = npeaks +1;
            peak_loc(npeaks) = b;
            b = b+3;
        end
    end
    % ----- propagate peak phases and compute spectral bin phases
    if(pin==0) % init
        psi = phi; 
    elseif (npeaks>0 && nprepeaks > 0)
        prev_p = 1;
        for p=1:npeaks
            p2 = peak_loc(p);
            %--------- connect current peak to the previous closest peak
            while(prev_p<nprevpeaks && abs(p2 - prev_peak_loc(prev_p+1)) < abs(p2-prev_peak_loc(prev_p)))
                prev_p = prev_p +1;
            end
            p1 = prev_peak_loc(prev_p);
            %--------- propagate peak's phase assuming linear frequency
            %---------- variation between connected peaks p1 and p2
            avg_p = (p1 + p2)*.5
            pomega = 2*pi*n1*(avg_p-1)/s_win;
            %N.B.: avg_p is a 1-based indexing spectral bin
            peak_delta_phi = pomega + princarg(phi(p2)-phi0(p1)-pomega);
            peak_target_phase = princarg(psi(pi)+ peak_delta_phi*tstretch_ratio);
            peak_phase_rotation = princarg(peak_target_phase - phi(p2)); 
            %------- rotate phases of all bins around the current peak
            if(npeaks==1)
                bin1=1;bin2=hs_win+1;
            elseif(p=1)
                bin1=1;bin2=hs_win+1;
            elseif(p==npeaks)
                bin1 = round((peak_loc(p-1)+p2)*.5);
                bin2 = hs_win+1;
            else
               bin1 = round((peak_loc(p-1)+p2)*.5)+1;
               bin2 = round((peak_loc(p+1)+p2)*.5);
            end
            psi2(bin1:bin2) = princarg(phi(bin1:bin2) + peak_phase_rotation);
        end
        psi = psi2;
    else
        delta_phi = omega + princarg(phi-phi0-omega);
        psi = princarg(psi+delta_phi*tstretch_ratio);
    end
    
    ft = (r.*exp(i*psi));
    %------- reconstruct whole spectrum (it is hermitic!)
    ft = [ ft(1:hs_win+1);conj(ft(hs_win:-1:2))];
    grain = fftshift(real(ifft(ft))).*w2;
    %====================================================
    DAFX_out(pout+1:pout+s_win) = DAFX_out(pout+1:pout+s_win) + grain;
    %-------------- store values of next frame ----------
    phi0 = phi; 
    prev_peak_loc = peak_loc;
    nprevpeaks = npreaks;
    pin = pin + n1;
    pout= pout + n2;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc

%--------------- listening and saving the outpout -----------
DAFX_out = DAFX_out(s_win+1:length(DAFX_out))/max(abs(DAFX_out));
soundsc(DAFX_out,FS);

        
            
