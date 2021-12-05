function [simin,nbsecs,fs]=initparams(toplay, fs, sync_pulse, silent_interval)
    % Scale the input signal to [-1, 1]
    amp_max = max(abs(toplay));
    toplay = toplay / amp_max;

    toplay_with_interval = [zeros(fs * 4, 1)' sync_pulse silent_interval toplay zeros(fs, 1)'];
    simin = [toplay_with_interval' toplay_with_interval'];
    
    nbsecs = max(size(toplay_with_interval)) / fs;
end