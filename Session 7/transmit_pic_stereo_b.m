clear;

fs = 16000;
Nq = 6;
SNR = 40;
frame_length = 1026;
prefix_len = 400;
BWUsage = 0.5;

lt=10;

% generate the train block
train_bits = randi([0, 1], (frame_length/2 -1)*Nq, 1);
train_block = qam_mod(train_bits, 2^Nq, SNR);

train_block_l = [train_block; zeros(size(train_block))];
train_block_r = [zeros(size(train_block)); train_block];

[ofdm_stream_l, ofdm_stream_r] = ofdm_mod_stereo(train_block, train_block, lt, frame_length, 1, 1, prefix_len, []);

stereo_playback = [[ofdm_stream_l; zeros(size(ofdm_stream_r))], [zeros(size(ofdm_stream_l)); ofdm_stream_r]];

t = linspace(0, 0.1, 0.1 * fs);
sync_pulse = 0.8 * sin((5000 * t * pi + 2000) .* t);
slience_int = zeros(1, 0.1 * fs);
% play the sound!
[simin, nbsecs, fs] = initparams_stereo(stereo_playback, fs, sync_pulse, slience_int);
sim('recplay');

rx_ofdm_stream = simout.signals.values;
safe_margin = 20;
[~, rx_stream_aligned] = alignIO(rx_ofdm_stream, sync_pulse, slience_int, safe_margin, fs);

[channel_esti_l, ~] = ofdm_demod_stereo(rx_stream_aligned(1:length(ofdm_stream_l)), [], train_block, lt, frame_length, prefix_len, []);
[channel_esti_r, ~] = ofdm_demod_stereo(rx_stream_aligned(length(ofdm_stream_l)+1: length(stereo_playback)), [], train_block, lt, frame_length, prefix_len, []);

plot(10*log10(abs(channel_esti_l)), 'DisplayName','Channel_L');
hold on
plot(10*log10(abs(channel_esti_r)), 'DisplayName','Channel_R');
[a, b, H_comb] = fixed_transmitter_side_beamformer(channel_esti_l, channel_esti_r);

[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
qamStream = qam_mod(bitStream, 2^Nq, SNR);

[ofdm_stream_l, ofdm_stream_r] = ofdm_mod_stereo(qamStream, train_block, lt, frame_length, a, b, prefix_len, []);



