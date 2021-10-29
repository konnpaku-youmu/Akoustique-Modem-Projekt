f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);
K = 512;
N = 2*K;

sig = wgn(1, 2*fs, 1);

[simin, nbsecs, fs] = initparams(sig, fs);

sim('recplay');
out = simout.signals.values(129:end);

% find the pure noise part and signal part
bg_noise = out(fs/2 + 1:fs/2 + fs);
rx_sig = out(fs/2 + 2 * fs + 1:fs/2 + 3 * fs);

F_n = fft(bg_noise, N);
F_sn = fft(rx_sig, N);

P_n = (1 / fs*N)*(abs(F_n).^2);
P_sn = (1 / fs*N)*(abs(F_sn).^2);

P_s = P_sn - P_n;

s = 0;
for i=1:K
    s = s + log2(1 + (P_s(i)) / P_n(i));
end

cap_ch = (fs/N) * s;

figure("Name", "Estimate Channel Capacity");
subplot(2,1,1);
title("Time domain");
plot(bg_noise);
hold on
plot(rx_sig);
legend('bg noise', 'signal');

subplot(2,1,2);
plot(10 * log(P_n(1:K)));
hold on
plot(10 * log(P_s(1:K)));
legend('Noise PSD','Signal PSD');

display(cap_ch);

