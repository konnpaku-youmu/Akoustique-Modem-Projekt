function demod_sequence = ofdm_demod(ofdm_packet, frame_len)
    % serial to parallel
    frame_len_half = frame_len / 2;
    ofdm_frames = reshape(ofdm_packet, frame_len, []);
    demod_frames = fft(ofdm_frames);
    demod_sequence = reshape(demod_frames(2:frame_len_half, :), [], 1);
end
