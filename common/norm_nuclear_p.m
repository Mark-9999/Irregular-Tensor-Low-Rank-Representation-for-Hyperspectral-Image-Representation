function n = norm_nuclear_p(X)
[M,N,B]=size(X); 
n=0;

for i = 1:B
    x = X(:,:,i);
    if issparse(x)
        s = svds(x, min(size(x)));
        n = n + sum(s.^0.1);

    else
        s = svd(x, 'econ');
        n = n + sum(s.^0.1);
    end
end


