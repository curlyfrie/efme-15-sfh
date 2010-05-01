%exercise 2.3 group 15

%function abgabe2_bsp3

imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');


classarray = {'BRICKFACE','SKY','FOLIAGE','CEMENT','WINDOW','PATH','GRASS';};

%declaration of data types
PICS = length(imptest.data);
errors = zeros(PICS,1);

mw = cell(7,1);
cv = cell(7,1);
cvd = cell(7,1);

for i=1:7

    temp = impdata.data(1+(i-1)*30:30*i,:);
    
    mw{i} = mean(temp(:, [1 2 6:12  14:16]));
    
    cv{i} = cov(temp(:, [1 2 6:12  14:16]));

    cvd{i} = diag(diag(cov(temp(:,[1 2 6:12  14:16]))));
end

cva = 1/7 * (cv{1} + cv{2} + cv{3} + cv{4} + cv{5} + cv{6} + cv{7});


%iterate through test data
for k=1:PICS
    %iterate through trainigsdata and calculate mahalanobis distance
    
    %mahala = sqrt( (x-mu) * covMatr^-1 * (x-mu)' )
    mahala(1,1) = realmax;
    for l=1:7
       %covarianz
        % mahala_temp = sqrt((imptest.data(k,[1 2 6:12  14:16])-mw{l}) * cv{l}^(-1) * (imptest.data(k,[1 2 6:12  14:16])-mw{l})');
       %covarianz diagonal
        % mahala_temp = sqrt((imptest.data(k,[1 2 6:12  14:16])-mw{l}) * cvd{l}^(-1) * (imptest.data(k,[1 2 6:12  14:16])-mw{l})');
       %covarianz overall 
        mahala_temp = sqrt((imptest.data(k,[1 2 6:12  14:16])-mw{l}) * cva^(-1) * (imptest.data(k,[1 2 6:12  14:16])-mw{l})');
       
        if mahala_temp <  mahala(1,1)
            mahala(1,1) = mahala_temp;
            mahala(1,2) = l;
        end
    end

    % get class of current picture
    [a,curclass] = find(ismember(classarray,imptest.textdata(k))==1);


    if mahala(1,2)~=curclass 
        errors(k)=1;
        disp('-wrong class');
    else 
        disp('+right class ');
    end
end

sumerrors = sum(errors)

prozent = (sumerrors*100)/PICS

