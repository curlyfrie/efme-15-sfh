%exercise 2.3 group 15

%function abgabe2_bsp3

%CONTROL variable to switch calculation mode:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%full covarianz for a class => CONTROL = 1
%covarianz diagonal => CONTROL = 2
%covarianz overall mean => CONTROL = 3
%covarianz overall => CONTROL = 4

CONTROL = 1;

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
errors_nh = zeros(PICS,1);
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


%nature and human class
%%%%%%%%%%%%%%%%%%%%%%%

nature = impdata.data([31:90 181:210],:);
human = impdata.data([1:30 91:180],:);

%mean value for a class
mw_nh{1} = mean(nature(:, [1 2 6:12]));
mw_nh{2} = mean(human(:, [1 2 6:12]));

%covariance for a class
cv_nh{1} = cov(nature(:, [1 2 6:12]));
cv_nh{2} = cov(human(:, [1 2 6:12]));

%diagonal covariance matrice
cvd_nh{1} = diag(diag(cov(nature(:,[1 2 6:12]))));
cvd_nh{2} = diag(diag(cov(human(:,[1 2 6:12]))));

%mean covariance over all classes
cva_nh_mw = 1/2 * (cv_nh{1} + cv_nh{2});


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
       
       %CONTROL variable is above
       if CONTROL == 1
            %full covarianz for a class
            mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cv{l}^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       elseif CONTROL == 2
            %covarianz diagonal
            mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cvd{l}^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       elseif CONTROL == 3
            %covarianz overall mean
            mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cva_mw^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       
       elseif CONTROL == 4
            %covarianz overall 
            mahala_temp = sqrt((imptest.data(k,[1 2 6:12])-mw{l}) * cva^(-1) * (imptest.data(k,[1 2 6:12])-mw{l})');
       else
           mahala_temp = 0;
       end
       
       %if new distance is smaller than old, keep it and its class 
       if mahala_temp <  mahala(1,1)
          
           %min distance 
           mahala(1,1) = mahala_temp;
           
           %class of min distance
           mahala(1,2) = l;
        end
    end
    
    %nature human
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    mahala_nh(1,1) = realmax;
    
    for l=1:2
       
       %CONTROL variable is above
       if CONTROL == 1
       %full covarianz for a class
            mahala_nh_temp = sqrt((imptest.data(k,[1 2 6:12])-mw_nh{l}) * cv_nh{l}^(-1) * (imptest.data(k,[1 2 6:12])-mw_nh{l})');
       
       elseif CONTROL == 2
       %covarianz diagonal
            mahala_nh_temp = sqrt((imptest.data(k,[1 2 6:12])-mw_nh{l}) * cvd_nh{l}^(-1) * (imptest.data(k,[1 2 6:12])-mw_nh{l})');
       
       elseif CONTROL == 3
       %covarianz overall mean
            mahala_nh_temp = sqrt((imptest.data(k,[1 2 6:12])-mw_nh{l}) * cva_nh_mw^(-1) * (imptest.data(k,[1 2 6:12])-mw_nh{l})');
       
       elseif CONTROL == 4
            %covarianz overall 
            mahala_nh_temp = sqrt((imptest.data(k,[1 2 6:12])-mw_nh{l}) * cva^(-1) * (imptest.data(k,[1 2 6:12])-mw_nh{l})');
       else
            mahala_nh_temp = 0;
       end
       %if new distance is smaller than old, keep it and its class 
       if mahala_nh_temp <  mahala_nh(1,1)
          
           %min distance 
           mahala_nh(1,1) = mahala_nh_temp;
           
           %class of min distance
           mahala_nh(1,2) = l;
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
    
%the picture classes
% BRICKFACE = 1
% SKY = 2 => nature
% FOLIAGE = 3 => nature
% CEMENT = 4
% WINDOW = 5
% PATH = 6
% GRASS = 7 => nature
    
    if curclass == 2 || curclass == 3 || curclass == 7
        curclass = 1;
    else
        curclass = 2;
    end
    
    %nature-human
    %if classes are not equal => errors_nh = 1
    if mahala_nh(1,2)~=curclass 
        errors_nh(k)=1;
       % disp('-wrong class');
    else 
        %disp('+right class ');
    end
    
end

%error 7 classes
sumerrors = sum(errors)

prozent = (sumerrors*100)/PICS

%error 2 classes - nature, human
sumerrors_nh = sum(errors_nh)

prozent_nh = (sumerrors_nh*100)/PICS
