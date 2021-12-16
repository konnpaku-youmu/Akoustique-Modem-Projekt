function [channel_esti, demod_sequence] = ofdm_demod_stereo(ofdm_packet, train_block, H_comb, lt, frame_len, prefix_len, on_bit_indices)
    frame_len_half = (frame_len-2) / 2;
    % serial to parallel
    ofdm_frames = reshape(ofdm_packet, frame_len + prefix_len, []);
    % clip the prefix
    ofdm_frames = ofdm_frames(prefix_len+1:end, :);

    % demodulate
    demod_frames = fft(ofdm_frames);

    % find the initial condition using training block
    packet_tr = demod_frames(:, 1:lt);
    tr_serial = reshape(packet_tr, [], 1);
    tr_diag = diag([0;train_block;0;conj(flipud(train_block))]);
    X = repmat(tr_diag, [lt, 1]);
    channel_esti = lsqr(X, tr_serial, 1e-5, 50);

    packet_data = demod_frames(:, lt+1:end);

    % channel equalization
    if(isempty(H_comb))
        packet_data = packet_data./channel_esti;
    else
        packet_data = packet_data./H_comb;
    end

    % parallel to serial
    if(isempty(on_bit_indices))
        demod_sequence = reshape(packet_data(2:frame_len_half+1, :), [], 1);
    else
        demod_frames_upper = packet_data(2:frame_len_half+1, :);
        demod_actief_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_actief_freq_bins, [], 1);
    end

end
