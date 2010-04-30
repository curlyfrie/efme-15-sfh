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
    

    % now sort it
    [distances, index] = sort([eucl{:,1}]);
    classes=eucl(index,:);
        
%     for p=1:kNN
%         if (distances(p,2)~=SC(k)) 
%             errors(k,p)=1;
%             distances(p,2);
%             
%           %  sumerrors(p)=sumerrors(p)+1;
%         end
%     end

     %check if desicion is right

      if (mode([classes{1:kNN,2}])==eucl{k,2}) 
          disp('right');
      else 
          disp('wrong');
      end
      break;

end