function res = mtimes(A,x)

if A.adjoint == 0 %A*x
    res = idct2(reshape(x, [A.size A.size]));
    [res,~] = radon(res,A.theta,A.bins);
    res = reshape(res,[A.bins*A.angles 1]);
else %At*x
    res = iradon(reshape(x,[A.bins A.angles]),A.theta,'linear','Ram-Lak',A.size);
    res = dct2(res);
    res = reshape(res,[A.size*A.size 1]);
end