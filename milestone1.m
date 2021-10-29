f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);

N = 1024;

sig = wgn(1, 2*fs, 1);

[simin, nbsecs, fs] = initparams(sig, fs);

sim('recplay');
out = simout.signals.values;

figure("Name", "White noise Experiment");

subplot(2, 2, 1);
stft(simin(:, 1), fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);
title("Spectrogram @Tx");
subplot(2, 2, 2);
stft(out, fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);
title("Spectrogram @Rx");

subplot(2, 2, 3);
psd_spectrogram = zeros(N / 2 + 1, (length(simin(:, 1)) - N) / 16);
for i = 1:16:length(simin(:, 1))-N
    n = (ceil(i/16) + 1) / ceil(i/16);
    p_period = 1/N * periodogram(simin(i:i+N, 1), [], N, fs, "onesided", "psd");
    psd_spectrogram(:, ceil(i/16)) = (psd_spectrogram(:, ceil(i/16)) + p_period) * n;
end

psd_spectrogram = 20 * log(psd_spectrogram);

psd_spectro_0 = imagesc(psd_spectrogram);
set(gca,'YDir','normal');
xticklabels = 0:0.5:nbsecs;
xticks = linspace(1, size(psd_spectrogram, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
yticklabels = 0:2:(fs/2)/1000;
yticks = linspace(1, size(psd_spectrogram, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
xlabel('Time (s)'); ylabel('Frequency (kHz)');
title("PSD Spectrogram @Rx");
cb = colorbar;
ylabel(cb,'Magnitude (dB)','FontSize',9,'Rotation',90);

subplot(2, 2, 4);
psd_spectrogram = zeros(N / 2 + 1, (length(out) - N) / 16);
for i = 1:16:length(out)-N
    n = (ceil(i/16) + 1) / ceil(i/16);
    p_period = 1/N * periodogram(out(i:i+N), [], N, fs, "onesided", "psd");
    psd_spectrogram(:, ceil(i/16)) = (psd_spectrogram(:, ceil(i/16)) + p_period) * n;
end

psd_spectrogram = 20 * log(psd_spectrogram);

psd_spectro = imagesc(psd_spectrogram);
set(gca,'YDir','normal');
xticklabels = 0:0.5:nbsecs;
xticks = linspace(1, size(psd_spectrogram, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
yticklabels = 0:2:(fs/2)/1000;
yticks = linspace(1, size(psd_spectrogram, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
xlabel('Time (s)'); ylabel('Frequency (kHz)');
title("PSD Spectrogram @Rx");
cb = colorbar;
ylabel(cb,'Magnitude (dB)','FontSize',9,'Rotation',90);


% Impulse response IR_1

impulse = zeros(1, 2 * fs);
impulse(1) = 1;

N = 512;

% play and record the impulse signal
[simin, nbsecs, fs] = initparams(impulse, fs);

sim('recplay');
out=simout.signals.values;

% % plot the time-domain of input & output
% subplot(2, 2, 1);
% plot(nbsecs * fs, simin(:, 1));
% subplot(2, 2, 2);
% plot(length(out), out);

% plot the spectrogram of the Tx and Rx signal
subplot(2, 2, 3);
stft(simin(:, 1), fs, "FFTLength", N, "FrequencyRange","onesided");
title("Spectrogram @Tx");
subplot(2, 2, 4);
stft(out, fs, "FFTLength", N, "FrequencyRange","onesided");
title("Spectrogram @Rx");
