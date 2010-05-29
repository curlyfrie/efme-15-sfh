A = [2 2 4 4; 6 0 6 0];
B = [8 8 10 10; 2 4 2 4];
gr = [1,1,1,1,2,2,2,2];


C = [A B];

meana = mean (A,2);
meanb = mean (B,2);

figure('Name', 'Matlab - Covariance Matrix');
hold on;
gscatter(C(1,:),C(2,:),gr, 'gm'); 
gscatter(meana(1),meana(2), 'Color', 'blue');
gscatter(meanb(1),meanb(2), 'Color', 'blue');

plot(meanb, meana);

[X,Y] = meshgrid(linspace(1,11),linspace(-1,7));
X = X(:); Y = Y(:);
[c,err,P,logp,coeff] = classify([X Y],C',gr,'quadratic');
gscatter(X,Y,c);

% Draw boundary between two regions - using testsets
K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
f = sprintf('0 = %g + %g*x + %g*y + %g*x^2 + %g*x.*y + %g*y.^2', ...
            K,L,Q(1,1),Q(1,2)+Q(2,1),Q(2,2));
ezplot(f,[1 11 -1 7]);
title('Discriminant functions with Matlab');


figure('Name', 'Hand - Covariance Matrix')
hold on;
grid on;

% print points, mean
gscatter(C(1,:),C(2,:),gr, 'gm'); 
gscatter(meana(1),meana(2), 'Color', 'blue');
gscatter(meanb(1),meanb(2), 'Color', 'blue');

% put in calculated discriminant function
cov = ezplot('-4.5*x + 0.333*y^2 - 2*y + 28.9014');
set(cov, 'color', 'b');
title('Discriminant function by hand (covariance)');

figure('Name', 'Hand - Identity Matrix');
hold on;
grid on;

gscatter(C(1,:),C(2,:),gr, 'gm'); 
gscatter(meana(1),meana(2), 'Color', 'blue');
gscatter(meanb(1),meanb(2), 'Color', 'blue');
id = ezplot('-0.5*x.^2 + 9*x - 0.5*y.^2 + 3*y - 45 - log(0.5) = -0.5*x.^2 + 3*x - 0.5*y.^2 + 3*y - 9 - log(0.5)');
set(id, 'color', 'b');
title('Discriminant function by hand (identity)');