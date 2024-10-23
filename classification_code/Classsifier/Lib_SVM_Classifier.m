function [output1,output2] = Lib_SVM_Classifier(DataTrain, CTrain, DataTest, sigma)

LabelTrain = []; 
for jj = 1: length(CTrain)
   LabelTrain = [LabelTrain; jj * ones(CTrain(jj),1)];
end


% Probability SVM
    options = (['-c 10000 -g ' num2str(sigma) ' -b 1']);
    model = svmtrain(LabelTrain,DataTrain,options);
    TestLabel = ones(size(DataTest, 1), 1);
    TrainLabel = ones(size(DataTrain, 1), 1);
    [class0,accuracy0,prob_estimates] = svmpredict(TestLabel,DataTest,model);
    [class1,accuracy0,prob_estimates] = svmpredict(TrainLabel,DataTrain,model);
    output1 = class0;
    output2 = class1;
