function output = rotation_invariant(input)
min = input;
binaryStr = dec2bin(input, 8);
for i = 1:7
    binaryStr = circshift(binaryStr', 1)';
    t = bin2dec(binaryStr);
    if t < min
        min = t;
    end;
end;
output = min;
end