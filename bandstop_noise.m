function signal =bandstop_noise(fs, length, low_cutoff, high_cutoff)

f_nq = fs / 2;

bsf = fir1(256,[low_cutoff/f_nq, high_cutoff/f_nq], 'stop');
sig = wgn(1, length*fs, 1);

signal = conv(sig, bsf);

end