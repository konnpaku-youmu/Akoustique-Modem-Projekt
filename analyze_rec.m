f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);

% sig = sin(2 * pi * 440 * t);

% % For 1-2.8
sig = sin(2 * pi * 100 * t) + sin(2 * pi * 200 * t) + sin(2 * pi * 500 * t) + sin(2 * pi * 1000 * t) + sin(2 * pi * 1500 * t) + sin(2 * pi * 2000 * t) + sin(2 * pi * 4000 * t) + sin(2 * pi * 6000 * t);

white_noise = randn(1, 2*fs);

N = 1024;

% play and record the audio signal
[simin, nbsecs, fs] = initparams(sig, fs);

sim('recplay');
out = simout.signals.values;

figure(1);
% plot the spectrogram of the Tx and Rx signal
subplot(2, 2, 1);
stft(simin(:, 1), fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);
title("Spectrogram @Tx");
subplot(2, 2, 2);
stft(out, fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);
title("Spectrogram @Rx");

% calculate the PSD (Bartlette's method)
subplot(2, 2, 3);
psd_spectrogram = zeros(N / 2 + 1, (length(out) - N) / 16);
for i = 1:16:length(out)-N
    n = (ceil(i/16) + 1) / ceil(i/16);
    p_period = 1/N * periodogram(out(i:i+N), [], N, fs, "onesided", "psd");
    psd_spectrogram(:, ceil(i/16)) = (psd_spectrogram(:, ceil(i/16)) + p_period) * n;
end

psd_spectrogram = 20 * log(rescale(psd_spectrogram, 0, 1));

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

% calculate the PSD by Welch's method

% compute the PSD by its definition
figure(2);
p_out = out.^2; % w(t) = v(t)^2
stft(p_out, fs, "FFTLength", N, "FrequencyRange","onesided", 'OverlapLength', 64);

