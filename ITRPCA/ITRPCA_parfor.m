function [L0] = ITRPCA_parfor(lambda,beta,data3D,labels,opts,p)%,objt
% labels 是被分割后的二维的图像，其中相同数字表示同质区域
% opts.mu = 1e-4;
% opts.tol = 1e-5 ;%改小了，原来�? -5
% opts.rho = 1.1;
opts.max_iter = 500;
% opts.DEBUG = 1;
%% 初始量赋�?
if ~exist('opts', 'var')
    opts = [];
end    
if isfield(opts, 'tol');         tol = opts.tol;              end
if isfield(opts, 'max_iter');    max_iter = opts.max_iter;    end
if isfield(opts, 'rho');         rho = opts.rho;              end
if isfield(opts, 'mu');          mu = opts.mu;                end
if isfield(opts, 'max_mu');      max_mu = opts.max_mu;        end
if isfield(opts, 'DEBUG');       DEBUG = opts.DEBUG;          end
% if isfield(opts, 'lambda');       lambda = opts.lambda;          end

%% 得到分成小块的同质介�?
% lambda=0.01;
[M,N,B]=size(data3D); 
Results= seg_im_class3(data3D,labels);
%% 对小块矩阵进行trpca
Num=size(Results.index,2);
% obj=zeros(1,Num);
L0=zeros(M,N,B);%0是整�?

E0=L0;
[L,Y,K,E]=create(Num,Results.X);%cell(Num);


for iter = 1 : max_iter
    L0k = L0;
    E0k = E0;

    
    %% 求解线�?�化相关�?
     Lvector=reshape(L0,M*N,B);
     Grd_sub =cal_subgradient_nuclear(Lvector);
     T=reshape(Grd_sub,M,N,B);
     Tr= seg_im_class1(T,Num,Results);%返回同质区域及附近的
     
     %% 引入新因子求�?
     for i=1:Num
         temp=K{1,i}+Results.X{1,i}-E{1,i}+(Y{1,i}+Tr{1,i}*beta)/mu;               
        [L{1,i},K{1,i}] = IMtrpca_tnn(temp,mu,Results.index{1,i},Results.rowcol{1,i},M);

     end
          %% 将分�?的张量，组成原张�?,obj(i),E{1,i}Results.X{1,i},
     for i=1:Num 
        num2=size(Results.index{1,i},1); 
        for m=1:num2
            pos=Results.index{1,i}(m);%同质区域点的位置 pos =row*N+col
            L0(mod(pos-1,M)+1,ceil(pos/M),:)=L{1,i}(mod(pos-1,M)+1-Results.rowcol{1,i}(1)+1,ceil(pos/M)-Results.rowcol{1,i}(3)+1,:);
        end
     end

    %% E的求�?
    chgY=0;
    for i=1:Num
        [n1,n2,n3] = size(Results.X{1,i});
        E{1,i} = prox_l1(-L{1,i}+Results.X{1,i}-Y{1,i}/mu,lambda/sqrt(max(n1,n2)*n3)/mu);
        dY0=E{1,i}+L{1,i}-Results.X{1,i};%分别求E
        Y{1,i}=Y{1,i}+ mu*dY0;
        if chgY<max(abs(dY0(:)))
            chgY=max(abs(dY0(:)));
        end
    end
    
    %收敛性判�?
    chgL = max(abs(L0k(:)-L0(:)));
    chgS = max(abs(E0k(:)-E0(:)));
    chg = max([ chgL chgS chgY ]);
    if DEBUG
        if iter == 1 || mod(iter, 10) == 0
%             obj = tnnL+lambda*norm(E(:),1);
%             err = norm(dY0(:));
            disp(['iter ' num2str(iter) ' err '  num2str(chg)]); 
        end
    end
    %% 判断是否符合条件', mu=' num2str(mu) ...
%                     ', obj=' num2str(obj) ', err=' num2str(err)
    if chg < tol
        break;
    end 
%     Y0 = Y0 + mu*dY0;
    mu = min(rho*mu,max_mu);  
   
end

