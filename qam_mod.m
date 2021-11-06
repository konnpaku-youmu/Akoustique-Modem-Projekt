function symbol_sequence = qam_mod(sequence, M)
    symbol_sequence = qammod(sequence, M, 'InputType', 'bit', 'UnitAveragePower', true);
    symbol_sequence = awgn(symbol_sequence, 60);
%     cd = comm.ConstellationDiagram('ShowReferenceConstellation', false);
%     cd(sym_seq_n);
%     pause();
end
