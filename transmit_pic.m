clear;
% load("Channel.mat");

fs = 16000;
Nq = 6;
SNR = 30;
frame_length = 1026;
prefix_len = 400;

lt=5;
ld=5;

[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
qamStream = qam_mod(bitStream, 2^Nq, SNR);

train_bits = randi([0, 1], (frame_length/2 -1)*Nq, 1);
train_block = qam_mod(train_bits, 2^Nq, SNR);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, train_block, lt, ld, frame_length, prefix_len, []);

% Channel
% rxOfdmStream = simulate_channel(txOfdmStream, 20, 50, frame_length, prefix_len)';

t = linspace(0, 0.1, 0.1 * fs);
sync_pulse = 0.5 * sin((5000 * t * pi + 2000) .* t);
slience_int = zeros(1, 0.1 * fs);
% play the sound!
[simin, nbsecs, fs] = initparams(txOfdmStream, fs, sync_pulse, slience_int);
sim('recplay');

rxOfdmStream = simout.signals.values;
safe_margin = 20;
[~, rx_stream_aligned] = alignIO(rxOfdmStream, sync_pulse, slience_int, safe_margin, fs);

% OFDM demodulation
[H_est, rxQamStream] = ofdm_demod(rx_stream_aligned(1:length(txOfdmStream)), train_block, lt, ld, frame_length, prefix_len, []);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream, 2^Nq);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

visualize_demod(fs, ld, rxBitStream, H_est, imageSize, bitsPerPixel, colorMap, imageData);

% % Plot images
% subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
% subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
