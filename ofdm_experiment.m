clear;

data_len = 9144;
Nq = 6;
packet_len = 256;

tx_bits = randi([0, 1], data_len, 1);
symbol_seq = qam_mod(tx_bits, 2^Nq);

tx = ofdm_mod(symbol_seq, packet_len);

nullidx = [1 129]';
tx_builtin = ofdmmod(symbol_seq, 256, 0, nullidx);

rx = tx;

% OFDM demod
packet_num = length(rx) / packet_len;
rx_reshape = reshape(rx, packet_len, packet_num);
rx_symbols = zeros(packet_num * (packet_len / 2 - 1), 1);

for i=1:packet_num
    rx_i = fft(rx_reshape(:, i));
    rx_symbols(1+(i-1)*(packet_len/2 - 1) : i*(packet_len/2-1)) = rx_i(2:packet_len/2);
end

rx_symbols = rx_symbols(1:data_len / Nq);
rx_bits = qam_demod(rx_symbols, 2^Nq);

[numerr, biterr] = ber(rx_bits, tx_bits);
