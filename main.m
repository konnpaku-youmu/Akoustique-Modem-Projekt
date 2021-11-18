% Exercise session 4: DMT-OFDM transmission scheme
clear;

Nq = 6;

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, 2^Nq);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, 5122);

% Channel
rxOfdmStream = txOfdmStream;

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream, 5122);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream, 2^Nq);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
