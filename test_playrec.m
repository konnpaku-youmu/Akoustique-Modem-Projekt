f = @initparams;

fs = 16000;
t = linspace(0, 2, 2 * fs);
sinewave =  0.5 * sin(2 * pi * 1000 * t);

[simin, nbsecs, fs] = initparams(sinewave, fs);

sim('recplay');
out=simout.signals.values;

t_ = linspace(0, 5, 80128);
plot(t_, out);
