function [accuracy,Kappa,TPR] = Excute_SVMCK(Data, loc_train, CTrain, loc_test, CTest, W, map)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function: classification using SVM classifier
%% Data: the hyperspectral image data in three-dimensional form, 
%%          Data_R(m,n,b), (m,n)-the number of samples, b-the number of band
%% CTrain: the number of training samples for each class
%% loc_train: locations for training samples
%% loc_test: locations for testing samples
%% CTest: the number of testing samples per class
%% W: the size of window in SVM-CK, WxW
%% map: ground-truth map
%% accuracy: the average classification accuracy
%% Kappa: Kappa coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n,d] = size(Data);
Feature_P = Means8_feature_extraction(Data, W, map); 
Data_R = reshape(Feature_P, m*n, d);    %把数据 M*n行 d列
Data_R = Data_R./max(Data_R(:)); 
DataTrain = Data_R(loc_train, :);
DataTest = Data_R(loc_test, :);
class = Lib_SVM_Classifier(DataTrain, CTrain, DataTest, 1.0);
[accuracy, TPR, Kappa] = confusion_matrix_wei(class, CTest);