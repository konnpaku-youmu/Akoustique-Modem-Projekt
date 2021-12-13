clear;
load("Channel.mat");

Nq = 6;

len = 1000;

H_k = fft(h, len);

bitstream = randi([0, 1], len*Nq, 1);
X_k = qam_mod(bitstream, 2^Nq, 30);

Y_k = H_k.*X_k;

W_k = zeros(len, 1);
W_k(1) = 1/conj(H_k(1)) + 0.005;

mu_bar = 2;
alpha = 0.001;

X_k_fil = zeros(len, 1);
X_k_est = zeros(len, 1);
for i=2:len
    X_k_fil(i) = conj(W_k(i-1))*Y_k(i);
    d_k = qammod(qamdemod(X_k_fil(i), 2^Nq), 2^Nq);
    W_k(i) = W_k(i-1) + mu_bar/(alpha + conj(Y_k(i))*Y_k(i)) * Y_k(i) * conj(d_k - conj(W_k(i-1))*Y_k(i));
end

subplot(211);
plot(10*log10(abs(W_k)));
hold on
plot(10*log10(abs(H_k)));
subplot(212);

H_inv = zeros(len, 1);
for i=1:len
    H_inv(i) = 1.0/conj(H_k(i));
end

plot(abs(W_k - 1./conj(H_k)));
