function symbol_sequence = qam_mod(sequence, M)
    symbol_sequence = qammod(sequence, M, 'InputType', 'bit', 'UnitAveragePower', true);
    symbol_sequence = awgn(symbol_sequence, 40);
    cd = comm.ConstellationDiagram('ShowReferenceConstellation', false);
    cd(symbol_sequence);
    pause();
end
