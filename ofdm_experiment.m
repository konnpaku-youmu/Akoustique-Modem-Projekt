clear;

data_len = 9144;
Nq = 6;
SNR = 20;
frame_len = 256;
prefix_len = 800;

tx_bits = randi([0, 1], data_len, 1);
symbol_seq = qam_mod(tx_bits, 2^Nq, SNR);

tx = ofdm_mod(symbol_seq, frame_len, prefix_len);

rx = tx;

rx_symbols = ofdm_demod(rx, frame_len, prefix_len);

rx_bits = qam_demod(rx_symbols, 2^Nq);

biterr = ber(rx_bits, tx_bits);
