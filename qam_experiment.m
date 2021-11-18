seq_len = 6144;
Nq = 6;

rand_binary = randi([0, 1], seq_len, 1);
symbol_seq = qam_mod(rand_binary, 2^Nq, 20);

demod_seq = qam_demod(symbol_seq, 2^Nq);

biterr = ber(rand_binary, demod_seq);
