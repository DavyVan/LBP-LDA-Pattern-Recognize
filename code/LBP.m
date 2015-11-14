function x = LBP(input, outputType, cmp36, cmp256)
neighbors = [
    -1 -1; -1 0; -1 1;
     0 -1;        0 1;
     1 -1;  1 0;  1 1;
     ];

if size(input, 3) == 3
    input = rgb2gray(input);
end
input = input(:,:,1);
intermedia = zeros(256);

row_max = size(input,1)-1;
col_max = size(input,2)-1;

% LBP core
for i = 2:row_max
    for j = 2:col_max
        center = input(i, j);
        sum_ = 0;
        for k = 7:-1:0
            sum_ = sum_ + logic(input(i + neighbors(8-k, 1), j + neighbors(8-k, 2)) - center) * (2^k);
        end
        intermedia(i, j) = cmp256(sum_+1, 1);
    end
end

if outputType == 1
    x = intermedia;
end
if outputType == 2
     
     %histogram
     output_ = zeros(1, 256);
     for i = 2:row_max
         for j = 2:col_max
             index = intermedia(i,j) + 1;
             output_(1, index) = output_(1, index) + 1;
         end
     end
     
     %compress to 36 dim
     output = zeros(36, 1);
     i = 1;
     for j = 1:256
         if j == cmp36(i, 1) + 1
             output(i, 1) = output_(1, j);
             i = i + 1;
         end
     end
     x = output;
end 
end    %end of function



