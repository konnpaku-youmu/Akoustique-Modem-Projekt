clear;

Nq = 6;
SNR = 25;
frame_length = 514;
prefix_len = 256;

[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
qamStream = qam_mod(bitStream, 2^Nq, SNR);

train_bits = randi([0, 1], (frame_length/2 -1)*Nq, 1);
train_block = qam_mod(train_bits, 2^Nq, SNR);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, train_block, 20, 50, frame_length, prefix_len, []);

% Channel
rxOfdmStream = simulate_channel(txOfdmStream, 20, 50, frame_length, prefix_len)';

% % OFDM demodulation
% rxQamStream = ofdm_demod(rxOfdmStream, frame_length, prefix_len);
% 
% % QAM demodulation
% rxBitStream = qam_demod(rxQamStream, 2^Nq);
% 
% % Compute BER
% berTransmission = ber(bitStream,rxBitStream);
% 
% % Construct image from bitstream
% imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);
% 
% % Plot images
% subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
% subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
