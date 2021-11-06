clear;

data_len = 6144;
Nq = 6;
packet_len = 256;

rand_binary = randi([0, 1], data_len, 1);
symbol_seq = qam_mod(rand_binary, 2^Nq);

packet_num = 2 * length(symbol_seq) / packet_len + 1;
% OFDM mod
tx = ofdm_mod(symbol_seq, packet_len);

rx = tx;

% % OFDM demod
% rx_reshape = reshape(rx, packet_len, packet_num);
% rx_symbols = zeros(packet_num * (packet_len / 2 - 1), 1);
% 
% for i=1:packet_num
%     rx_i = fft(rx_reshape(:, i));
%     rx_symbols(1+(i-1)*(packet_len/2 - 1) : i*(packet_len/2-1)) = rx_i(2:packet_len/2);
% end
% 
% rx_symbols = rx_symbols(1:data_len / Nq);
% rx_bits = qam_demod(rx_symbols, 2^Nq);
% 
% [numerr, biterr] = ber(rx_bits, rand_binary);
