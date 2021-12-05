clear;
load("Channel.mat");
% h = rand(400, 1);
% h = rand(100, 1);
% h = rand(10, 1);

Nq = 6;
SNR = 25;
frame_len = 3202;
prefix_len = 1.2 * length(h);

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, 2^Nq, SNR);

% on-off loading
H = fft(h, frame_len);
HdB = 20 * log10(abs(H));

% subplot(121);
% plot(HdB);

% select frequencies
[~, high_gain_idx] = sort(HdB(2:frame_len/2), 'descend');
high_gain_idx = sort(high_gain_idx(1:32), 'ascend');

% subplot(122);
% plot(HdB(high_gain_idx));
% pause(0.2);

% OFDM modulation
txOfdmStream = ofdm_mod(qamStream, frame_len, prefix_len, high_gain_idx);
% txOfdmStream = ofdm_mod(qamStream, frame_len, prefix_len, []);

% Channel
rxOfdmStream = filter(h, 1, txOfdmStream);

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream, frame_len, prefix_len, H, high_gain_idx);
% rxQamStream = ofdm_demod(rxOfdmStream, frame_len, prefix_len, H, []);
% rxQamStream = awgn(rxQamStream, SNR);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream, 2^Nq);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(('Received image')); drawnow;
