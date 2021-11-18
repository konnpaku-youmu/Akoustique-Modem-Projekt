f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);
N = 1024;

sig = wgn(1, 2*fs, 1);

[simin, nbsecs, fs] = initparams(sig, fs);

sim('recplay');
white_noise_out = simout.signals.values(128:end);

% figure("Name", "White noise Experiment");
% 
% subplot(2, 2, 1);
% stft(simin(:, 1), fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);
% title("Spectrogram @Tx");
% subplot(2, 2, 2);
% stft(white_noise_out, fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);
% title("Spectrogram @Rx");
% 
% subplot(2, 2, 3);
% psd_spectrogram = zeros(N / 2 + 1, (length(simin(:, 1)) - N) / 16);
% for i = 1:16:length(simin(:, 1))-N
%     n = (ceil(i/16) + 1) / ceil(i/16);
%     p_period = periodogram(simin(i:i+N, 1), [], N, fs, "onesided", "psd");
%     psd_spectrogram(:, ceil(i/16)) = (psd_spectrogram(:, ceil(i/16)) + p_period) * n;
% end
% 
% psd_spectrogram = (1/fs*N) * psd_spectrogram;
% psd_spectrogram = 10 * log(psd_spectrogram);
% 
% psd_spectro_0 = imagesc(psd_spectrogram);
% set(gca,'YDir','normal');
% xticklabels = 0:0.5:nbsecs;
% xticks = linspace(1, size(psd_spectrogram, 2), numel(xticklabels));
% set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
% yticklabels = 0:2:(fs/2)/1000;
% yticks = linspace(1, size(psd_spectrogram, 1), numel(yticklabels));
% set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
% xlabel('Time (s)'); ylabel('Frequency (kHz)');
% title("PSD Spectrogram @Tx");
% cb = colorbar;
% ylabel(cb,'Magnitude (dB)','FontSize',9,'Rotation',90);
% 
% subplot(2, 2, 4);
% psd_spectrogram = zeros(N / 2 + 1, ceil((length(white_noise_out) - N) / 64));
% for i = 1:64:length(white_noise_out)-N
%     n = (ceil(i/64) + 1) / ceil(i/64);
%     p_period = periodogram(white_noise_out(i:i+N), [], N, fs, "onesided", "psd");
%     psd_spectrogram(:, ceil(i/64)) = (psd_spectrogram(:, ceil(i/64)) + p_period) * n;
% end
% 
% psd_spectrogram = (1/fs*N) * psd_spectrogram;
% psd_spectrogram = 10 * log(psd_spectrogram);
% 
% psd_spectro = imagesc(psd_spectrogram);
% set(gca,'YDir','normal');
% xticklabels = 0:0.5:nbsecs;
% xticks = linspace(1, size(psd_spectrogram, 2), numel(xticklabels));
% set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
% yticklabels = 0:2:(fs/2)/1000;
% yticks = linspace(1, size(psd_spectrogram, 1), numel(yticklabels));
% set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
% xlabel('Time (s)'); ylabel('Frequency (kHz)');
% title("PSD Spectrogram @Rx");
% cb = colorbar;
% ylabel(cb,'Magnitude (dB)','FontSize',9,'Rotation',90);

% Exercise 2-2: Estimate channel response

L = 800;

col = simin(36001:37000, 1);
row = flip(simin(36001-L:36000, 1));

X = toeplitz(col, row);
Y = white_noise_out(36001:37000);
% h = X \ Y;
h = lsqr(X, Y);

H = toeplitz(h, [h(1) zeros(1, 799)]);

IR_esti = conv(simin(:, 1), h);

figure("Name", "IR Estimation");
subplot(2,1,1);
plot(IR_esti);
subplot(2,1,2);
stft(IR_esti, fs, "FFTLength", N, "FrequencyRange","onesided");
title("Estimated response using $\alpha$");
% 
% % Exercise 2-1: Impulse response
% impulse = zeros(1, 2 * fs);
% impulse(1) = 1;
% 
% % play and record the impulse signal
% [simin, ~, fs] = initparams(impulse, fs);
% 
% sim('recplay');
% out=simout.signals.values(129:end);
% 
% figure("Name", "IR Experiment");
% 
% % plot the time-domain of input & output
% subplot(2, 1, 1);
% plot(out);
% xlabel("Samples");
% ylabel("Amplitude");
% 
% % plot the spectrogram of the Tx and Rx signal
% subplot(2, 1, 2);
% stft(out, fs, "FFTLength", N, "FrequencyRange","onesided");
% title("Spectrogram @Rx");
