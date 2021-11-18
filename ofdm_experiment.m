clear;

data_len = 9144;
Nq = 6;
frame_len = 256;
prefix_len = 800;

tx_bits = randi([0, 1], data_len, 1);
symbol_seq = qam_mod(tx_bits, 2^Nq);

tx = reshape(ofdm_mod(symbol_seq, frame_len), 1, []);
tx_prefix = [tx(end-prefix_len+1:end), tx];

rx_prefix = tx_prefix;

rx = rx_prefix(prefix_len+1:end);
rx_symbols = ofdm_demod(rx, frame_len);

rx_bits = qam_demod(rx_symbols, 2^Nq);

[numerr, biterr] = ber(rx_bits, tx_bits);
