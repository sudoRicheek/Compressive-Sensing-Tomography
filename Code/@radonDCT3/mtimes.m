function res = mtimes(A,x)

if A.adjoint == 0 %A*x
    b1 = x(1:end/3);
    delb12 = x(end/3+1:2*end/3);
    delb23 = x(2*end/3+1:end);
    
    r1ub1 = idct2(reshape(b1, [A.size A.size]));
    [r3ub1,~] = radon(r1ub1,A.theta3,A.bins);
    [r2ub1,~] = radon(r1ub1,A.theta2,A.bins);
    [r1ub1,~] = radon(r1ub1,A.theta1,A.bins);
    
    r2udelb12 = idct2(reshape(delb12, [A.size A.size]));
    [r3udelb12,~] = radon(r2udelb12,A.theta3,A.bins);
    [r2udelb12,~] = radon(r2udelb12,A.theta2,A.bins);
    
    r3udelb23 = idct2(reshape(delb23, [A.size A.size]));
    [r3udelb23,~] = radon(r3udelb23,A.theta3,A.bins);
    
    r2ub1 = r2ub1 + r2udelb12;
    r3ub1 = r3ub1 + r3udelb23 + r3udelb12;
    
    vec_size = [A.bins*A.angles 1];
    res = [reshape(r1ub1,vec_size); reshape(r2ub1,vec_size); reshape(r3ub1,vec_size)];
else %At*x
    y1 = x(1:end/3);
    y2 = x(end/3+1:2*end/3);
    y3 = x(2*end/3+1:end);
    
    utr1ty1 = iradon(reshape(y1,[A.bins A.angles]),A.theta1,'linear','Ram-Lak',A.size);
    utr1ty1 = dct2(utr1ty1);
    
    utr2ty2 = iradon(reshape(y2,[A.bins A.angles]),A.theta2,'linear','Ram-Lak',A.size);
    utr2ty2 = dct2(utr2ty2);
    
    utr3ty3 = iradon(reshape(y3,[A.bins A.angles]),A.theta3,'linear','Ram-Lak',A.size);
    utr3ty3 = dct2(utr3ty3);
    
    utr1ty1 = utr1ty1 + utr2ty2 + utr3ty3;
    utr2ty2 = utr2ty2 + utr3ty3;
    
    vec_size = [A.size*A.size 1];
    res = [reshape(utr1ty1,vec_size); reshape(utr2ty2,vec_size); reshape(utr3ty3,vec_size)];
end