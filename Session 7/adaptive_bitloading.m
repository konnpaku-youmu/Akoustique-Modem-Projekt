function [outputArg1,outputArg2] = adaptive_bitloading(H_est, noise, fs)
    N = length(H_est);
    N_dft = fft(noise, N);
    psd_n = (1/fs*N) * (abs(N_dft).^2);
    b = floor(log2(1+((abs(H_est).^2)./(10*psd_n))));
end
