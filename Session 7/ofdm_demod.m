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
    
    mu_bar = 0.3;
    alpha =  0.05;

    W_k = zeros(frame_len, data_framenum);
    W_k(:, 1) = 1./conj(H_init);
    W_k(1, 1) = 0;
    W_k(frame_len_half + 2, 1) = 0;

    for frame=1:data_framenum-1
        m_k = W_k(:, frame)'*packet_data(:, frame+1);
        d_k = qam_mod(qam_demod(m_k, 2^Nq), 2^Nq, 40);

        W_k(:, frame+1) = W_k(:, frame) + mu_bar/(alpha + packet_data(:, frame+1)'*packet_data(:, frame+1)) ...
                        * packet_data(:, frame+1) ...
                        * conj(d_k - m_k);
    end

    % channel equalization
    packet_data = ((W_k').').*packet_data;

    channel_est = (1./(W_k)').';

    % parallel to serial
    if(isempty(on_bit_indices))
        demod_sequence = reshape(packet_data(2:frame_len_half+1, :), [], 1);
    else
        demod_frames_upper = packet_data(2:frame_len_half+1, :);
        demod_actief_freq_bins = demod_frames_upper(on_bit_indices, :);
        demod_sequence = reshape(demod_actief_freq_bins, [], 1);
    end

end
