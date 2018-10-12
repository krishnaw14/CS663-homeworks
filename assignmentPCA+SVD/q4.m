A = [4,0;3, -5];
B = A.';
C = B*A;
e = eig(C);

e;
e = sort(e,'descend')
e = sqrt(e);
D = diag(e);
D1 = inv(D);
[V,R] = eig(C);
VT = V.';
U = A*V*D1;
U*D*VT - A
