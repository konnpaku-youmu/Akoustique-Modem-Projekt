function [high_SNR_indices] = onoff_bitloading(H_est, noise, bw_usage)
    dft_length = length(H_est);
    N_dft = fft(noise, dft_length);
    P_N = abs(N_dft).^2;
    P_N = P_N(1:length(H_est));
    % find the SNR for each freq bin
    SNR = 10 * log10(abs(H_est(:, 1)).^2 ./ P_N);

    % find freq bin with high SNR
    [~, high_SNR_indices] = sort(SNR(1:dft_length/2 - 1), 'descend');
    high_SNR_indices = sort(high_SNR_indices(1:floor(bw_usage*(dft_length/2 - 1))), 'ascend');
end
