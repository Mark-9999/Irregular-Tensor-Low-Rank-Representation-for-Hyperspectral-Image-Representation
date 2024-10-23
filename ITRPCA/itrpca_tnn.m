function [L,K] = itrpca_tnn(temp,mu,p,index,rowcol,M)

% temp = K+X-E+(Y+Tr)/mu;
dim=size(temp);
L=zeros(dim);

%% obtain N
[n1,n2,n3]=size(temp);
n=min(n1,n2);
w =[];
w = [w; 1*ones(ceil(n),1)];

[N] = prox_tnn(temp,w/mu,p);

%% excute K_i and L_i
num2=size(index,1);
for m=1:num2
    pos=index(m);
    L(mod(pos-1,M)+1-rowcol(1)+1,ceil(pos/M)-rowcol(3)+1,:)=N(mod(pos-1,M)+1-rowcol(1)+1,ceil(pos/M)-rowcol(3)+1,:);
end
K=N-L;
