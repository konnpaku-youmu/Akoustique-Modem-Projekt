f = @qam_mod;
g = @random_binary;

rand_seq = random_binary(1000);
out_qam = qam_mod(rand_seq, 64);
scatterplot(out_qam);
