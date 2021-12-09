clear;
% load("Channel.mat");

fs = 16000;
frame_length = 514;
Nq = 6;
SNR = 30;
prefix_len = 200;

train_bits = randi([0, 1], (frame_length/2 -1)*Nq, 1);
train_bits_repeat = repmat(train_bits, [100, 1]);

train_block = qam_mod(train_bits, 2^Nq, SNR);
txSymbols = repmat(train_block, [100, 1]);

tx = ofdm_mod(txSymbols, [], [], [], frame_length, prefix_len, []);

% H = fft(h, frame_length);
% rx_aligned = fftfilt(h, tx);

% generate the sync chirp
t = linspace(0, 0.1, 0.1 * fs);
sync_pulse = 0.5 * sin((5000 * t * pi + 2000) .* t);
slience_int = zeros(1, 0.1 * fs);
% play the sound!
[simin, nbsecs, fs] = initparams(tx, fs, sync_pulse, slience_int);
sim('recplay');

rx = simout.signals.values;
safe_margin = 20;
[CF, rx_aligned] = alignIO(rx, sync_pulse, slience_int, safe_margin, fs);

% figure(1);
% subplot(211);
% plot(rx);
% subplot(212);
% plot(rx_aligned);

[H_esti, rx_demod] = ofdm_demod(rx_aligned(1:71400), train_block, frame_length, prefix_len, []);

rx_bitstream = qam_demod(rx_demod, 2^Nq);

berTransmission = ber(train_bits_repeat, rx_bitstream);

subplot(211);
plot(10*log10(abs(H_esti)));
subplot(212);
plot(abs(ifft(H_esti)));
