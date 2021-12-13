function biterr = ber(seq_ref, seq_test)
    diff = bitxor(seq_ref, seq_test);
    errnum = sum(diff);
    biterr = errnum / length(seq_ref);
end