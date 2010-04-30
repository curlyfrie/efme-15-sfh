imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');

kNN = 209;

% test


eucl = cell(2100,2);
classarray = {};
errors = zeros(2100,kNN);
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

    
     %check if desicion is right
      if (mode([distances{1:kNN,2}])==curclass) 
          disp('right');
      else 
          disp('wrong');
      end


end

sumerrors = zeros(1,kNN);
 for p=1:kNN 
         sumerrors(p) = sum(errors(:,p));
 end



plot(1:kNN,sumerrors*100/2100);
xlabel('kNN')
ylabel('Fehlerquote %')