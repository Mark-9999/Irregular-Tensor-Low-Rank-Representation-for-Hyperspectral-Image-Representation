function Grd_sub1 =cal_subgradient_nuclear(A)

eigThd = 0.005; 
% eigThd = 0.000005; 
[m, n]=size(A);
[U, Sigma, V] = svd(A, 'econ');
Obj_sub1 = sum(diag(Sigma));
F_rank=min([m,n]);        
r = sum(diag(Sigma)<=eigThd); 
        if r==0
            r=r+1;
        end
        if F_rank-r==0
            r=r-1;
        end
RndMat = orth(rand(r, r))*diag(rand(r, 1))*orth(rand(r, r))';
U1 = U(:, 1:end-r);
V1 = V(:, 1:end-r);
U2 = U(:, end-r+1:end); 
V2 = V(:, end-r+1:end); 
W = U2*RndMat*V2';
UU=U1*V1';
Grd_sub1 = (UU + W);