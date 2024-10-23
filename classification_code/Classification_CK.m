function [OA_SVMCK1, OA_SVMCK2, AA_SVMCK1, AA_SVMCK2] ...
    = Classification_CK(org_data,re_data,GT_map,iter,CTrain)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function: compare the classification performance on org_data and re_data using SVM and SVM_CK classifier
%% Input:
     %% org_data: original hyperspectral image
    %% re_data: processed hyperspectral image
    %% GT_map: classification Ground-truth map
    %% iter: randomly run 'iter' times
%% Output:
    %% OA_SVM1: average Overall accuracy by SVM classifier on org_data;
    %% OA_SVM2 average Overall accuracy by SVM classifier on re_data;
    %% AA_SVM1: average Average accuracy by SVM classifier on org_data;
    %% AA_SVM2 average Average accuracy by SVM classifier on re_data;
    %% ave_Kappa_SVM1: average Kappa coefficient by SVM classifier on org_data;
    %% ave_Kappa_SVM2 average Kappa coefficient by SVM classifier on re_data;
    %% ave_TPR_SVM1: average accuracy of every class by SVM classifier on org_data;
    %% ave_TPR_SVM2 average accuracy of every class by SVM classifier on re_data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m n d] = size(org_data);
Data_R1 = reshape(org_data,m*n,d);
Data_R2 = reshape(re_data,m*n,d);
%% 训练集的10%取样
% CTrain = [6 144 84 24 50 75 3 49 2 97 247 62 22 130 38 10]; %CTrain=[23 89 73 66 71 81 14 71 10 76 112 68 67 89 68 47];%% for indian pines dataset
% CTrain = 50*ones(1,9); % for Pavin
% CTrain = [68 67 67 67 67 68 68 70 69 67 67 67 68 67 68 68]; % for Salinas
%% 初始化多次测试（20次）的结果统计数组
accracy_SVM1 = [];
accracy_SVM2 = [];
accracy_SVMCK1 = [];
accracy_SVMCK2 = [];
Kappa_SVM1 = [];
Kappa_SVM2 = [];
Kappa_SVMCK1 = [];
Kappa_SVMCK2 = [];
TPR_SVM1 = [];
TPR_SVM2 = [];
TPR_SVMCK1 = [];
TPR_SVMCK2 = [];

%% 重复测试
for i=1:iter
    %% 训练集的样本位置及测试集样本位置
    [loc_train, loc_test, CTest] = Generating_training_testing(GT_map,CTrain);
    
    %% SVM
    [accur11, Kappa11,TPR11] = Excute_SVM(Data_R1, loc_train, CTrain, loc_test, CTest);
    accracy_SVM1 = [accracy_SVM1 accur11];
    TPR_SVM1 = [TPR_SVM1;TPR11];
    Kappa_SVM1 = [Kappa_SVM1 Kappa11];
    
    [accur12, Kappa12,TPR12] = Excute_SVM(Data_R2, loc_train, CTrain, loc_test, CTest);
    accracy_SVM2 = [accracy_SVM2 accur12];
    TPR_SVM2 = [TPR_SVM2;TPR12];
    Kappa_SVM2 = [Kappa_SVM2 Kappa12];
    
    %% SVMCK
    [accur21, Kappa21,TPR21]  = Excute_SVMCK(org_data, loc_train, CTrain, loc_test, CTest, 5, GT_map);
    accracy_SVMCK1 = [accracy_SVMCK1 accur21];
    TPR_SVMCK1 = [TPR_SVMCK1;TPR21];
    Kappa_SVMCK1 = [Kappa_SVMCK1 Kappa21];
    
    [accur22, Kappa22,TPR22]  = Excute_SVMCK(re_data, loc_train, CTrain, loc_test, CTest, 5, GT_map);
    accracy_SVMCK2 = [accracy_SVMCK2 accur22];
    TPR_SVMCK2 = [TPR_SVMCK2;TPR22];
    Kappa_SVMCK2 = [Kappa_SVMCK2 Kappa22];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 20次五组平均结果统计
% OA_SVM1=mean(accracy_SVM1);
% OA_SVM2=mean(accracy_SVM2);
% ave_Kappa_SVM1=mean(Kappa_SVM1);
% ave_Kappa_SVM2=mean(Kappa_SVM2);
% ave_TPR_SVM1=mean(TPR_SVM1);
% ave_TPR_SVM2=mean(TPR_SVM2);
% AA_SVM1 = mean(ave_TPR_SVM1);
% AA_SVM2 = mean(ave_TPR_SVM2);
OA_SVMCK1=mean(accracy_SVMCK1);
ave_Kappa_SVMCK1=mean(Kappa_SVMCK1);
ave_TPR_SVMCK1=mean(TPR_SVMCK1);
OA_SVMCK2=mean(accracy_SVMCK2);
ave_Kappa_SVMCK2=mean(Kappa_SVMCK2);
ave_TPR_SVMCK2=mean(TPR_SVMCK2);
AA_SVMCK1 = mean(ave_TPR_SVMCK1);
AA_SVMCK2 = mean(ave_TPR_SVMCK2);