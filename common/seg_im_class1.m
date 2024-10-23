function [out ]= seg_im_class1(Y,Num,Results)

[M,N,B]=size(Y);

X=cell(1,Num);
%只返回同质区域所在的所有内容
for i=1:Num
    %% 获得同质介质的索引
    min_i=Results.rowcol{1,i}(1);
    max_i=Results.rowcol{1,i}(2);
    min_j=Results.rowcol{1,i}(3);
    max_j=Results.rowcol{1,i}(4);
 
    X1=zeros(max_i-min_i+1,max_j-min_j+1,B);

    %% 把一个区域的所有值放到一个单独矩阵中
    for row=min_i:max_i 
        for col=min_j:max_j
            X1(row-min_i+1,col-min_j+1,:)=Y(row,col,:);
        end
    end

    X{1,i}=X1;
end
out=X;


 