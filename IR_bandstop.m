f = @bandstop_noise;

t_length = 2;
fs = 16000;
t = linspace(0, t_length, t_length * fs);

white_noise = bandstop_noise(fs, t_length, 700, 3000);

f = fft(white_noise);

N = 1024;

% play and record the audio signal
[simin, nbsecs, fs] = initparams(white_noise, fs);

sim('recplay');
out = simout.signals.values(129:end);

L = 800;

col = simin(36001:37000, 1);
row = flip(simin(36001-L:36000, 1));

X = toeplitz(col, row);
Y = out(36001:37000);
h = X \ Y;

H = toeplitz(h, [h(1) zeros(1, 799)]);

IR_esti = conv(simin(:, 1), h);

subplot(2,1,1);
plot(IR_esti);
subplot(2,1,2);
stft(IR_esti, fs, "FFTLength", N, "FrequencyRange","onesided");
