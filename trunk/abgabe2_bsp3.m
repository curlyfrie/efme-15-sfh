%exercise 2.3 group 15

%function abgabe2_bsp3

%load test and trainings set
imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');

%the picture classes
% BRICKFACE = 1
% SKY = 2
% FOLIAGE = 3
% CEMENT = 4
% WINDOW = 5
% PATH = 6
% GRASS = 7
classarray = {'BRICKFACE','SKY','FOLIAGE','CEMENT','WINDOW','PATH','GRASS';};


%declaration of data types
PICS = length(imptest.data);
errors = zeros(PICS,1);
mw = cell(7,1);
cv = cell(7,1);
cvd = cell(7,1);

%calculate the vectors and matrices
%use the features [1 2 6:12]
for i=1:7

    temp = impdata.data(1+(i-1)*30:30*i,:);
    
    %mean value for a class
    mw{i} = mean(temp(:, [1 2 6:12]));
    
    %covariance for a class
    cv{i} = cov(temp(:, [1 2 6:12]));

    %diagonal covariance matrice
    cvd{i} = diag(diag(cov(temp(:,[1 2 6:12]))));
end

%mean covariance over all classes
cva_mw = 1/7 * (cv{1} + cv{2} + cv{3} + cv{4} + cv{5} + cv{6} + cv{7});

%covariance for all classes and pictures
cva = cov(impdata.data(:, [1 2 6:12]));

%iterate through test data
for k=1:PICS
    %iterate through trainigsdata and calculate mahalanobis distance
    
    %calculate distance, customize the calculation  formula
    %mw is here a row vector instead of a column vector
    %so the first x-mw ist not transposed but the last
    %formula: sqrt((x - mw) * cv^-1 * (x - mw)')
    
    %set distance to max; to find min distance 
    mahala(1,1) = realmax;
    
    for l=1:7
       
    %uncomment for the wanted covarience
        
       %covarianz for a class
       % mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cv{l}^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       %covarianz diagonal
       %mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cvd{l}^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       %covarianz overall mean
       %mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cva_mw^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       %covarianz overall 
       mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cva^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       %if new distance is smaller than old, keep it and its class 
       if mahala_temp <  mahala(1,1)
          
           %min distance 
           mahala(1,1) = mahala_temp;
           
           %class of min distance
           mahala(1,2) = l;
        end
    end

    % get class of current picture
    [a,curclass] = find(ismember(classarray,imptest.textdata(k))==1);

    %if classes are not equal => errors = 1
    if mahala(1,2)~=curclass 
        errors(k)=1;
       % disp('-wrong class');
    else 
        %disp('+right class ');
    end
end

sumerrors = sum(errors)

prozent = (sumerrors*100)/PICS

