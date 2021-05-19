function res = mtimes(A,x)

if A.adjoint == 0 %A*x
    b1 = x(1:end/2);
    delb = x(end/2+1:end);
    
    r1ub1 = idct2(reshape(b1, [A.size A.size]));
    [r2ub1,~] = radon(r1ub1,A.theta2,A.bins);
    [r1ub1,~] = radon(r1ub1,A.theta1,A.bins);    
    
    r2udelb = idct2(reshape(delb, [A.size A.size]));
    [r2udelb,~] = radon(r2udelb,A.theta2,A.bins);
    
    r2ub1 = r2ub1 + r2udelb;
    
    vec_size = [A.bins*A.angles 1];
    res = [reshape(r1ub1,vec_size); reshape(r2ub1,vec_size)];
else %At*x
    y1 = x(1:end/2);
    y2 = x(end/2+1:end);
    
    utr1ty1 = iradon(reshape(y1,[A.bins A.angles]),A.theta1,'linear','Ram-Lak',A.size);
    utr1ty1 = dct2(utr1ty1);
    
    utr2ty2 = iradon(reshape(y2,[A.bins A.angles]),A.theta2,'linear','Ram-Lak',A.size);
    utr2ty2 = dct2(utr2ty2);
    
    utr1ty1 = utr1ty1 + utr2ty2;
    
    vec_size = [A.size*A.size 1];
    res = [reshape(utr1ty1,vec_size); reshape(utr2ty2,vec_size)];
end