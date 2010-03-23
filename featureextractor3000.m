function [] = featureextractor3000 ()


directory = 'MPEG7';
D = dir(directory) ; 
I = cell( 20 , 1 ) ; 

P = cell(100,1);

j=1; 

for i = 1 : size( D, 1 )
   
      
    if D( i ).isdir == 0 && (strncmp( D( i ).name( 1 : 3 ) , 'apple' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'bat' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'bird' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'Bone' , 3) || strncmp( D( i ).name( 1 : 3 ) , 'beetle' , 3))
     
       I_temp = imread (fullfile(directory,D(i).name))  ;
       I{j} = im2bw( I_temp , graythresh ( I_temp ) ) ;
       I{j} = bwlabel(I{j});
       
       
       STATS = regionprops(I{j},'all');
       P{j} = STATS
       j = j +1;
    end
end






