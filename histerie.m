function [] = histerie ()


img = imread('walter2.jpg');

ind = 1;
blocks = cell(256,1);

%block groesse berechnen
bsize_col = floor(size(img,2)/16);
bsize_row = floor(size(img,1)/16);
for i=1:16
    for j=1:16
        %matrix des blocks auslesen
        blocks{ind} = img(((i-1)*bsize_row)+1:i*bsize_row, ((j-1)*bsize_col)+1:j*bsize_col);
        ind=ind+1;
    end
end

for i=1:6
    subplot(6,1,i);
    imhist(blocks{i});
end

    
 