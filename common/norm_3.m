function n = norm_3(X,m)
[M,N,B]=size(X); 
n=0;

for i = 1:B
    x = X(:,:,i);
    n = n + norm(x,m);
   
end


