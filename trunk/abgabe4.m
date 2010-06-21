%exercise 4 group 15
% 
function abgabe4

close all;
clear;

file = 'data/pima-indians-diabetes.data';
data = load(file);
n = 500;

training = data(1:n, :);
testing = data(n+1:size(data), :);
PICS = length(testing);


features = [1:3 6:9]

%MAHALANOBIS
%%%%%%%%%%%%%

%with all features
disp(['Mahalanobis with all features (training 1-500, test 501-768)',10]);
mahala (training, testing, PICS)

%without features 4 and 5, because most of them are 0 (mode(data(:,4)) = 0)
disp([10,10,'Mahalnobis without feature 4 and 5 (training 1-500, test 501-768)',10]);
mahala (training(:,features), testing(:,features), PICS)

%KNN
%%%%%%%%%%%%%

kNN = 20;
%with all features
disp([10,10,'kNN with all features (training 1-500, test 501-768)',10]);
knn(training, testing, PICS,kNN,'kNN with all features')

% %without features 4 and 5, because most of them are 0 (mode(data(:,4)) = 0)
disp([10,10,'kNN without feature 4 and 5 (training 1-500, test 501-768)',10]);
knn (training(:,features), testing(:,features), PICS,kNN, 'kNN without feature 4 and 5')


%PERCEPTRON
%%%%%%%%%%%%%
training_target = data(1:n, 9);
testing_target = data(n+1:768, 9);

training_target = training_target';
testing_target = testing_target';

% convert 0 to -1 for calc perceptron
training_target(training_target(:,:) == 0) = -1;
testing_target(testing_target(:,:) == 0) = -1;

%with all features
training = homogen(data(1:n, 1:8)');
testing = homogen(data(n+1:768, 1:8)');

% Perceptron    
disp('Perceptron - 10 Zyklen, alle Daten')
perco(training, training_target, 10, testing, testing_target, PICS);
disp('Perceptron - 100 Zyklen, alle Daten')
perco(training, training_target, 100, testing, testing_target, PICS);
disp('Perceptron - 1 000 Zyklen, alle Daten')
perco(training, training_target, 1000, testing, testing_target, PICS);
disp('Perceptron - 10 000 Zyklen, alle Daten')
perco(training, training_target, 10000, testing, testing_target, PICS);
% disp('Perceptron - 100 000 Zyklen, alle Daten')
% perco(training, training_target, 100000, testing, testing_target, PICS);
%     
%without features 4 and 5, because most of them are 0 (mode(data(:,4)) = 0)

pfeatures=features(1,1:length(features)-1)
training = data(1:n, pfeatures)';
testing = data(n+1:768,pfeatures)';

% Perceptron    
disp('Perceptron - 10 Zyklen, ohne 4,5')
perco(training, training_target, 10, testing, testing_target, PICS);
disp('Perceptron - 100 Zyklen, ohne 4,5')
perco(training, training_target, 100, testing, testing_target, PICS);
disp('Perceptron - 1 000 Zyklen, ohne 4,5')
perco(training, training_target, 1000, testing, testing_target, PICS);
disp('Perceptron - 10 000 Zyklen, ohne 4,5')
perco(training, training_target, 10000, testing, testing_target, PICS);
% disp('Perceptron - 100 000 Zyklen, ohne 4,5')
% perco(training, training_target, 100000, testing, testing_target, PICS);


%NEURAL NETWORK
%%%%%%%%%%%%%

training = data(1:n, :);
testing = data(n+1:size(data), :);
disp('Neural Newtwork - alle Daten')
neuralnetwork(training,testing);
disp('Neural Newtwork - ohne 4,5')
neuralnetwork(training(:,features),testing(:,features));


function mahala (training, testing, PICS)

%CONTROL variable to switch calculation mode:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%full covarianz for a class => CONTROL = 1
%covarianz diagonal => CONTROL = 2
%covarianz overall => CONTROL = 3
%covarianz overall mean => CONTROL = 4

% postion of the class in train matrix
class = size(training,2);

%sorted by the last column, class (class: 0 => no diabetes, 1 => diabetes)
train = sortrows(training, class);
test = sortrows(testing, class);


%calculate the vectors and matrices

    %mean value for class 0 and 1
    mw{1} = mean(train(train(:,class) == 0,1:class-1));
    mw{2} = mean(train(train(:,class) == 1,1:class-1));
    
    %covariance for class 0 and 1
    cv{1} = cov(train(train(:,class) == 0,1:class-1));
    cv{2} = cov(train(train(:,class) == 1,1:class-1));

    %diagonal covariance matrice for class 0 and 1
    cvd{1} = diag(diag(cov(train(train(:,class) == 0,1:class-1))));
    cvd{2} = diag(diag(cov(train(train(:,class) == 1,1:class-1))));
    
    %covariance for all classes
    cva = cov(train(:,1:class-1));
    
    %mean covariance for all classes
    cva_mw = 1/2 * (cv{1} + cv{2});
       
for CONTROL = 1:4
    errors = zeros(PICS,1);
    
    for k=1:PICS
        %iterate through trainigsdata and calculate mahalanobis distance

        %calculate distance, customize the calculation  formula
        %mw is here a row vector instead of a column vector
        %so the first x-mw ist not transposed but the last
        %formula: sqrt((x - mw) * cv^-1 * (x - mw)')

        mahala(1,1) = realmax;

        for l=1:2

           %CONTROL variable is above
           if CONTROL == 1
           %full covarianz for a class
                mahala_temp = sqrt((test(k,1:class-1) - mw{l}) * cv{l}^(-1) * (test(k,1:class-1) - mw{l})');

           elseif CONTROL == 2
           %covarianz diagonal
                mahala_temp = sqrt((test(k,1:class-1) - mw{l}) * cvd{l}^(-1) * (test(k,1:class-1) - mw{l})');

           elseif CONTROL == 3
                %covarianz overall 
                mahala_temp = sqrt((test(k,1:class-1) - mw{l}) * cva^(-1) * (test(k,1:class-1) - mw{l})');
           elseif CONTROL == 4
                %covarianz overall mean
                mahala_temp = sqrt((test(k,1:class-1) - mw{l}) * cva_mw^(-1) * (test(k,1:class-1) - mw{l})');

           else
                mahala_temp = 0;
           end
           %if new distance is smaller than old, keep it and its class 
           if mahala_temp <  mahala(1,1)

               %min distance 
               mahala(1,1) = mahala_temp;

               %class of min distance
               mahala(1,2) = l-1;
            end
        end

        %not diabetic - diabetic (0 - 1)
        %if classes are not equal => errors = 1
        if mahala(1,2)~= test(k,class)
            errors(k)=1;
           % disp('-wrong class');
        else 
            %disp('+right class ');
        end
    end

    sumerrors = sum(errors);
    percent = (sumerrors*100)/PICS;
 
    if CONTROL == 1
        disp(['full covarianz for a class: sumerrors = ', num2str(sumerrors),' percent = ', num2str(percent)]);
    elseif CONTROL == 2
        disp(['covarianz diagonal: sumerrors = ', num2str(sumerrors),' percent = ', num2str(percent)]);
    elseif CONTROL == 3
        disp(['covarianz overall: sumerrors = ', num2str(sumerrors),' percent = ', num2str(percent)]);
    elseif CONTROL == 4 
        disp(['covarianz overall mean: sumerrors = ', num2str(sumerrors),' percent = ', num2str(percent)]);
    end
end

function knn(training, testing, PICS, kNN, name)


%declaration of data types
eucl = cell(PICS,2);
errors = zeros(PICS,kNN);

class = size(training,2);

%iterate through test data
for k=1:PICS
    %iterate through trainigsdata and calculate euclid distance
    for l=1:length(training)

        eucl{l,1} = sqrt(sum((training(l,1:class-1)-testing(k,1:class-1)).^2));
        eucl{l,2} = training(l,class);
    end

    % get class of current picture
    curclass = testing(k,class);

    % now sort it
    [distances] = sortrows(eucl);
    
    %error test every picture if wrong or right
    %needed for the graph 
    for v=1:kNN
        if mode([distances{1:v,2}])~=curclass 
            errors(k,v)=1;
        end
    end
    
end


%     sumerrors = sum(errors)
%     percent = (sumerrors*100)/PICS


% calculate graphs and make a wonderful looking plot
% sumerrors = zeros(1,kNN);
%  for p=1:kNN 
%          sumerrors(p) = sum(errors(:,p));
%  end

sumerrors = sum(errors);
percent = (sumerrors*100)/PICS;

%display best kNN value and the corresponding values
[theerror, bestknn]=min(sumerrors)
thepercent = min(percent)

figure('Name',['Errorrate ', name],'NumberTitle','off')
plot(1:kNN,percent);
title(name);
xlabel('kNN')
ylabel('Errorrate %')
axis([0 kNN  15 40]);


function [x] = homogen(X)
    
    [m, n] = size(X);
    x = ones(m+1, n);
    
    for i = 2:m+1
        for j = 1:n
           x(i, j) = X(i-1, j);
        end
    end
    
function [w] = perco (training, training_target, maxEpoches, testing, testing_target, PICS)
    [m, n] = size(training);
    w = zeros(m, 1);
    w(1) = 0;
    
    cycle = 0;
    wrong = true;
    
    while (wrong == true) && (cycle < maxEpoches)
        
        cycle = cycle + 1;
        wrong = false;
        
        for i = 1:n
            if w'*(training(:,i)*training_target(i)) <= 0
            
                w = w + training(:,i)*training_target(i); 
                wrong = true;
            end
        end
    end

    
    % identify wrong classified objects
    
    dif_anz = 0;
    [m, n] = size(testing);
    for i=1:n
       if sign(w'*testing(:, i)) ~= testing_target(i);
           dif_anz=dif_anz+1;
       end
    end
    
    sprintf('Fehler: %d\n%6.3f%% korrekt erkannt', dif_anz, (PICS-dif_anz)/PICS*100)
    
    
function [errorrate] = neuralnetwork(trainingset,testset)
        
    % just a little bit of declaration work and transposals
    siz = size(trainingset,2);
    trainingtarget = trainingset(:, siz)';
    training = trainingset(:,1:siz-1)';
    testingtarget=testset(:,siz);
    testing = testset(:,1:siz-1)';


    
    % reates a two-layer network with 2 neurons in the hidden layer
    % as trainingalgorithm trainlm is used
    net = newff(training,trainingtarget,2,{},'trainlm');

    % some settings 
    net.inputs{1}.processFcns = {'mapstd','processpca'};
    net.inputs{1}.processParams{2}.maxfrac = 0.001;
    net.outputs{2}.processFcns = {'mapstd'};
    
    % and more of them
    net.trainParam.lr = 0.05;
    net.trainParam.lr_inc = 1.05;

    % show output in commandline
    %net.trainParam.showCommandLine = true; 

    % diplay network
    %disp(net);
    
    % train the network based on trainingsset and trainingtarget
    [net,tr] = train(net,training,trainingtarget);
    % plot performance
    plotperform(tr)

   

    % simulating the network and get all the variables (we are using 
    [y,Pf,Af,E,perf]= sim(net,testing);

    
    % for the nex calculations we need to transpose the testingtargets
    testingtarget=testingtarget';
    
    % if the simulated value is >0.5 its put into class 1 
    % otherwise into 0
    for i=1:length(y)
        if (y(i)>0.5) 
            ergebnis(i) = 1;
        else 
            ergebnis(i) = 0;
        end

        if ergebnis(i)~=testingtarget(i) 
            errors(i) = 1;
        end
    end

    % calculated errorrate based on classification above
    errorrate=sum(errors)/length(testingtarget);
    sprintf('Fehler: %d\n%6.3f%% korrekt erkannt', sum(errors), (1-errorrate)*100)
    
    % errorrate based on Network errors calculated by sim() 
    sim_erorrate = sum(E)/length(E);

