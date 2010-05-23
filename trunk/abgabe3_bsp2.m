A = [2 2 4 4; 6 0 6 0];
B = [8 8 10 10; 2 4 2 4];

meana = mean (A,2);
meanb = mean (B,2);

% plot the means of a and b
gscatter(meana(1),meana(2));
hold on
gscatter(meanb(1),meanb(2));
hold on

% draw line between meanb and meana
plot(meanb, meana);

% group results into x and o
C = [A B];

% loop neccessary?
% decide with value x what divides the group
for i=1:size(C(1,:),2)
    if (C(1,i) < 6)
        gr(i,1) = 'x';
    else
        gr(i,1) = 'o';
    end
end

[c] = classify(C(1,:)',C(2,:)',gr,'quadratic');

% plot the points of a and b in red and blue with x and o
gscatter(C(1,:),C(2,:),c,'rb','xo',[],'off'); 

[X,Y] = meshgrid(linspace(1,11),linspace(-1,7));
X = X(:); Y = Y(:);
[C,err,P,logp,coeff] = classify([X Y],C',gr,'quadratic');

% Draw boundary between two regions - using testsets
hold on
grid on
K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
f = sprintf('0 = %g + %g*x + %g*y + %g*x^2 + %g*x.*y + %g*y.^2',K,L,Q(1,1),Q(1,2)+Q(2,1),Q(2,2))
ezplot(f,[1 11 -1 7]);