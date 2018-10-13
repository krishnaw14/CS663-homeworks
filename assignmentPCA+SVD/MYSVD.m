function [U, V] = mySVD(A)

[U, D1] = eigs(A*transpose(A))
D1 = eigs(A*transpose(A))
% disp(U);
[V, D2] = eigs(transpose(A)*A)
% disp(V);
D1 = sort(D1,'descend')
S =diag(sqrt(D1))
S = inv(S)

reconstructed_A = U*S*V.'



