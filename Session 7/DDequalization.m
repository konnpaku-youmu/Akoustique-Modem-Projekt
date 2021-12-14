clear;
load("Channel.mat");

Nq = 6;

len = 1000;

H_k = fft(h, len);

bitstream = randi([0, 1], len*Nq, 1);
X_k = qam_mod(bitstream, 2^Nq, 30);

Y_k = H_k.*X_k;

W_k = zeros(len, 1);
W_k(1) = 1/conj(H_k(1)) + 0.5;

mu_bar = 1.5;
alpha = 1e-4;

for i=2:len
    uk_wk_1 = conj(W_k(i-1))*Y_k(i);
    d_k = qammod(qamdemod(uk_wk_1, 2^Nq), 2^Nq);
    W_k(i) = W_k(i-1) + mu_bar/(alpha + conj(Y_k(i))*Y_k(i)) * Y_k(i) * conj(d_k - uk_wk_1);
end

subplot(211);
plot(10*log10(abs(1./W_k)));
hold on
plot(10*log10(abs(H_k)));
subplot(212);
plot(abs(W_k) - 1./abs(conj(H_k)));
