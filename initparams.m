function [simin,nbsecs,fs]=initparams(toplay,fs)
    % Scale the input signal to [-1, 1]
%     amp_max = max(abs(toplay));
%     toplay = toplay / amp_max;

    toplay_with_interval = [zeros(fs * 2, 1)' toplay zeros(fs, 1)'];
    simin = [toplay_with_interval' toplay_with_interval'];
    
    nbsecs = max(size(toplay_with_interval)) / fs;
end