imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');

kNN = 20;


eucl = cell(210,2);
classarray = {};
for k=1:length(imptest.data)
    for l=1:length(impdata.data)
        if k~=l
            eucl{l,1} = sqrt(sum((impdata.data(l,:)-imptest.data(k,:)).^2));
        else
            eucl{l,1} = realmax;
        end

        
        % convert string to number classes
        [a,classindex] = find(ismember(classarray,impdata.textdata(l))==1);
        if length(classindex)<1
            classindex=length(classarray)+1;
            classarray(classindex) = impdata.textdata(l);
        end
        
            
        eucl{l,2} = classindex;

    end
    
    % get class of current picture
    [a,curclass] = find(ismember(classarray,imptest.textdata(k))==1);

    % now sort it
    [distances] = sortrows(eucl);
    
        
    %error test every picture if wrong or right
    %needed for the graph
    for v=1:kNN
        if (mode([distances{1:v,2}])~=curclass) 
            errors(k,v)=1;
        end
    end

    %nature images
    [a,grass] = find(ismember(classarray,'GRASS')==1);
    [a,path] = find(ismember(classarray,'PATH')==1);
    [a,sky] = find(ismember(classarray,'SKY')==1);
    
    %most frequent value for kNN
    mostfrequent = mode([distances{1:kNN,2}]);
    
    % right classification for nature
    if ((mostfrequent==grass || mostfrequent==path || mostfrequent==sky) && (curclass==grass || curclass==path || curclass==sky))
        disp('- nature');
    % right classification for human
    elseif ((mostfrequent~=grass && mostfrequent~=path && mostfrequent~=sky) && (curclass~=grass && curclass~=path && curclass~=sky))
        disp('- human');
    % wrong classification for nature
    elseif (mostfrequent==grass || mostfrequent==path || mostfrequent==sky) 
        disp('- wrong nature classification');
    %wrong classification for human
    else 
        disp('- wrong human classification')
    end
    
       %check if desicion is right
      if (mostfrequent==curclass) 
          disp('right class');
      else 
          disp('wrong class ');
      end


end

sumerrors = zeros(1,20);
 for p=1:kNN 
         sumerrors(p) = sum(errors(:,p));
 end



plot(1:kNN,sumerrors);
xlabel('kNN')
ylabel('Fehlerquote %')