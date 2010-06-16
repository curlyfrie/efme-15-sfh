%exercise 4 group 15
% 
% function abgabe4

%CONTROL variable to switch calculation mode:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%full covarianz for a class => CONTROL = 1
%covarianz diagonal => CONTROL = 2
%covarianz overall => CONTROL = 3
%covarianz overall mean => CONTROL = 4


CONTROL = 1;

file = 'data/pima-indians-diabetes.data';
data = load(file);

training = data(1:300, :);
testing = data(301:768, :);
PICS = length(testing);

errors = zeros(PICS,1);

% Mahalanobis Distance classifier
%     testing = 'Mahalanobis - alle Werte' 
%     mahalanobisclassify(data(1:300, 1:9), data(301:768, 1:9));
%     
%     testing = 'Mahalanobis - ohne Werte 4 und 5' 
%     mahalanobisclassify(data(1:300, [1, 2, 3, 6, 7, 8, 9]), data(301:768, [1, 2, 3, 6, 7, 8, 9])); % ohne Spalte 4 und 5
%      
% Mahalanobis Classify
% in der 9. Spalte steht die Klasifikation


%sorted by column 9 (class: 0 => no diabetes, 1 => diabetes)
train = sortrows(training, size(training,2));
test = sortrows(testing, size(testing,2));

%calculate the vectors and matrices
%use the features [1 2 6:12]

   
    %mean value for class 0
    mw{1} = mean(train(train(:,9) == 0,1:8));
    
    %covariance for class 0
    cv{1} = cov(train(train(:,9) == 0,1:8));

    %diagonal covariance matrice for class 0
    cvd{1} = diag(diag(cov(train(train(:,9) == 0,1:8))));
    
    %mean value for class 1
    mw{2} = mean(train(train(:,9) == 1,1:8));
    
    %covariance for class 1
    cv{2} = cov(train(train(:,9) == 1,1:8));

    %diagonal covariance matrice for class 1
    cvd{2} = diag(diag(cov(train(train(:,9) == 1,1:8))));
    
    %covariance for all classes and pictures
    cva = cov(train(:,1:8));
    
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
            mahala_temp = sqrt((test(k,1:8) - mw{l}) * cv{l}^(-1) * (test(k,1:8) - mw{l})');
       
       elseif CONTROL == 2
       %covarianz diagonal
            mahala_temp = sqrt((test(k,1:8) - mw{l}) * cvd{l}^(-1) * (test(k,1:8) - mw{l})');
      
       elseif CONTROL == 3
            %covarianz overall 
            mahala_temp = sqrt((test(k,1:8) - mw{l}) * cva^(-1) * (test(k,1:8) - mw{l})');
       elseif CONTROL == 4
            %covarianz overall mean
            mahala_temp = sqrt((test(k,1:8) - mw{l}) * cva_mw^(-1) * (test(k,1:8) - mw{l})');
       
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
    
    %nature-human
    %if classes are not equal => errors = 1
    if mahala(1,2)~= test(k,9)
        errors(k)=1;
       % disp('-wrong class');
    else 
        %disp('+right class ');
    end

 end

 sumerrors = sum(errors);
 prozent = (sumerrors*100)/PICS;
 
    if CONTROL == 1
        disp(['full covarianz for a class: sumerrors = ', num2str(sumerrors),' prozent = ', num2str(prozent)]);
    elseif CONTROL == 2
        disp(['covarianz diagonal: sumerrors = ', num2str(sumerrors),' prozent = ', num2str(prozent)]);
    elseif CONTROL == 3
        disp(['covarianz overall: sumerrors = ', num2str(sumerrors),' prozent = ', num2str(prozent)]);
    elseif CONTROL == 4 
        disp(['covarianz overall mean: sumerrors = ', num2str(sumerrors),' prozent = ', num2str(prozent)]);
    end
end