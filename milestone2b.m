clear;
load("Channel.mat");
% h = rand(400, 1);
% h = rand(100, 1);
% h = rand(10, 1);

Nq = 4;
SNR = 40;
frame_len = 9602;
prefix_len = 1.5 * length(h);

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, 2^Nq, SNR);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, frame_len, prefix_len);

% Channel
H = fft(h, frame_len);
plot(abs(H));

rxOfdmStream = filter(h, 1, txOfdmStream);

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream, frame_len, prefix_len, H);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream, 2^Nq);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
