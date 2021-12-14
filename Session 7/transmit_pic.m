clear;
% load("Channel.mat");

fs = 16000;
Nq = 6;
SNR = 30;
frame_length = 1026;
prefix_len = 400;
BWUsage = 0.5;

lt=10;

train_bits = randi([0, 1], (frame_length/2 -1)*Nq, 1);
train_block = qam_mod(train_bits, 2^Nq, SNR);

% % Dummy transmission for bitloading
% dummy_bits = randi([0, 1], 4*(frame_length/2 -1)*Nq, 1);
% dummy_qam = qam_mod(dummy_bits, 2^Nq, SNR);
% 
% tx_dummy = ofdm_mod(dummy_qam, train_block, lt, 4, frame_length, prefix_len, []);
% 
% t = linspace(0, 0.1, 0.1 * fs);
% sync_pulse = 0.5 * sin((5000 * t * pi + 2000) .* t);
% slience_int = zeros(1, 0.1 * fs);
% % play the sound!
% [simin, nbsecs, fs] = initparams(tx_dummy, fs, sync_pulse, slience_int);
% sim('recplay');
% 
% rx_dummy = simout.signals.values;
% safe_margin = 20;
% [~, rx_dummy_aligned] = alignIO(rx_dummy, sync_pulse, slience_int, safe_margin, fs);
% 
% [H_est, ~] = ofdm_demod(rx_dummy_aligned(1:length(tx_dummy)), train_block, lt, 4, frame_length, prefix_len, []);
% HdB = 10*log10(abs(H_est));
% 
% % find frequency bins with high gain
% [~, high_gain_idx] = sort(HdB(2:frame_length/2), 'descend');
% high_gain_idx = sort(high_gain_idx(1:floor(BWUsage*(frame_length-2)/2)), 'ascend');

% start actual transmission
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
qamStream = qam_mod(bitStream, 2^Nq, SNR);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, train_block, lt, frame_length, prefix_len, []);

% Channel
% rxOfdmStream = simulate_channel(txOfdmStream, 20, 50, frame_length, prefix_len)';

t = linspace(0, 0.1, 0.1 * fs);
sync_pulse = 0.8 * sin((5000 * t * pi + 2000) .* t);
slience_int = zeros(1, 0.1 * fs);
% play the sound!
[simin, nbsecs, fs] = initparams(txOfdmStream, fs, sync_pulse, slience_int);
sim('recplay');

rxOfdmStream = simout.signals.values;
safe_margin = 20;
[~, rx_stream_aligned] = alignIO(rxOfdmStream, sync_pulse, slience_int, safe_margin, fs);

% OFDM demodulation
[H_est, rxQamStream] = ofdm_demod(rx_stream_aligned(1:length(txOfdmStream)), train_block, lt, Nq, frame_length, prefix_len, []);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream(1:length(qamStream)), 2^Nq);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% transmit_time = length(txOfdmStream) / fs;
% visualize_demod(fs, transmit_time, Nq, ld, frame_length, rxBitStream, H_est, imageSize, bitsPerPixel, colorMap, imageData, high_gain_idx);

subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;