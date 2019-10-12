function pitch=yinDAFX(x,fs,f0min,hop)
% function pitch=yinDAFX(x,fs,f0min,hop)
% Author: Adrian v.d. knesebeck
% determines the pitches of the input signal x at a given hop size

%input 
%x  input signal
%fs  sampling frequency
%f0min minimum detectable pitch
%hop  hop size

%ouput:
%pitch: pitch frequencies in HZ at the given hop size

%initializtion
yinTolerance = 0.22
taumax = round(1/f0min*fs);
yinLen = 1024;
k =0;

%frame processing
for i=1:hop:(length(x)-(yinLen+taumax))
    k =k+1;
    xframe = x(i:i+(yinLen+taumax));
    yinTemp = zeros(1,taumax);
    %calculate the square diferences
    for tau=1:taumax
        for j=1:yinLen
            yinTemp(tau) = yinTemp(tau) + (xframe(j) - xframe(j+tau))^2;
        end
    end
    %calculate cumulated normalization
    tmp =0;
    yinTemp(1) = 1;
    for tau=2:taumax
        tmp = tmp + yinTemp(tau);
        yinTemp(tau) = yinTemp(tau) * (tau/tmp);
    end
    % determine lowest pitch
    tau = 1;
    while(tau<taumax)
        if(yinTemp(tau)<yinTolerance)
            % search turning point
            while(yinTemp(tau+1)<yinTemp(tau))
                tau = tau +1;
            end
            pitch(k) = fs/tau;
            break;
        else
            tau = tau +1;
        end
        % if no pitch detected
        pitch(k)=0;
    end
end
end
