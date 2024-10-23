function Results = seg_im_class3(Y,labels)
%% 基于超像素分割的结果，对原始数据进行划分；
% 其中，rowcol是每个超像素块的在原始数据中的位置

[M,N,B]=size(Y);
Class=unique(labels);
Num=size(Class,1);
index=cell(1,Num);%得到同质区域点的坐标集合 pos = col*M+row
rowcol=cell(1,Num);%存放原坐标位置的最小值，便于将单独张量组成原张量。
X=cell(1,Num);
Z=cell(1,Num);
for i=1:Num
    %% 获得同质介质的索引
    Results.index{1,i}=find(labels==Class(i));
    %% 得到该同质介质的边界值，以便创建足够大的张量
    min_j=min(ceil(Results.index{1,i}/M));%得到坐标的最大最小值，并保存
    max_j=max(ceil(Results.index{1,i}/M));
    min_i=min(mod(Results.index{1,i}-1,M)+1);%整除的地方要注意恰好整除，结果为零
    max_i=max(mod(Results.index{1,i}-1,M)+1);
    Results.rowcol{1,i}=[min_i,max_i,min_j,max_j];
    A=zeros(max_i-min_i+1,max_j-min_j+1,B);
    X1=zeros(max_i-min_i+1,max_j-min_j+1,B);
    Z1=zeros(max_i-min_i+1,max_j-min_j+1,B);
    %% 把一个区域的所有值放到一个单独矩阵中
    for row=min_i:max_i 
        for col=min_j:max_j
            A(row-min_i+1,col-min_j+1,:)=Y(row,col,:);
        end
    end
    %% 把一个同质区域的值放到一个矩阵
    num2=size(Results.index{1,i},1);
    for m=1:num2
        pos=Results.index{1,i}(m);%同质区域点的位置 pos =row*N+col
        X1(mod(pos-1,M)+1-min_i+1,ceil(pos/M)-min_j+1,:)=Y(mod(pos-1,M)+1,ceil(pos/M),:);
    end
    Results.Z{1,i}=A-X1;
    Results.X{1,i}=X1;
end

%end

 