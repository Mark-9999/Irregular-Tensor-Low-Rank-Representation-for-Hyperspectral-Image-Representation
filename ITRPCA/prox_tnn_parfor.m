function [X, tnn, trank] = prox_tnn_parfor(Y,rho,p)
%this function is used to update E of our model,E is the tensor

% The proximal operator of the tensor nuclear norm of a 3 way tensor
%
% min_X rho*||X||_*+0.5*||X-Y||_F^2
%
% Y     -    n1*n2*n3 tensor
%
% X     -    n1*n2*n3 tensor
% tnn   -    tensor nuclear norm of X
% trank -    tensor tubal rank of X
%

% 

[n1,n2,n3] = size(Y);
n12 = min(n1,n2);
Y = fft(Y,[],3);
U = zeros(n1,n12,n3);
V = zeros(n2,n12,n3);
S = zeros(n12,n12,n3);
trank=zeros(n3,1);
parfor i = 1 : n3
    [U(:,:,i),s,V(:,:,i)] = svd(Y(:,:,i),'econ');
    s = diag(s);
    s = solve_Lp(s, rho, p); 
    S(:,:,i) = diag(s);
    trank(i) = length(find(s~=0));

end
max_trank=max(trank);
U = U(:,1:max_trank,:);
V = V(:,1:max_trank,:);
S = S(1:max_trank,1:max_trank,:);

U = ifft(U,[],3);
S = ifft(S,[],3);
V = ifft(V,[],3);

X = tprod( tprod(U,S), tran(V));

S = S(:,:,1);
tnn = sum(S(:)); % return the tensor nuclear norm of X
