function   x   =  solve_Lp( y, lambda, p )


J  = 1;  %2
x  = zeros( size(y) );

i0 = find(y>0);
    
lambda0 = lambda(i0);
y0 = y(i0);
t  = y0;
i1=[];

if length(i0)>=1
    
    for  j  =  1 : J
        
        i1 = find( y0 > p*lambda0.*(t).^(p-1) );
        y0 = y0(i1);
        lambda0 = lambda0(i1);
        t = t(i1);
        t = y0 - p*lambda0.*(t).^(p-1);

    end
    x(i1)   =  t;
end

