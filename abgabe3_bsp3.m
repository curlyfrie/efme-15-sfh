%exercise 3.3 group 15

function abgabe3_bsp3

    global rows;
    global cols;
    
    directory = 'faces';
    D = dir(directory) ; 

    %allocate
    test = zeros(14950,1);
    training = zeros(14950,76);

        disp('Trainingset:');
        j = 1;
        k = 1;
        for i = 3 : size(D, 1)
            name = D(i).name;
            if strcmp(name(length(name)-2:length(name)), 'gif')
                 I_temp = imread (fullfile(directory,name));
                [rows cols] = size(I_temp);

                if (exist('I','var') == 0) 
                   I = zeros(rows*cols,size(D,1)-2); 
                end

                %bild in eine spalte schreiben
                I_temp = double(reshape(I_temp, rows*cols, 1));

%alle bilder ausgeben
%                subplot(8,10,i);
%                viewcolumn(I_temp);
                
                %subject01_normal als testset
                %rest als training
                if (strfind(name, 'subject01_normal'))
                    test(:,k) = I_temp; 
                    k = k+1;
                    
                    figure
                    viewcolumn(I_temp);
                    title('Original')
                    
                else
                    training(:,j) = I_temp; 
                    j = j+1;
                    disp(D(i).name);

                end
            end
        end

    %1. mean image calculation
    mean_img = mean(training,2);
   
    figure
    viewcolumn(mean_img); 
    title('Mean Face');

    %2. A calculation
    % A = training - mean
    
    A = zeros(size(training,1),size(training,2));

    for i = 1 : size(training,2)
        A(:,i) = training(:,i) - mean_img;
    end
    
    figure
    viewcolumn(A(:,1) + mean_img);
    title('Trainings Face 1: A + meanimage');
    
        
    figure('Name','Alle Trainingfaces','NumberTitle','off')
    for i=1:size(training,2)
        subplot(8,10,i);
        viewcolumn(training(:,i));
    end
    
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
    U = normc(U);
    
    figure('Name','Alle Eigenfaces','NumberTitle','off')
    for i=1:size(U,2)
        subplot(8,10,i);
        viewcolumn(U(:,i));
    end
    
    comp = U' * (test - mean_img);
    
    %used components
    usedcomp = 10;
    
    reconstruct =  U(:, 1:usedcomp) * comp(1:usedcomp) + mean_img;
    
    figure
    viewcolumn(reconstruct);
    title('Reconstructed Face')

end

function viewcolumn(image)

    global rows;
    global cols;
    
    colormap(gray(256))
    image_rs = reshape(image, rows, cols);
    imagesc(image_rs);
    axis image;
end

function [eigenvectors, eigenvalues] = eigsort(eigenvectors, eigenvalues)
    
    %diag: there are only values in the diagonal 
    [eigenvalues, index] = sort(diag(eigenvalues), 'descend');
    
    temp = zeros(size(eigenvectors,1), size(eigenvectors,2));
    
    for i=1 : size(index,1) 
       temp(:,i) = eigenvectors(:,index(i)); 
    end
    
    eigenvectors = temp;
end





