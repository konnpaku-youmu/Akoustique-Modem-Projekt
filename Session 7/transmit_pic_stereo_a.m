% Generate random IR
fs = 16000;
Nq = 6;
SNR = 40;
frame_length = 1026;
prefix_len = 400;
lt = 5;

% generate random channel IR
IR_len = 200;
h_1 = rand(IR_len, 1);
h_2 = rand(IR_len, 1);

H_1 = fft(h_1, frame_length);
H_2 = fft(h_2, frame_length);

% find scalar a & b
[a, b, H_comb] = fixed_transmitter_side_beamformer(H_1, H_2);

train_bits = randi([0, 1], (frame_length/2 -1)*Nq, 1);
train_block = qam_mod(train_bits, 2^Nq, SNR);

[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
qamStream = qam_mod(bitStream, 2^Nq, SNR);

[ofdm_stream_l, ofdm_stream_r] = ofdm_mod_stereo(qamStream, train_block, lt, frame_length, a, b, prefix_len, []);

rx_ofdm_stream_l = fftfilt(h_1, ofdm_stream_l);
rx_ofdm_stream_r = fftfilt(h_2, ofdm_stream_r);

rx_ofdm_stream = rx_ofdm_stream_r + rx_ofdm_stream_l;

rx_ofdm_stream = awgn(rx_ofdm_stream, 30, 'measured');

[~, rx_qam_stream] = ofdm_demod_stereo(rx_ofdm_stream, train_block, H_comb, lt, frame_length, prefix_len, []);

rx_bitstream = qam_demod(rx_qam_stream, 2^Nq);

% Check the BER
berTransmission = ber(bitStream, rx_bitstream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rx_bitstream, imageSize, bitsPerPixel);
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
