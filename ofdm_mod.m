function mod_signal = ofdm_mod(symbol_seq, frame_len)
    frame_len_half = (frame_len-2) / 2;
    frame_num = length(symbol_seq) / frame_len_half;
    symbol_multi_chan = reshape(symbol_seq, frame_len_half, []);
    symbol_multi_chan_conj = conj(flipud(symbol_multi_chan));
    ofdm_packet = zeros(frame_len, frame_num);
    ofdm_packet(2:frame_len_half+1, :) = symbol_multi_chan;
    ofdm_packet(frame_len_half+3:end, :) = symbol_multi_chan_conj;
    
    mod_signal = ifft(ofdm_packet, frame_len, 1);
end
