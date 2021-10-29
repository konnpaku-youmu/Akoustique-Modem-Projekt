function seq = random_binary(length)
    seq = rand(1, length, 1);
    seq = round(seq);
end