clc;clear;close all
addpath('.\libsvm-3.21\matlab');
addpath(genpath(cd));

%% Initialization of common parameters
opts.mu = 1e-10;
opts.tol = 1e-3;
opts.rho = 1.1;
opts.max_iter = 500;
opts.max_mu =  1e10;
opts.DEBUG = 1;

img_name         =   'PaviaU';


%% load the data and initial the parameters for the special dataset
if strcmp(img_name,'Indian')
    load Indian_pines_corrected;
    load Indian_pines_gt;
    data3D = indian_pines_corrected;         
    label_gt = indian_pines_gt;
    num_pixel = 30;
    sigma = 10/100; % the percentage of train sample
    p = 0.1;
    lambda = 1e-7;
    beta = 1e-5;
elseif strcmp(img_name,'Salinas')
    load Salinas_corrected;
    load Salinas_gt;
    data3D = salinas_corrected; 
    label_gt = salinas_gt;
    num_pixel = 20;
    sigma = 1/100;
    p = 0.1;
    lambda = 1e-6;
    beta = 1e-2;
elseif strcmp(img_name,'PaviaU')    
    load PaviaU;
    load PaviaU_gt;
    data3D = paviaU;        
    label_gt = paviaU_gt;
    num_pixel = 10;
    sigma = 0.5/100;
    p = 0.1;
    lambda = 5e-6;
    beta = 1e-6;    
elseif strcmp(img_name,'LongKou')    
    load LongKou; 
    load LongKou_gt;
    data3D = LongKou; 
    label_gt = LongKou_gt;
    num_pixel = 10;
    sigma = 1/100;
    p = 0.7;
    lambda = 5e-4;
    beta = 1e-5;
end


%% segmentation superpixel
[labels,idx] = cubseg(data3D,num_pixel);
imagesc(labels);

%% Applying our model to the original data
tic 
t1=toc;

[dataDR] = ITRPCA(lambda,beta,data3D,labels,opts,p);

t2=toc;
t=t2-t1;


%% Compute the metrics
if strcmp(img_name, 'Indian')
    CTrain = [46 1428 830 237 483 730 28 478 20 972 2455 593 205 1265 386 93];
    CTrain = ceil(CTrain.*sigma);
end
if strcmp(img_name, 'Salinas')
    CTrain = [2009 3726 1976 1394 2678 3959 3579 11271 6203 3278 1068 1927 916 1070 7268 1807];%10%
    CTrain = ceil(CTrain.*sigma);
end
if strcmp(img_name, 'PaviaU')
    CTrain = [6631 18649 2099 3064 1345 5029 1330 3682 947];
    CTrain = ceil(CTrain.*sigma); 
end
if strcmp(img_name, 'LongKou')
    CTrain = [1411 3568 1229 5832 1338 672 20610 2453 1450];
    CTrain = ceil(CTrain.*sigma); 
end

% predict_map is the classification map
[predict_map,OA_SVM1, OA_SVM2, AA_SVM1, AA_SVM2, ave_Kappa_SVM1, ave_Kappa_SVM2] =Classification_V2(dataDR,dataDR./(max(dataDR(:))),label_gt,20,CTrain);

disp(['Model runs consume ',num2str(t), 's']);

Save the low rank data
folder ='.\result';
filename= [img_name,'-pixel-', num2str(num_pixel),'-p-', num2str(p),'-¦Ë-',num2str(lambda),'-¦Â-',num2str(beta),'.mat'];

parsave(folder,filename,dataDR);


