function [] = featureextractor3000 ()


directory = 'MPEG7';
D = dir(directory) ; 
I = cell( 100 , 1 ) ; 

% global P;
% P = cell( 100 , 1 ) ; 

j=1; 
       S = zeros(20,4);

for i = 1 : size( D, 1 )
      
    if D( i ).isdir == 0 && (strncmp( D( i ).name( 1 : 3 ) , 'apple' , 3)|| strncmp( D( i ).name( 1 : 3 ) , 'bat' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'key' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'Bone' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'beetle' , 3))
     
       I_temp = imread (fullfile(directory,D(i).name));
       I{j} = im2bw( I_temp , graythresh ( I_temp ) );
       I{j} = bwlabel(I{j});
       
       
       STATS = regionprops(I{j},'all');
%        P{j} = STATS;
       
       
      % only proceed with the max area
       [area,ind] = max([STATS.Area]);
       perimeter = (STATS(ind).Perimeter);
       majoraxis =  (STATS(ind).MajorAxisLength);
       minoraxis = (STATS(ind).MinorAxisLength);
       
       
       % ignore blobs < 30
       %STATS = STATS([STATS.Area] > 30 );
       % STATS = sort([STATS.Area],1)
       
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
       
       %orientation solidity
       %convexity = STATS.Perime
       
       %position, orientation and scale invariant?
       
       
       % apple
       if STATS(ind).Solidity >= 0.8846 && STATS(ind).Solidity <= 0.9702
           disp(strcat('Ich bin ein Apfel -> ',D(i).name))
           %o=o+1
       % bone
       elseif roundness >= 0.0775 && roundness <= 0.1547
            disp(strcat('Ich bin eine Bohne, joke, ich bin ein Knochen -> ',D(i).name))
       % beetle
       elseif formfactor >= 0.0338 && formfactor <= 0.1083 
            disp(strcat('Ich bin ein Käfer -> ',D(i).name))
       %bat
       elseif formfactor >= 0.1333 && formfactor <= 0.2854
            disp(strcat('Ich bin eine Fledermaus -> ',D(i).name))
       %key
       elseif compactness >= 0.4707 && compactness <= 0.6658 && formfactor >= 0.3625 && formfactor <= 0.4864 
            disp(strcat('Ich bin ein Schlüssel -> ',D(i).name))
       else
            disp(strcat('nicht erkannt -> ',D(i).name))
       end
       
       
       j = j +1;
    end
end

% 
% min (S(:,1))
% max (S(:,1))
% min (S(:,2))
% max (S(:,2))
% min (S(:,3))
% max (S(:,3))
% min (S(:,4))
% max (S(:,4))
% 
% 
% 
% Formfaktor, Compactness, Roundness, Aspect Ratio, Solidtiy  ist invariant gegen:
% - Skalierung
% - Translation
% - Rotation
% 
% Orientation ist invariant gegen:
% - Skalierung
% - Translation




