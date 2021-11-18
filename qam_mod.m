function symbol_sequence = qam_mod(sequence, M, snr)
    symbol_sequence = qammod(sequence, M, 'InputType', 'bit', 'UnitAveragePower', true);
    symbol_sequence = awgn(symbol_sequence, snr);
%     cd = comm.ConstellationDiagram('ShowReferenceConstellation', false);
%     cd(symbol_sequence);
%     pause();
end
