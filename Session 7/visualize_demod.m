function visualize_demod(fs, transmit_time, Nq, ld, frame_len, rx_stream, H_est, image_size, bits_per_pixel, color_map, original_img, high_gain_idx)
    subplot(2,2,2); colormap(color_map); image(original_img); axis image; title('Original Image'); drawnow;
    
    frame_len_half = (frame_len - 2) / 2;
    bits_per_frame = Nq * frame_len_half;
    num_packets = length(rx_stream) / (bits_per_frame * ld);

    refresh_period = transmit_time / num_packets;

    for i=1:num_packets
        H_a = H_est(:, i);
        H_i = H_est(:, i);
        h = ifft(H_i);
        % set inactive freq to 0
        inactive_freq = setdiff(linspace(1, frame_len_half, frame_len_half), high_gain_idx);
        H_a(inactive_freq) = 0;
        H_i(high_gain_idx) = 0;
        H_mag_a = 10*log10(abs(H_a));
        H_mag_i = 10*log10(abs(H_i));
        
        subplot(2,2,1); plot(h); ylim([-1.5, 1.5]); xlim([0 frame_len]);
        xlabel("Time (s)"); ylabel("Amplitude");
        xticklabels = 0:0.01:frame_len/fs;
        xticks = linspace(1, frame_len, numel(xticklabels));
        set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
        title("Estimated Channel IR: Time Domain");
        
        subplot(2,2,3); plot(H_mag_a(1:frame_len_half)); hold on; plot(H_mag_i(1:frame_len_half)); hold off; ylim([-40, 20]); xlim([0 frame_len_half]);
        xlabel("Frequency (Hz)"); ylabel("Magnitude (dB)");
        xticklabels = 0:2000:fs/2;
        xticks = linspace(1, frame_len_half, numel(xticklabels));
        set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
        title("Estimated Channel IR: Frequency Domain");

        endbit = i*bits_per_frame*ld;
        rx_image = bitstreamtoimage(rx_stream(1:endbit), image_size, bits_per_pixel);
        subplot(2,2,4); colormap(color_map); image(rx_image); axis image; title(sprintf('Rx image after %1.2fs', i*refresh_period)); drawnow;

        pause(refresh_period);
    end
end