seq_len = 16800;
rand_binary = randi([0, 1], seq_len, 1);

% QAM-16
Nq = 4;
biterr_16 = zeros(100, 1);
for i=0:99
    symbol_seq = qam_mod(rand_binary, 2^Nq, i);
    demod_seq = qam_demod(symbol_seq, 2^Nq);
    biterr_16(i+1) = ber(rand_binary, demod_seq);
end

loglog(biterr_16, 'DisplayName', 'QAM-16');
% semilogx(biterr_16, 'DisplayName', 'QAM-16');
hold on

% QAM-32
Nq = 5;
biterr_32 = zeros(100, 1);
for i=0:99
    symbol_seq = qam_mod(rand_binary, 2^Nq, i);
    demod_seq = qam_demod(symbol_seq, 2^Nq);
    biterr_32(i+1) = ber(rand_binary, demod_seq);
end

loglog(biterr_32, 'DisplayName', 'QAM-32');
% semilogx(biterr_32, 'DisplayName', 'QAM-32');
hold on

% QAM-64
Nq = 6;
biterr_64 = zeros(100, 1);
for i=0:99
    symbol_seq = qam_mod(rand_binary, 2^Nq, i);
    demod_seq = qam_demod(symbol_seq, 2^Nq);
    biterr_64(i+1) = ber(rand_binary, demod_seq);
end

loglog(biterr_64, 'DisplayName', 'QAM-64');
% semilogx(biterr_64, 'DisplayName', 'QAM-64');
hold on

% QAM-128
Nq = 7;
biterr_128 = zeros(100, 1);
for i=0:99
    symbol_seq = qam_mod(rand_binary, 2^Nq, i);
    demod_seq = qam_demod(symbol_seq, 2^Nq);
    biterr_128(i+1) = ber(rand_binary, demod_seq);
end

loglog(biterr_128, 'DisplayName', 'QAM-128');
% semilogx(biterr_128, 'DisplayName', 'QAM-128');
hold on

legend
xlabel("SNR(dB)");
ylabel("BER");
title("BER vs SNR");
