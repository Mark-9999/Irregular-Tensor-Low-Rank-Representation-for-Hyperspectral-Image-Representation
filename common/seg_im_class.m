function [out ]= seg_im_class(Y,Num,Results)

[M,N,B]=size(Y);

X=cell(1,Num);
%只返回同质区域的内容
for i=1:Num
    %% 获得同质介质的索引
    min_i=Results.rowcol{1,i}(1);
    max_i=Results.rowcol{1,i}(2);
    min_j=Results.rowcol{1,i}(3);
    max_j=Results.rowcol{1,i}(4);
 
    X1=zeros(max_i-min_i+1,max_j-min_j+1,B);

    %% 把一个同质区域的值放到一个矩阵
    num2=size(Results.index{1,i},1);
    for m=1:num2
        pos=Results.index{1,i}(m);%同质区域点的位置 pos =row*N+col
        X1(mod(pos-1,M)+1-min_i+1,ceil(pos/M)-min_j+1,:)=Y(mod(pos-1,M)+1,ceil(pos/M),:);
    end

    X{1,i}=X1;
end
out=X;


 