function mod_signal = ofdm_mod(symbol_seq, packet_len)
    packet_num = 2 * length(symbol_seq) / packet_len + 1;
    frame = zeros(packet_len, packet_num);
    frame_ifft = zeros(packet_len, packet_num);

    symbol_seq_padding = zeros(packet_num * (packet_len / 2 - 1), 1);
    symbol_seq_padding(1:length(symbol_seq)) = symbol_seq;
    for i=1:packet_num
        frame(2:packet_len/2, i) = symbol_seq_padding(1+(i-1)*(packet_len/2 - 1) : i*(packet_len/2-1));
        frame(packet_len/2+2:end, i) = conj(flipud(frame(2:packet_len/2, i)));
        frame_ifft(:, i) = ifft(frame(:, i));
    end

    mod_signal = reshape(frame_ifft, packet_len * packet_num, 1);
end