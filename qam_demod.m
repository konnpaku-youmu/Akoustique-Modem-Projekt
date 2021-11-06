function bitstream=qam_demod(symbol_seq, M)
    bitstream = qamdemod(symbol_seq, M, 'OutputType', 'bit', 'UnitAveragePower', true);
end