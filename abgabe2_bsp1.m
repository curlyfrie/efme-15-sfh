

kNN = 20;

directory = 'MPEG7';
D = dir(directory) ; 
I = cell( 100 , 1 ) ; 



j=1; 


classes = {'apple','bat','Bone','beetle','key'};

for i = 1 : size( D, 1 )
      
    %if D( i ).isdir == 0 && (strncmp( D( i ).name( 1 : 3 ) , 'apple' , 3)|| strncmp( D( i ).name( 1 : 3 ) , 'bat' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'key' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'Bone' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'beetle' , 3))
    
    class=0; 
    for (p=1:size(classes,2)) 
       if D( i ).isdir == 0 && strncmp( D( i ).name( 1 : 3 ) , classes{p} , 3)
            class=p;
            break;
       end
    end
    
    if D( i ).isdir == 0 && class>0 
        

       I_temp = imread (fullfile(directory,D(i).name));
       I{j} = im2bw( I_temp , graythresh ( I_temp ) );
       I{j} = bwlabel(I{j});
       
       
       STATS = regionprops(I{j},'all');
          
       
      % only proceed with the max area
       [area,ind] = max([STATS.Area]);
       perimeter = (STATS(ind).Perimeter);
       majoraxis =  (STATS(ind).MajorAxisLength);
       minoraxis = (STATS(ind).MinorAxisLength);
       
       
       %formfactor:
       formfactor = (4*pi*area) ./ perimeter.^2;
       S(j,1) = formfactor;
     
       %roundness:
       roundness = (4*area) / (pi*majoraxis^2);
       S(j,2) = roundness;
       
       
       %compactness:
       compactness = sqrt(roundness);
       S(j,3) = compactness;
       
       %aspect ratio:
       aspectratio =  majoraxis / minoraxis;
       S(j,4) = aspectratio;
       
       S(j,5) = perimeter;
       S(j,6) = majoraxis;
       S(j,7) = minoraxis;
       
       SC(j) = class;
       
       j = j + 1;
    end
end
j=j-1;




for k=1:j
    for l=1:j
        if k~=l
            eucl(l) = sqrt(sum((S(l,:)-S(k,:)).^2));
        else
            eucl(l) = realmax;
        end
        eucl(l,2) = SC(l);
    end
    
    % now sort it
    [distances] = sortrows(eucl);
    
    for p=1:kNN
        if (distances(p,2)~=eucl(k,2)) 
            errors(k,p)=1;
          %  sumerrors(p)=sumerrors(p)+1;
        end
    end

    % check if desicion is right
    if (mode(distances(1:kNN,2))==eucl(k,2)) 
        disp('right');
    else 
        disp('wrong');
    end
end

 for p=1:kNN 
     sumerrors(p) = sum(errors(:,p))
 end



plot(1:kNN,sumerrors);
xlabel('kNN')
ylabel('Fehlerquote %')
       
