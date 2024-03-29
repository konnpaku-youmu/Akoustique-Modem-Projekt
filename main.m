% Exercise session 4: DMT-OFDM transmission scheme
clear;

Nq = 6;
SNR = 20;
prefix_len = 800;

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, 2^Nq, SNR);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, 5122, prefix_len);

% Channel
rxOfdmStream = txOfdmStream;

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream, 5122, prefix_len);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream, 2^Nq);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
