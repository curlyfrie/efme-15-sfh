% Bayes Theorem

% probabilities
p1 = 0.5;
p2a = 0.9;
p2b = 0.1;

x = -4:0.1:8;

% calculate likelihood with normal probability density function
y1 = normpdf(x,1.5,1);
y2 = normpdf(x,3,1);

% print results
subplot(3,2,1)
plot(x,y1);
hold on;
plot(x,y2);

%print twice - just to see the difference between the probabilities
subplot(3,2,2)
plot(x,y1);
hold on;
plot(x,y2);

% calculate marginal distributions

% 0.5:
mdist1 = y1 .* p1 + y2 .* p1;

% 0.9, 0.1:
mdist2 = y1 .* p2a + y2 .* p2b;

% print results - marginal dist
subplot(3,2,3)
plot(x,mdist1);
grid on;

% print results - marginal dist
subplot(3,2,4)
plot(x,mdist2);
grid on;

% calculate posteriors

% 0.5:
post1a = y1 .* p1 ./ mdist1;
post1b = y2 .* p1 ./ mdist1;

% 0.9,0.1:
post2a = y1 .* p2a ./ mdist2;
post2b = y2 .* p2b ./ mdist2;

% print results posteriors
subplot(3,2,5)
plot(x, post1a)
grid on;
hold on;
plot(x, post1b)

subplot(3,2,6)
plot(x, post2a)
hold on;
plot(x, post2b)
