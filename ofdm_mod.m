function mod_signal = ofdm_mod(symbol_seq, frame_len, prefix_len, on_bit_indices)
    valid_bins_per_frame = length(on_bit_indices);

    frame_len_half = (frame_len-2) / 2;

    if(isempty(on_bit_indices))
        frame_num = length(symbol_seq) / frame_len_half;
        symbol_multi_chan = reshape(symbol_seq, frame_len_half, []);
    else
        frame_num = length(symbol_seq) / valid_bins_per_frame;
        symbol_multi_chan_tmp = reshape(symbol_seq, valid_bins_per_frame, []);
        symbol_multi_chan = zeros(frame_len_half, frame_num);
        for i=1:valid_bins_per_frame
            freq_bin = on_bit_indices(i);
            symbol_multi_chan(freq_bin, :) = symbol_multi_chan_tmp(i, :);
        end
    end

    symbol_multi_chan_conj = conj(flipud(symbol_multi_chan));
    ofdm_packet = zeros(frame_len, frame_num);
    ofdm_packet(2:frame_len_half+1, :) = symbol_multi_chan;
    ofdm_packet(frame_len_half+3:end, :) = symbol_multi_chan_conj;
    
    mod_signal_no_prefix = ifft(ofdm_packet, frame_len, 1);
    mod_signal_with_prefix = [mod_signal_no_prefix(end-prefix_len+1:end, :) ; mod_signal_no_prefix];

    mod_signal = reshape(mod_signal_with_prefix, 1, []);
end
