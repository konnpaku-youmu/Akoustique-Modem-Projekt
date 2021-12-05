function [H_esti, demod_sequence] = ofdm_demod(ofdm_packet, frame_len, prefix_len, on_bit_indices, train_block)
    frame_len_half = frame_len / 2;
    % serial to parallel
    ofdm_frames = reshape(ofdm_packet, frame_len + prefix_len, []);
    % clip the prefix
    ofdm_frames = ofdm_frames(prefix_len+1:end, :);

    % demodulate & channel equalization
    demod_frames = fft(ofdm_frames);

    train_block_diag = diag([0;train_block;0;conj(flipud(train_block))]);
    for sub_carr = 1:100
        % prevent sigularity
%         indices = [2:frame_len_half, frame_len_half+2:frame_len];
        H_esti = lsqr(train_block_diag, demod_frames(:, sub_carr), 1e-5, 50);
%         H_esti = train_block_diag \ demod_frames(:, sub_carr);
        demod_frames(:, sub_carr) = demod_frames(:, sub_carr)./H_esti;
    end

    % parallel to serial
    if(isempty(on_bit_indices))
        demod_sequence = reshape(demod_frames(2:frame_len_half, :), [], 1);
    else
        demod_frames_upper = demod_frames(2:frame_len_half, :);
        demod_on_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_on_freq_bins, [], 1);
    end

end
