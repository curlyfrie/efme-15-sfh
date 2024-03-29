u1 = mvnrnd([5 6 5],[1 0 0; 0 1 0; 0 0 1], 20);
u2 = mvnrnd([0 1 1],[1 0 0; 0 1 0; 0 0 1], 20);
u = [u1;u2];


m1 = mean(u1);
m2 = mean(u2);
m = [m1;m2];

gr(1:20) = 1;
gr(21:40) = 2;

x=[m1(1) m2(1)];
y=[m1(2) m2(2)];
z=[m1(3) m2(3)];

figure(1)

scatter3(u1(:,1), u1(:,2), u1(:,3),  'filled');
hold on;
scatter3(u2(:,1), u2(:,2), u2(:,3),  'filled');
scatter3(m(:,1), m(:,2), m(:,3),  'filled');
line(x,y,z);

% [X,Y,Z] = meshgrid(linspace(-1,6),linspace(-1,6), linspace(-1,6));
% X = X(:); Y = Y(:); Z = Z(:);

[C, err, P, logp, coeff] = classify(u, u, gr, 'quadratic');
K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
% f = sprintf('0 = %g + %g*x + %g*y + %g*x^2 + %g*x.*y + %g*y.^2', ...
%             K,L,Q(1,1),Q(1,2)+Q(2,1),Q(2,2));

f = @(x,y) (K + L(1)*x + L(2)*y)/-L(3);
ezmesh(f);
hold off;
