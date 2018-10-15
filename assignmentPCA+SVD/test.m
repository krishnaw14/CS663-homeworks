A = [4 0 ;3 -5];
[m,n]=size(A);
B = A.';
C = B*A;
e = eig(C);

e = sort(e,'descend');
f=e;
e = sqrt(e);
D = diag(e);
[V,R] = eig(C);
[m1,m2] = size(C);
vi = zeros(n,1);
ui = zeros(m,1);

for i = 1:length(f)
    I = eye(m1);
    f(i);
    C1 = C-f(i)*I;
    x = null(C1);
    vi = [vi x];
end
vi = vi(:,[2:end]);
vi = vi.'
Ct = A*B;
e = eig(C);

e = sort(e,'descend');
f=e;
ui = zeros(m,1);
for i = 1:length(f)
    I = eye(n1);
    f(i);
    C1 = (Ct)-f(i)*I;
    x2 = null(C1);
    ui = [ui x2];
end
ui = ui(:,[2:end]);
Dn = D([1:m],[1:n]);
ui
vi.'
Dn
