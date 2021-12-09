function visualize_demod(fs, Nq, ld, frame_len, rx_stream, H_est, image_size, bits_per_pixel, color_map, original_img)
    subplot(2,2,2); colormap(color_map); image(original_img); axis image; title('Original Image'); drawnow;
    transmit_time = length(rx_stream) / fs;
    
    frame_len_half = (frame_len - 2) / 2;
    bits_per_frame = Nq * frame_len_half;
    num_packets = length(rx_stream) / (bits_per_frame * ld);

    refresh_period = transmit_time / ld;
    idx = 1;
    for i=0:refresh_period:transmit_time
        endbit = 1;
        if i ~= 0
            endbit = i*fs;
        elseif i==transmit_time 
            endbit = length(rx_stream);
        end
        rx_image = bitstreamtoimage(rx_stream(1:endbit), image_size, bits_per_pixel);
        subplot(2,2,4); colormap(color_map); image(rx_image); axis image; title(sprintf('Rx image after %1.2fs', i)); drawnow;
        
        h = ifft(H_est(:, idx));
        H_mag = 10*log10(abs(H_est(:,idx)));
        subplot(2,2,1); plot(h);
        subplot(2,2,3); plot(H_mag);

        idx = idx + 1;
        pause(refresh_period);
    end
end