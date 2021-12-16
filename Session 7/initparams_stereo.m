function [simin,nbsecs,fs]=initparams_stereo(toplay, fs, sync_pulse, silent_interval)
    % Scale the input signal to [-1, 1]
    amp_max = max(abs(toplay));
    toplay = toplay ./ amp_max;
    
    sync_stereo = [sync_pulse; sync_pulse];
    toplay_with_interval = [zeros(2, fs * 4) sync_stereo [silent_interval;silent_interval] toplay zeros(2, fs)];
    simin = toplay_with_interval';
    
    nbsecs = max(size(toplay_with_interval)) / fs;
end