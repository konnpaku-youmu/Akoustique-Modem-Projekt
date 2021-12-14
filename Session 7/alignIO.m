function [ccor, out_aligned] = alignIO(out, pulse, slient_interval, safe_margin, fs)
    % calculate the cross correlation
    start_idx = 1;
    for start = 4*fs:4.5*fs
        [ccor, ~, ~] = crosscorr(pulse, out(start:start+length(pulse)), 'NumLags', ceil(0.05 * length(pulse)));
        if(max(ccor) > 0.65)
            start_idx = start + ceil(0.05 * length(pulse)) + length(pulse) + length(slient_interval) - safe_margin;
            break;
        end
    end
    out_aligned = out(start_idx:end);
end