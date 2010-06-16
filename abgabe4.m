%exercise 4 group 15
% 
function abgabe4

file = 'data/pima-indians-diabetes.data';
data = load(file);

training = data(1:500, :);
testing = data(501:768, :);
PICS = length(testing);

disp(['Mahalnobis with all features (training 1-500, test 501-768)',10]);
mahala (training, testing, PICS)

%without features 4 and 5, because most of them are 0 (mode(data(:,4)) = 0)
disp([10,10,'Mahalnobis without feature 4 and 5 (training 1-500, test 501-768)',10]);
mahala (training(:,[1:3 6:9]), testing(:,[1:3 6:9]), PICS)


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