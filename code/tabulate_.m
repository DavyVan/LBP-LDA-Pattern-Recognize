% generate cmp36, called by main
function cmp = tabulate_()
    a = zeros(1, 256);
    for i = 0:255
        a(1, i+1) = rotation_invariant(i);
    end
    cmp = tabulate(a);
    cmp = cmp(:, 1);
end