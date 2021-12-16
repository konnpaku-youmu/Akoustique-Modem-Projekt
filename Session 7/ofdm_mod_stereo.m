function [ofdm_stream_l, ofdm_stream_r] = ofdm_mod_stereo(symbol_seq, train_block, lt, frame_len, a, b, prefix_len, on_bit_indices)
    actief_num_bins = length(on_bit_indices);
    frame_len_half = (frame_len-2) / 2;
    
    % create the training packet
    train_packet = reshape(repmat(train_block, [lt, 1]), frame_len_half, []);

    if(isempty(on_bit_indices))
        % create the data packet
        symbol_packet = reshape(symbol_seq, frame_len_half, []);
    else
        frame_num = ceil(length(symbol_seq) / actief_num_bins);
        symbol_seq_padded = zeros(actief_num_bins*frame_num, 1);
        symbol_seq_padded(1:length(symbol_seq)) = symbol_seq;
        symbol_subpacket_tmp = reshape(symbol_seq_padded, actief_num_bins, []);
        symbol_packet = zeros(frame_len_half, frame_num);
        for i=1:actief_num_bins
            freq_bin = on_bit_indices(i);
            symbol_packet(freq_bin, :) = symbol_subpacket_tmp(i, :);
        end
    end
    
    packet_to_tx = [train_packet, symbol_packet];

    packet_to_tx_conj = conj(flipud(packet_to_tx));

    ofdm_packet = zeros(frame_len, size(packet_to_tx, 2));
    ofdm_packet(2:frame_len_half+1, :) = packet_to_tx;
    ofdm_packet(frame_len_half+3:end, :) = packet_to_tx_conj;

    ofdm_packet_l = a.*ofdm_packet;
    ofdm_packet_r = b.*ofdm_packet;
    
    ofdm_stream_l_no_prefix = ifft(ofdm_packet_l, frame_len, 1);
    ofdm_stream_l_with_prefix = [ofdm_stream_l_no_prefix(end-prefix_len+1:end, :) ; ofdm_stream_l_no_prefix];
    ofdm_stream_r_no_prefix = ifft(ofdm_packet_r, frame_len, 1);
    ofdm_stream_r_with_prefix = [ofdm_stream_r_no_prefix(end-prefix_len+1:end, :) ; ofdm_stream_r_no_prefix];

    ofdm_stream_l = reshape(ofdm_stream_l_with_prefix, 1, []);
    ofdm_stream_r = reshape(ofdm_stream_r_with_prefix, 1, []);
end


