f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);

impulse = zeros(1, 2 * fs);
impulse(1) = 1;

% play and record the impulse signal
[simin, nbsecs, fs] = initparams(impulse, fs);

sim('recplay');
out=simout.signals.values(129:end);

figure("Name", "IR Experiment");

% plot the time-domain of input & output
subplot(2, 2, 1);
plot(simin(:, 1));
xlabel("Samples");
ylabel("Amplitude");
subplot(2, 2, 2);
plot(out);
xlabel("Samples");
ylabel("Amplitude");

% plot the spectrogram of the Tx and Rx signal
subplot(2, 2, 3);
stft(simin(:, 1), fs, "FFTLength", N, "FrequencyRange","onesided");
title("Spectrogram @Tx");
subplot(2, 2, 4);
stft(out, fs, "FFTLength", N, "FrequencyRange","onesided");
title("Spectrogram @Rx");