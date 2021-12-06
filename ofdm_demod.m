function [H_esti, demod_sequence] = ofdm_demod(ofdm_packet, train_block, lt, ld, frame_len, prefix_len, on_bit_indices)
    frame_len_half = (frame_len-2) / 2;
    % serial to parallel
    ofdm_frames = reshape(ofdm_packet, frame_len + prefix_len, []);
    % clip the prefix
    ofdm_frames = ofdm_frames(prefix_len+1:end, :);

    % demodulate & channel equalization
    demod_frames = fft(ofdm_frames);

    packetserial = reshape(demod_frames, [], 1);

    train_block_diag = diag([0;train_block;0;conj(flipud(train_block))]);
    X = repmat(train_block_diag, [100, 1]);
    H_esti = lsqr(X, packetserial, 1e-5, 100);
    
    % Channel Equalization
    demod_frames = demod_frames./H_esti;

    % parallel to serial
    if(isempty(on_bit_indices))
        demod_sequence = reshape(demod_frames(2:frame_len_half+1, :), [], 1);
    else
        demod_frames_upper = demod_frames(2:frame_len_half, :);
        demod_on_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_on_freq_bins, [], 1);
    end

end
