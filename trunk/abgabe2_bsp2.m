%function abgabe2_bsp2

imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');



kNN = 50;


%declaration of data types
PICS = length(imptest.data);
eucl = cell(length(impdata.data),3);
classarray = {};
errors = zeros(PICS,kNN);
errors2classes = zeros(PICS,kNN);

%iterate through test data
for k=1:PICS
    %iterate through trainigsdata and calculate euclid distance
    for l=1:length(impdata.data)

        eucl{l,1} = sqrt(sum((impdata.data(l,:)-imptest.data(k,:)).^2));

        % convert string to number classes (in addition to calculate mode
        [a,classindex] = find(ismember(classarray,impdata.textdata(l))==1);
        if length(classindex)<1
            classindex=length(classarray)+1;
            classarray(classindex) = impdata.textdata(l);
        end
        eucl{l,2} = classindex;
         
        if strcmp( impdata.textdata{l} , 'GRASS') || strcmp( impdata.textdata{l} , 'SKY') || strcmp( impdata.textdata{l} , 'FOLIAGE')
            eucl{l,3} = 1;
        else
            eucl{l,3} = 2;
        end

        if strcmp( imptest.textdata{k} , 'GRASS') || strcmp( imptest.textdata{k} , 'SKY') || strcmp( imptest.textdata{k} , 'FOLIAGE')
            naturehuman = 1;
        else
            naturehuman = 2;
        end
    end

    % get class of current picture
    [a,curclass] = find(ismember(classarray,imptest.textdata(k))==1);

    % now sort it
    [distances] = sortrows(eucl);
    
    
    %error test every picture if wrong or right
    %needed for the graph 
    for v=1:kNN
        if mode([distances{1:v,2}])~=curclass 
            errors(k,v)=1;
        end
        % compare nature-human
        if mode([distances{1:v,3}])~=naturehuman
            errors2classes(k,v)=1;
        end
    end
    
    % ALTERNATIVE CALCULATION OF HUMAN - NATURE CLASSIFICATION

        %  %nature images
        % [a,grass] = find(ismember(classarray,'GRASS')==1);
        % [a,foliage] = find(ismember(classarray,'FOLIAGE')==1);
        % [a,sky] = find(ismember(classarray,'SKY')==1);
        % 
        % 
        % %error test every picture if classification in nature or human went
        % %wrong or wright
        % for v=1:kNN
        %     mostfrequent = mode([distances{1:v,2}]); 
        %     if ((mostfrequent==grass || mostfrequent==foliage || mostfrequent==sky) && (curclass==grass || curclass==foliage || curclass==sky))
        % 
        %     % right classification for human
        %     elseif ((mostfrequent~=grass && mostfrequent~=foliage && mostfrequent~=sky) && (curclass~=grass && curclass~=foliage && curclass~=sky))
        % 
        %     % wrong classification for nature
        %     elseif (mostfrequent==grass || mostfrequent==foliage || mostfrequent==sky) 
        %         errors2classes(k,v)=1;
        %     %wrong classification for human
        %     else 
        %         errors2classes(k,v)=1;
        %     end
        % end

    
    
    %most frequent value for kNN
    mostfrequent = mode([distances{1:kNN,2}]);
    
    % right classification for nature
    if errors2classes(k,kNN) == 0 
       disp('++ right nature/human');
    else
       disp('-- wrong nature/human');
    end
    
   %check if desicion is right
  if (mostfrequent==curclass) 
      disp('+right class');
  else 
      disp('-wrong class ');
  end


end


% calculate graphs and make a wonderful looking plot
sumerrors = zeros(1,kNN);
sum2errors = zeros(1,kNN);
 for p=1:kNN 
         sumerrors(p) = sum(errors(:,p));
         sum2errors(p) = sum(errors2classes(:,p));
 end


 
subplot(2,1,1);
plot(1:kNN,sumerrors*100/PICS);
title('Bildtyp');
xlabel('kNN')
ylabel('Fehlerquote %')

subplot(2,1,2);
plot(1:kNN,sum2errors*100/PICS);
title('Mensch - Natur');
xlabel('kNN')
ylabel('Fehlerquote %')

