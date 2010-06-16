function main ()

    CLOSE ALL;
    CLOSE ALL HIDDEN;
    
    in = [0 1 0 1; 0 0 1 1];
    in = homogen(in);
    and = [-1 -1 -1 1];
    or = [-1 1 1 1];
    xor = [-1 1 1 -1];

    disp('and:');
    perco (in, and, 100);
    
    disp('or:');
    perco (in, or, 100);
    
    disp('XOR:');
    perco (in, xor, 100);
    
    inputs = load('perceptrondata.dat');
    target1 = load('perceptrontarget1.dat');
    target2 = load('perceptrontarget2.dat');
   
    % convert inputs to homogenuous coordinates
    inputs = homogen(inputs');

    target1 = target1';
    % convert 0 to -1 for calc perceptron
    target1(target1(:,:) ==0) = -1; 

    target2 = target2';
    % convert 0 to -1 for calc perceptron
    target2(target2(:,:) ==0) = -1;

    disp('Perceptron Target 1 - 1 Zyklus:');
    perceptron = perco(inputs, target1, 1)
    
    disp('Perceptron Target 1 - 5 Zyklen:');
    perceptron = perco(inputs, target1, 5)
    
    disp('Perceptron Target 1 - 10 Zyklen:');
    perceptron = perco(inputs, target1, 10)
    
    disp('Perceptron Target 1 - 100 Zyklen:');
    perceptron = perco(inputs, target1, 100)

    disp('Perceptron Target 1 - 1000 Zyklen:');
    perceptron = perco(inputs, target1, 1000)
    
    disp('Perceptron Target 1 - 10 000 Zyklen:');
    perceptron = perco(inputs, target1, 10000)
   
    disp('Perceptron Target 2 - 1 Zyklus:');
    perceptron = perco(inputs, target2, 1)
    
    disp('Perceptron Target 2 - 10 Zyklen:');
    perceptron = perco(inputs, target2, 10)
    
    disp('Perceptron Target 2 - 100 Zyklen:');
    perceptron = perco(inputs, target2, 100)
    
    disp('Perceptron Target 2 - 1 000 Zyklen:');
    perceptron = perco(inputs, target2, 1000)
    
    disp('Perceptron Target 2 - 10 000 Zyklen:');
    perceptron = perco(inputs, target2, 10000)

% hoher rechenaufwand:    
%     disp('Perceptron Target 2 - 100 000 Zyklen:');
%     perceptron = perco(inputs, target2, 100000)
%     
%     disp('Perceptron Target 2 - 1 000 000 Zyklen:');
%     perceptron = perco(inputs, target2, 1000000)
   
% convert X into homogenuous coordinates x
function [x] = homogen(X)
    
    [m, n] = size(X);
    x = ones(m+1, n);
    
    for i = 2:m+1
        for j = 1:n
           x(i, j) = X(i-1, j);
        end
    end   



function [w] = perco (X, t, maxEpoches)
    
    [m, n] = size(X);
    w = zeros(m, 1); % initialize weight-vector
    w(1) = 0;
    
    cycle = 0;
    wrong = true;
    
    % Online Perceptron Training Algorithm #330 - Skriptum
    while wrong == true && cycle < maxEpoches
        
        cycle = cycle + 1;
        wrong = false;
        
        for i = 1:n
            if w'*(X(:,i)*t(i)) <= 0
            
                w = w + X(:,i)*t(i); 
                wrong = true;
            end
        end
    end
    plot_result(X, t, w);

    % identify wrong classified objects
    dif_anz=0;
    for i=1:n
       if sign(w'*X(:, i)) ~= t(i);
           dif_anz=dif_anz+1;
       end
    end    
   
    sprintf('Fehler: %d\n%6.3f%% korrekt erkannt', dif_anz, (418-dif_anz)/418*100)
    
function plot_result(X, target, w)
    [m, n] = size(X);
    
    figure
    hold on
    for i=1:n
        if target(i) == -1
            plot(X(2, i), X(3, i), 'r.');
        else
            plot(X(2, i), X(3, i), 'b.');
        end
    end
    
    
    sum=0;
    
    %plot decision boundary
    
    for i=2:m
        sum = sum + w(i) * w(i);
    end
    norm_vector = sqrt(sum);

    if norm_vector ~= 0 && w(2) ~= 0
        
        distancefromcenter = abs(w(1)/norm_vector);
        d = distancefromcenter * ( w(3) + (w(2)* w(2)/w(3)) ) / norm_vector;
        k = - w(2) / w(3);
       
        x=-0.5:0.1:1.5;
    
        plot(x, k*x + d, 'g');
        axis([-0.2 1.2 -0.2 1.2]);
    end
    
    hold off    