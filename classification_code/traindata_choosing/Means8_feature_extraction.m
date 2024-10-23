function Feature_P = Means8_feature_extraction(DataTest, W, map)
% Mean feature extraction
% DataTest: mxnxD, W: Window size (even), Feature_P: mxnxD1
% P: number of PCs
%

if W==1
    Feature_P = DataTest;
else
    
DataTest = double(DataTest);
[m n D] = size(DataTest);  % D : 1~3


% padding avoid edges
DataTest_n = zeros(m+100, n+100, D);
DataTest_n(50+1:m+50, 50+1:n+50, :) = DataTest;
DataTest_n(50+1:m+50, 1:50, :) = DataTest(:, 50:-1:1, :);   %
DataTest_n(50+1:m+50, n+51:n+100, :) = DataTest(:, n:-1:n-49, :);
DataTest_n(1:50, :, :) = DataTest_n(100:-1:51, :, :);
DataTest_n(m+51:m+100, :, :) = DataTest_n(m+50:-1:(m+1), :, :);


% show DWT features
X = DataTest_n(:, :, 1:D);
Feature_P = zeros(m, n, D);
for i = 50+1: m+50
   for j = 50+1: n+50 
       if map(i-50, j-50)>0
          Y = X(i-fix(W/2):i+fix(W/2), j-fix(W/2):j+fix(W/2), :);  
          [t1 t2 t3] = size(Y);
          Yt = reshape(Y, t1*t2, t3);
          Feature_P(i-50, j-50, :) = mean(Yt);
       end
   end
end

end