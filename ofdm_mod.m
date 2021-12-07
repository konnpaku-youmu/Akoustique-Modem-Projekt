function mod_signal = ofdm_mod(symbol_seq, train_block, lt, ld, frame_len, prefix_len, on_bit_indices)
    valid_bins_per_frame = length(on_bit_indices);
    frame_len_half = (frame_len-2) / 2;

    if(isempty(on_bit_indices))
        % create the training packet
        train_subpacket = reshape(repmat(train_block, [lt, 1]), frame_len_half, []);
        % create the data packet
        symbol_packet = reshape(symbol_seq, frame_len_half, []);
    else
        frame_num = length(symbol_seq) / valid_bins_per_frame;
        symbol_multi_chan_tmp = reshape(symbol_seq, valid_bins_per_frame, []);
        symbol_packet = zeros(frame_len_half, frame_num);
        for i=1:valid_bins_per_frame
            freq_bin = on_bit_indices(i);
            symbol_packet(freq_bin, :) = symbol_multi_chan_tmp(i, :);
        end
    end
    
    num_subpackets = size(symbol_packet, 2) / ld;
    packet_to_tx = zeros(frame_len_half, num_subpackets*(lt+ld));
    for i=1:num_subpackets
        packet_to_tx(:, (i-1)*(lt+ld)+1:i*(lt+ld)) = [train_subpacket, symbol_packet(:, (i-1)*(ld)+1:i*ld)];
    end

    packet_to_tx_conj = conj(flipud(packet_to_tx));

    ofdm_packet = zeros(frame_len, num_subpackets*(lt+ld));
    ofdm_packet(2:frame_len_half+1, :) = packet_to_tx;
    ofdm_packet(frame_len_half+3:end, :) = packet_to_tx_conj;
    
    mod_signal_no_prefix = ifft(ofdm_packet, frame_len, 1);
    mod_signal_with_prefix = [mod_signal_no_prefix(end-prefix_len+1:end, :) ; mod_signal_no_prefix];

    mod_signal = reshape(mod_signal_with_prefix, 1, []);
end
