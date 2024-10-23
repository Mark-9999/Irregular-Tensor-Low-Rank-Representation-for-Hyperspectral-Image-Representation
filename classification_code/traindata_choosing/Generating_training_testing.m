function [loc_train, loc_test, CTest] = Generating_training_testing(map,CTrain)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function: generating the location for training samples and testing samples
%% map: ground-truth map
%% CTrain: the number of training samples for each class
%% loc_train: locations for training samples
%% loc_test: locations for testing samples
%% CTest: the number of testing samples per class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loc_test = [];
loc_train = [];
CTest = [];
num_class = max(map(:));
for i=1:num_class
    tmp  = find(map==i);
    index_i = randperm(length(tmp));
    loc_train = [loc_train;tmp(index_i(1:CTrain(i)))];
    loc_test =  [loc_test;tmp(index_i(CTrain(i)+1:end))];
    CTest = [CTest length(tmp(index_i(CTrain(i)+1:end)))];
end