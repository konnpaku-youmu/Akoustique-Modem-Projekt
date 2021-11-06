seq_len = 6144;
Nq = 6;

rand_binary = randi([0, 1], seq_len, 1);
symbol_seq = qam_mod(rand_binary, 2^Nq);

demod_seq = qam_demod(symbol_seq, 2^Nq);

% [err_num, ber] = biterr(rand_binary, demod_seq);

biterr = ber(rand_binary, demod_seq);
