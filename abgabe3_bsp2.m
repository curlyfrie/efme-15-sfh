A = [2 2 4 4; 6 0 6 0];
B = [8 8 10 10; 2 4 2 4];

meana = mean (A,2);
meanb = mean (B,2);


gscatter(A(1,:),A(2,:));
hold on
gscatter(B(1,:),B(2,:));
hold on
gscatter(meana(1),meana(2));
hold on
gscatter(meanb(1),meanb(2));
hold on


