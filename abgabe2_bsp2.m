imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');

kNN = 20;


eucl = cell(210,2);
classarray = [];
for k=1:length(imptest.data)
    for l=1:length(impdata.data)
        if k~=l
            eucl{l,1} = sqrt(sum((impdata.data(l,:)-imptest.data(k,:)).^2));
        else
            eucl{l,1} = realmax;
        end
        
        % convert string to number classes
        [a,b] = FIND(classarray,impdata.textdata(l));
        break;
       
            classarray
        eucl{l,2} = impdata.textdata(l);

    end
    
    
    
    
    
%     eucl = struct();
% for k=1:length(imptest.data)
%     for l=1:length(impdata.data)
%         if k~=l
%             eucl(l).dist = sqrt(sum((impdata.data(l,:)-imptest.data(k,:)).^2));
%         else
%             eucl(l).dist = realmax;
%         end
%         eucl(l).name = impdata.textdata(l);
%         %eucl{l,2} = impdata.textdata(l);
%         %eucl(l,2) = 1;
%     end
    
    
    % now sort it
    [distances, index] = sort([eucl{:,1}]);
    classes=eucl(index,:);



    %[distances] = sortrows([eucl(]);
    %[y,i]=sort([eucl{:,1}]);
%     for p=1:kNN
%         if (distances(p,2)~=SC(k)) 
%             errors(k,p)=1;
%             distances(p,2);
%             
%           %  sumerrors(p)=sumerrors(p)+1;
%         end
%     end

     %check if desicion is right
      if (mode(classes(1:kNN))==imptest.textdata(k)) 
          disp('right');
      else 
          disp('wrong');
      end

end