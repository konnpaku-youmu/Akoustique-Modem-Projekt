f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);

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
