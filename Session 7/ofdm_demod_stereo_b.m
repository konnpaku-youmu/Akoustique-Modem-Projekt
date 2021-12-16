function [channel_esti, demod_sequence] = ofdm_demod_stereo_b(ofdm_packet, train_block, lt, ld, frame_len, prefix_len, on_bit_indices)
    frame_len_half = (frame_len-2) / 2;
    % serial to parallel
    ofdm_frames = reshape(ofdm_packet, frame_len + prefix_len, []);
    % clip the prefix
    ofdm_frames = ofdm_frames(prefix_len+1:end, :);

    % demodulate & channel equalization
    demod_frames = fft(ofdm_frames);

    % find the number of subpackets
    num_subpackets = floor(size(demod_frames, 2) / (lt + ld));
    leftover = size(demod_frames, 2) - num_subpackets*(ld+lt);

    channel_esti = zeros(frame_len, num_subpackets);
    
    packet_data_concat = zeros(frame_len, ld*num_subpackets + leftover);
    for i=1:num_subpackets
        subpacket = demod_frames(:, (i-1)*(lt+ld)+1:i*(lt+ld));
        packet_t = subpacket(:, 1:lt);
        packet_data = subpacket(:, lt+1:end);
        
        train_packet_serial = reshape(packet_t, [], 1);
        train_block_diag = diag([0;train_block;0;conj(flipud(train_block))]);
        X = repmat(train_block_diag, [lt, 1]);
        channel_esti(:, i) = lsqr(X, train_packet_serial, 1e-5, 100);
        
        % Channel Equalization
        packet_data = packet_data./channel_esti(:, i);
        packet_data_concat(:, (i-1)*ld+1:i*ld) = packet_data;
    end
    packet_data_leftover = demod_frames(:, end-leftover+1:end);
    packet_data_leftover = packet_data_leftover./channel_esti(:, end);
    packet_data_concat(:, end-leftover+1:end) = packet_data_leftover;

    % parallel to serial
    if(isempty(on_bit_indices))
        demod_sequence = reshape(packet_data_concat(2:frame_len_half+1, :), [], 1);
    else
        demod_frames_upper = packet_data_concat(2:frame_len_half+1, :);
        demod_actief_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_actief_freq_bins, [], 1);
    end
end
