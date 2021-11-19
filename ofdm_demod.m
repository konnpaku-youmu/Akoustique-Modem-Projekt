function demod_sequence = ofdm_demod(ofdm_packet, frame_len, prefix_len, ch_tf, on_bit_indices)
    % get rid of the prefix
    ofdm_packet = ofdm_packet(prefix_len+1:end);
    
    frame_len_half = frame_len / 2;
    % serial to parallel
    ofdm_frames = reshape(ofdm_packet, frame_len, []);
    demod_frames = fft(ofdm_frames)./ch_tf;
    if(isempty(on_bit_indices))
        demod_sequence = reshape(demod_frames(2:frame_len_half, :), [], 1);
    else
        demod_frames_upper = demod_frames(2:frame_len_half, :);
        demod_on_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_on_freq_bins, [], 1);
    end
end
