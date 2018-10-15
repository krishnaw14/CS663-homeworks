A = [4 0;3 -5];
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
x2 = zeros(n,1);
x3 = zeros(m,1);
for i = 1:length(f)
    I = eye(m1);
    f(i);
    C1 = C-f(i)*I;
    x = null(C1);
    if dot(x,x2)<0
        x=-x
    end
    vi = [vi x];
    x2=x;
end
vi = vi(:,[2:end]);
vi = vi.';
Ct = A*B;
e = eig(C);

e = sort(e,'descend');
f=e;
ui = zeros(m,1);
for i = 1:length(f)-n+m
    I = eye(n1);
    f(i);
    C1 = (Ct)-f(i)*I;
    x4 = null(C1);
    if dot(x4,x3)<0
        x4=-x4;
    end
    ui = [ui x4];
    x3=x4;
end
ui = ui(:,[2:end]);
Dn = D([1:m],[1:n]);
U = ui;
if m<n
    V=vi;
else
    V=vi.';
end

EE = zeros(m,n);
i=1;
U*Dn*V
if (U*Dn*V ~= A)
    i;
    U(3)=-U(3);
    U(4)=-U(4);
end 
if n==2
    if m==2
        Us = A*V*inv(D);
    end
U =Us;
end
if m<n
    V=V.';
else
    V=V;
end
V
U
Dn
U*Dn*V.'