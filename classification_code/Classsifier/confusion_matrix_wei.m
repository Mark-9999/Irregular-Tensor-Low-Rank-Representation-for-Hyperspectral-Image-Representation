function [accuracy, TPR, Kappa] = confusion_matrix_wei(class, c)
%
% class is the result of test data after classification
%          (1 x n)
%
% c is the label for testing data
%          (1 x len_c)
%
%
%function [confusion, accuracy, TPR, FPR,Kappa] = confusion_matrix_wei(class, c)
class = class.';
c = c.';

n = length(class);
Row= length(class);
c_len = length(c);

if n ~= sum(c)
    disp('WRANING:  wrong inputting!');
    return;
end


% confusion matrix
confusion = zeros(c_len, c_len);
a = 0;
for i = 1: c_len
    for j = (a + 1): (a + c(i))
        confusion(i, class(j)) = confusion(i, class(j)) + 1;
    end
    a = a + c(i);
end


% True_positive_rate + False_positive_rate + accuracy
TPR = zeros(1, c_len);
FPR = zeros(1, c_len);
for i = 1: c_len
  FPR(i) = confusion(i, i)/sum(confusion(:, i));
  TPR(i) = confusion(i, i)/sum(confusion(i, :));
end
accuracy = sum(diag(confusion))/sum(c);


RowSum=zeros(c_len,1);
ColSum=zeros(1,c_len);
for i=1:c_len
    for j=1:c_len
         RowSum(i,1)=RowSum(i,1)+confusion(i,j);
         ColSum(1,j)=ColSum(1,j)+confusion(i,j);
    end
end
temp1=0;
temp2=0;
for i=1:c_len
    temp1=temp1+confusion(i,i);
    temp2=temp2+RowSum(i,1)*ColSum(1,i);
end

Kappa=(Row*temp1-temp2)/(Row*Row-temp2);
