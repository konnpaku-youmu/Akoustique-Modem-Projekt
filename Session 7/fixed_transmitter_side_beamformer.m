function [a, b, H_k_comb] = fixed_transmitter_side_beamformer(H_1, H_2)
    H_k_comb = sqrt(H_1.*conj(H_1) + H_2.*conj(H_2));

    a = conj(H_1) ./ H_k_comb;
    a(1) = 0;
    a(length(a)/2+1) = 0;
    b = conj(H_2) ./ H_k_comb;
    b(1) = 0;
    b(length(a)/2+1) = 0;
end

