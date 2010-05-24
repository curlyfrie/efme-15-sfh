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
gscatter(X,Y,C);
% Draw boundary between two regions - using testsets
hold on
grid on
K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
f = sprintf('0 = %g + %g*x + %g*y + %g*x^2 + %g*x.*y + %g*y.^2', ...
            K,L,Q(1,1),Q(1,2)+Q(2,1),Q(2,2));
ezplot(f,[1 11 -1 7]);


% 2nd part...

u1 = [5;6;5];
u2 = [0;1;1];

e = eye(3);

sigma = cov(e);

r1 = mvnrnd(u1,sigma,3);
r2 = mvnrnd(u2,sigma,3);

m1 = mean(r1,3);
m2 = mean(r2,3);


x=[m1(1) m2(1)];
y=[m1(2) m2(2)];
z=[m1(3) m2(3)];

figure(2)

plot3(m1(:,1), m1(:,2), m1(:,3), 'x');
grid on;
hold on;
plot3(m2(:,1), m2(:,2), m2(:,3), 'x');
hold off;

d = [r1;r2];
for i=1:size(d,1)
    for j=1:size(d,2)
        if (d(i,j) < 3)
             gruppe(i,1) = 'a';
        else
             gruppe(i,1) = 'b';
        end
    end
end    
    
[X,Y,Z] = meshgrid(linspace(-1,6),linspace(-1,6), linspace(-1,6));
X = X(:); Y = Y(:); Z = Z(:);

gruppe

cb = [d(1:6,1) d(1:6,2) d(1:6,3)];
% cb = [c(1,1:6) c(2,1:6) c(3,1:6)];
[C, err, logp, coeff3] = classify([X Y Z], cb, gruppe);


% K = coeff(1,2).const;
% L = coeff(1,2).linear;
% Q = coeff(1,2).quadratic;
% f = sprintf('0 = %g + %g*x + %g*y + %g*x^2 + %g*x.*y + %g*y.^2', ...
%             K,L,Q(1,1),Q(1,2)+Q(2,1),Q(2,2));
% ezmesh(f);
