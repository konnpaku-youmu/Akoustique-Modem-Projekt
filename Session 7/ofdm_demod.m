function [channel_est, demod_sequence] = ofdm_demod(ofdm_packet, train_block, lt, Nq, frame_len, prefix_len, on_bit_indices)
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
    H_init = lsqr(X, tr_serial, 1e-5, 50);

    packet_data = demod_frames(:, lt+1:end);
    data_framenum = size(packet_data, 2);
    
    mu_bar = 0.1;
    alpha =  0.005;
    
    channel_est = zeros(frame_len_half, data_framenum);
    % perform NLMS at each frequency bin
    for freq_bin = 2:frame_len_half+1
        W_k = zeros(data_framenum, 1);
        tone_data = packet_data(freq_bin, :);
        % init value
        W_k(1) = 1./conj(H_init(freq_bin));
        
        % NLMS updating
        for i=1:data_framenum-1
            % measurement
            m_k = W_k(i)*tone_data(i+1);
            % desired value
            d_k = qam_mod(qam_demod(m_k, 2^Nq), 2^Nq, 30);
            % update step
            W_k(i+1) = W_k(i) + mu_bar/(alpha + conj(tone_data(i+1))*tone_data(i+1)) ...
                       * tone_data(i+1) ...
                       * conj(d_k - m_k);
        end

        channel_est(freq_bin, :) = 1./conj(W_k);
    end

    % channel equalization
    packet_data(2:frame_len_half+1, :) = packet_data(2:frame_len_half+1, :)./channel_est(2:frame_len_half+1, :);
    
%     packet_data_concat = zeros(frame_len, ld*num_subpackets + leftover);
%     for i=1:num_subpackets
%         subpacket = demod_frames(:, (i-1)*(lt+ld)+1:i*(lt+ld));
%         packet_t = subpacket(:, 1:lt);
%         packet_data = subpacket(:, lt+1:end);
%         
%         train_packet_serial = reshape(packet_t, [], 1);
%         train_block_diag = diag([0;train_block;0;conj(flipud(train_block))]);
%         X = repmat(train_block_diag, [lt, 1]);
%         H_esti(:, i) = lsqr(X, train_packet_serial, 1e-5, 100);
%         
%         % Channel Equalization
%         packet_data = packet_data./H_esti(:, i);
%         packet_data_concat(:, (i-1)*ld+1:i*ld) = packet_data;
%     end
%     packet_data_leftover = demod_frames(:, end-leftover+1:end);
%     packet_data_leftover = packet_data_leftover./H_esti(:, end);
%     packet_data_concat(:, end-leftover+1:end) = packet_data_leftover;

    % parallel to serial
    if(isempty(on_bit_indices))
        demod_sequence = reshape(packet_data(2:frame_len_half+1, :), [], 1);
    else
        demod_frames_upper = packet_data(2:frame_len_half+1, :);
        demod_actief_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_actief_freq_bins, [], 1);
    end

end
