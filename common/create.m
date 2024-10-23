function [L,Y,K,E]=create(Num,X)%cell(Num);
L=cell(Num);
Y=L;
K=L;
E=L;
for i=1:Num
    dim = size(X{1,i});    
    L{1,i}=zeros(dim);
    Y{1,i}=L{1,i};
    K{1,i}=L{1,i};
    E{1,i}=L{1,i};
end
    

