%exercise 3.3 group 15

function abgabe3_bsp3

    directory = 'faces';
    D = dir(directory) ; 

    %allocate
    test = zeros(14950,1);
    training = zeros(14950,69);

        disp('Trainingset:');
        j = 1;
        k = 1;
        for i = 3 : size(D, 1)
            name = D(i).name;
            if strcmp(name(length(name)-2:length(name)), 'png')
                 I_temp = imread (fullfile(directory,name));
                [rows cols] = size(I_temp);

                if (exist('I','var') == 0) 
                   I = zeros(rows*cols,size(D,1)-2); 
                end

                %bild in eine spalte schreiben
                I_temp = double(reshape(I_temp, rows*cols, 1));

                %subject01_normal als testset
                %rest als training
                if (strfind(name, 'subject01_normal'))
                    test(:,k) = I_temp; 
                    k = k+1;
                else
                    training(:,j) = I_temp; 
                    j = j+1;
                    disp(D(i).name);

                end
            end
        end

    %1. mean image calculation
    mean_img = mean(training,2);

    %2. A calculation
    % A = training - mean
    
    A = zeros(size(training,1),size(training,2));

    for i = 1 : size(training,2)
        A(:,i) = training(:,i) - mean_img;
    end
    
    viewcolumn(A(:,1) + mean_img);
    
    %3. covariance matrix
    %dimension is the amount pf pictures, e.g. 69,
    %not the amount of pixels.
    cov = A'*A;
    
    %4. compute the eigenvectors and eigenvalues from A' * A
    [eigenvectors,eigenvalues] = eig(cov);
    
    %5. sort the eigenvectors and eigenvalues
    [eigenvectors,eigenvalues] = eigsort(eigenvectors, eigenvalues);
    
    %6. Transponse Trick: Multiply with A for the eigenvector of A * A'
    U = A * eigenvectors; 
    U = normc(eigenvectors);


end

function viewcolumn(image)

    global rows;
    global cols;
    image_rs = reshape(image, rows, cols);
    imagesc(image_rs);
    colormap(gray)
    axis image;
end

function [eigenvectors, eigenvalues] = eigsort(eigenvectors, eigenvalues)
    
    [eigenvalues, index] = sort(diag(eigenvalues), 'descend');
    
    temp = zeros(size(eigenvectors,1), size(eigenvectors,2));
    
    for i=1 : size(index) 
       temp(:,i) = eigenvectors(:,index(i)); 
    end
    
    eigenvectors = temp;
end







