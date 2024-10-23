function [L0] = ITRPCA(lambda,beta,data3D,labels,opts,p)%,objt


if ~exist('opts', 'var')
    opts = [];
end    
if isfield(opts, 'tol');         tol = opts.tol;              end
if isfield(opts, 'max_iter');    max_iter = opts.max_iter;    end
if isfield(opts, 'rho');         rho = opts.rho;              end
if isfield(opts, 'mu');          mu = opts.mu;                end
if isfield(opts, 'max_mu');      max_mu = opts.max_mu;        end
if isfield(opts, 'DEBUG');       DEBUG = opts.DEBUG;          end


[M,N,B]=size(data3D); 
Results= seg_im_class3(data3D,labels);


Num=size(Results.index,2);

L0=zeros(M,N,B);
E0=L0;
[L,Y,K,E]=create(Num,Results.X); %% the K present L^c,L presents L^o


for iter = 1 : max_iter
    L0k = L0;
    E0k = E0;
    
    %% initial the L before performing linearization
    for i=1:Num
        temp=K{1,i}+Results.X{1,i}-E{1,i}+(Y{1,i})/mu;               
        [L{1,i},K{1,i}] = itrpca_tnn(temp,mu,p,Results.index{1,i},Results.rowcol{1,i},M);
        num2=size(Results.index{1,i},1); 
        %% excute L
        for m=1:num2
            pos=Results.index{1,i}(m);
            L0(mod(pos-1,M)+1,ceil(pos/M),:)=L{1,i}(mod(pos-1,M)+1-Results.rowcol{1,i}(1)+1,ceil(pos/M)-Results.rowcol{1,i}(3)+1,:);
        end
    end
    
    %% performing linearization
    Lvector=reshape(L0,M*N,B);
    Grd_sub =cal_subgradient_nuclear(Lvector);
    T=reshape(Grd_sub,M,N,B);
    Tr= seg_im_class1(T,Num,Results);

    %% Update L
    for i=1:Num
        temp=K{1,i}+Results.X{1,i}-E{1,i}+(Y{1,i}+Tr{1,i}*beta)/mu;               
        [L{1,i},K{1,i}] = itrpca_tnn(temp,mu,p,Results.index{1,i},Results.rowcol{1,i},M);
        num2=size(Results.index{1,i},1); 
        for m=1:num2
            pos=Results.index{1,i}(m);
            L0(mod(pos-1,M)+1,ceil(pos/M),:)=L{1,i}(mod(pos-1,M)+1-Results.rowcol{1,i}(1)+1,ceil(pos/M)-Results.rowcol{1,i}(3)+1,:);
        end
    end

    %% Update S and the converge conditions
    chgY=0;
    chgE=0;
    for i=1:Num
        [n1,n2,n3] = size(Results.X{1,i});
        Ei0=E{1,i};
        E{1,i} = prox_l1(-L{1,i}+Results.X{1,i}+Y{1,i}/mu,lambda/sqrt(max(n1,n2)*n3)/mu);
        dY0=Results.X{1,i}-E{1,i}-L{1,i};
        
        Y{1,i}=Y{1,i}+ mu*dY0;
        if chgY<max(abs(dY0(:)))
            chgY=max(abs(dY0(:)));
        end

        dE0 = Ei0-E{1,i};
        
        if chgE<max(abs(dE0(:)))
            chgE=max(abs(dE0(:)));
        end
    end
    

    chgL = max(abs(L0k(:)-L0(:)));
    chg = max([ chgL chgE chgY ]);
    
    if DEBUG
        if iter == 1 || mod(iter, 10) == 0
           disp(['iter ' num2str(iter) ' err '  num2str(chg)]); 
        end
    end
  
    
    if chg < tol
        break;
    end 

    mu = min(rho*mu,max_mu);  
   
end



