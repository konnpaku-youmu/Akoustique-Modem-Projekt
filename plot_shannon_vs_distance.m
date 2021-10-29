f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);
K = 512;
N = 2*K;

sig = wgn(1, 2*fs, 1);
scalar = linspace(0.02, 1, 2 * fs);
sig = sig.*scalar;

[simin, nbsecs, fs] = initparams(sig, fs);

sim('recplay');
out = simout.signals.values(257:end);

plot(out);

bg_noise = out(fs/2 + 1:fs/2 + fs);

