trainingSetNum = 20;
dataSetPath = '..\Database_PR_01\';
dirs = dir(dataSetPath);
cmp36 = tabulate_();

cmp256 = zeros(256, 1);
for i = 0:255
    cmp256(i+1, 1) = rotation_invariant(i);
end

% get feature vector of negative data
negVectors = zeros(36, trainingSetNum);
for i = 1:trainingSetNum
    path_ = strcat(dataSetPath, dirs(i+2).name);
    img = imread(path_);
    negVectors(:, i) = LBP(img, 2, cmp36, cmp256);
    disp(['negative training - ', num2str(i), ' : ', path_]);
end

% get feature vector of positive data
posVectors = zeros(36, trainingSetNum);
for i = 1:trainingSetNum
    path_ = strcat(dataSetPath, dirs(i + 2 + 1000).name);
    img = imread(path_);
    posVectors(:, i) = LBP(img, 2, cmp36, cmp256);
    disp(['positive training - ', num2str(i), ' : ', path_]);
end

% compute mi
% class 1 == negative
% class 2 == positive
% m1
m1 = zeros(36, 1);
for i = 1:trainingSetNum
    m1 = m1 + negVectors(:, i);
end
m1 = m1 ./ trainingSetNum;

% m2
m2 = zeros(36, 1);
for i = i:trainingSetNum
    m2 = m2 + posVectors(:, i);
end
m2 = m2 ./ trainingSetNum;

% compute within-class scatter matrix Si
S1 = zeros(36, 36);
S2 = zeros(36, 36);
for i = 1:trainingSetNum
    S1 = S1 + (negVectors(:, i) - m1) * ((negVectors(:, i) - m1)');
    S2 = S2 + (posVectors(:, i) - m2) * ((posVectors(:, i) - m2)');
end

% Sw
Sw = S1 + S2;

% LDA - w
w = inv(Sw) * (m1 - m2);     

% LDA - w0
w0 = (m1 + m2)' * inv(Sw) * (m1 - m2) .* (-0.5);

% classify - negative
count_neg = 0;
for i = 1:1000
    path_ = strcat(dataSetPath, dirs(i + 2).name);
    img = imread(path_);
    v = LBP(img, 2, cmp36, cmp256);
    gx = w' * v + w0;
    if gx >= 0
        count_neg = count_neg + 1;
        disp(['negative classifing - ', num2str(i), ' : ', path_, ' Right']);
    else
        disp(['negative classifing - ', num2str(i), ' : ', path_, ' Wrong']);
    end
    
end
disp(['negative accuracy : ', num2str(count_neg/1000)]);

% classify - positive
count_pos = 0;
for i = 1:1000
    path_ = strcat(dataSetPath, dirs(i + 2 + 1000).name);
    img = imread(path_);
    v = LBP(img, 2, cmp36, cmp256);
    gx = w' * v + w0;
    if gx <= 0
        count_pos = count_pos + 1;
        disp(['positive classifing - ', num2str(i), ' : ', path_, ' Right']);
    else
        disp(['positive classifing - ', num2str(i), ' : ', path_, ' Wrong']);
    end
    
end
disp(['positive accuracy : ', num2str(count_neg/1000)]);

% total accuracy
disp(['total accuracy : ', num2str((count_neg + count_pos)/2000)]);