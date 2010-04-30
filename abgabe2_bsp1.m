%exercise 2.1 group 15

kNN = 99;

PICS = 100;
FEATURES = 7;

directory = 'MPEG7';
D = dir(directory) ; 
I = cell( PICS , 1 ) ; 


classes = {'apple','bat','Bone','beetle','key'};

S = zeros(PICS, FEATURES);
SC = zeros(1,PICS);
j=1; 


%load pictures and create feature vector
for i = 1 : size( D, 1 )
    class=0; 
    for p=1:size(classes,2) 
       %check if filename is in classes
       %class strings converted into integer (e.g. apple = 1, bat = 2,...)
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
      
      % create feature vector S
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
       
       
       %class vector
       SC(j) = class;
       
       j = j + 1;
    end
end
j=j-1;


%leave-one-out cross validation
%with euclidic distance
errors = zeros(PICS,kNN);
eucl = zeros(PICS,2);
for k=1:j
    for l=1:j
        if k~=l
            eucl(l) = sqrt(sum((S(l,:)-S(k,:)).^2));
        else
            eucl(l) = realmax;
        end
        %write class into eucl 2nd dim to know what kind of pic it is
        eucl(l,2) = SC(l);
    end
    
    % now sort it, the pics with the shortest distance first
    [distances] = sortrows(eucl);
    
    %error test, test if decision is right for kNN = 1 - kNN
    %eucl(k,2) is the class of the test pic and
    %mode(distance..) returns most frequent class
    %if they equal error = 0, else error = 1
    %needed for the graph
    for v=1:kNN
        if (mode(distances(1:v,2))~=eucl(k,2)) 
            errors(k,v)=1;
        end
    end

    % check if desicion is right
    % mode returns the commonest picture class
    % if that is the actual class => right
    if (mode(distances(1:kNN,2))==eucl(k,2)) 
        disp('right');
    else 
        disp('wrong');
    end
end

%sum errors of all the pics for the related kNN value
sumerrors = zeros(1,kNN);
 for p=1:kNN 
         sumerrors(p) = sum(errors(:,p));
 end


%errorrate is already in percentage (100 pics)
%plot rate form 1-kNN
plot(1:kNN,sumerrors);
xlabel('kNN')
ylabel('Fehlerquote %')
       
