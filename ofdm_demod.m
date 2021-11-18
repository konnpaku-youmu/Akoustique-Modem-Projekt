function demod_sequence = ofdm_demod(ofdm_packet, frame_len, prefix_len, ch_tf)
    frame_len_half = frame_len / 2;
    % get rid of the prefix
    ofdm_packet = ofdm_packet(prefix_len+1:end);

    % serial to parallel
    ofdm_frames = reshape(ofdm_packet, frame_len, []);
    demod_frames = fft(ofdm_frames)./ch_tf;
    demod_sequence = reshape(demod_frames(2:frame_len_half, :), [], 1);
end
