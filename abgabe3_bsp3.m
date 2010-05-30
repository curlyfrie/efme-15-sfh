%exercise 3.3 group 15

function abgabe3_bsp3

clc;
close all;

    global rows;
    global cols;
    
    directory = 'faces';
    D = dir(directory);

    %allocate
    test = zeros(14950,1);
    
    %all faces - including own faces
    %testset: subject01_normal
    training_all = zeros(14950,76);
    
        disp('Trainingsset:');
        j = 1;
        k = 1;
        
        for i=3 : size(D, 1)
            name = D(i).name;
            if strcmp(name(length(name)-2:length(name)), 'gif')
                
                I_temp = imread (fullfile(directory,name));
                [rows cols] = size(I_temp);

                %bild in eine spalte schreiben
                I_temp = double(reshape(I_temp, rows*cols, 1));

%alle bilder ausgeben
%  figure('Name','All Facees','NumberTitle','off')
%                subplot(8,10,i);
%                viewcolumn(I_temp);
                
                %subject01_normal als testset
                %rest als training
                              
                if (strfind(name, 'subject01_normal'))
                    test(:,k) = I_temp; 
                    k = k+1;
                    
%                     figure
%                     viewcolumn(I_temp);
%                     title('Original')
                    
                else
                    training_all(:,j) = I_temp; 
                    j = j+1;
                    disp(D(i).name);

                end
            end
        end
            
    %trainingsset without own faces, testset: subject01_normal
    training = training_all(:,1:69);
        
        
    %1. mean image calculation
    mean_img = mean(training,2);
    mean_img_all = mean(training_all,2);
   
    figure('Name','Mean Face','NumberTitle','off')
    viewcolumn(mean_img); 
    
    figure('Name','Mean Face - with own faces','NumberTitle','off')
    viewcolumn(mean_img_all); 

    %2. A calculation
    % A = training - mean
    
    A = zeros(size(training,1),size(training,2));
    A_all = zeros(size(training_all,1),size(training_all,2));
     
    for i = 1 : size(training,2)
        A(:,i) = training(:,i) - mean_img;
    end
    
    for i = 1 : size(training_all,2)
        A_all(:,i) = training_all(:,i) - mean_img_all;
    end

    
    figure('Name','Trainings Face 1: A + meanimage','NumberTitle','off')
    viewcolumn(A(:,1) + mean_img);
    
        
    figure('Name','All Trainingfaces','NumberTitle','off')
    for i=1:size(training,2)
        subplot(8,10,i);
        viewcolumn(training(:,i));
    end
    
        figure('Name','All Trainingfaces + own','NumberTitle','off')
    for i=1:size(training_all,2)
        subplot(8,10,i);
        viewcolumn(training_all(:,i));
    end

% test calculation with A*A'
% much slower => dimension is the amount of pixels, i.e. 14950 x 14950,
% in this case
%    disp(clock());
%    cov = A*A';
%    disp(clock()); 
    
    %3. covariance matrix
    %dimension is the amount of pictures, e.g. 69,
    %not the amount of pixels.
    cov = A' * A;
    cov_all = A_all' * A_all;
    
    %4. compute the eigenvectors and eigenvalues from A' * A
    [eigenvectors,eigenvalues] = eig(cov);
    [eigenvectors_all,eigenvalues_all] = eig(cov_all);
    
    %5. sort the eigenvectors and eigenvalues
    [eigenvectorsSort,eigenvaluesSort] = eigsort(eigenvectors, eigenvalues);
    [eigenvectors_allSort,eigenvalues_allSort] = eigsort(eigenvectors_all, eigenvalues_all);
    
    %6. Transponse Trick: Multiply with A for the eigenvector of A * A'
    U = A * eigenvectorsSort; 
    U = normc(U);
    
    U_all = A_all * eigenvectors_allSort; 
    U_all = normc(U_all);
        
    figure('Name','All Eigenfaces','NumberTitle','off')
    for i=1:size(U,2)
        subplot(8,10,i);
        viewcolumn(U(:,i));
    end
    
    figure('Name','All Eigenfaces + own faces','NumberTitle','off')
    for i=1:size(U_all,2)
        subplot(8,10,i);
        viewcolumn(U_all(:,i));
    end
    
%Discussion:
%%%%%%%%%%%%
    
    %make a view different reconstruction
    %1. reconstruction of a face from trainingsset
    %2. reconstruction of the test face (not in the trainingsset)
    %3. Bonus - reconstruction the own face (not in trainingsset)
    %4. Bonus - reconstruction the own face (is in trainingsset)
    
% % % % %    
% % % % %   Reconstruction 1 of a face from trainingsset
% % % % %

    %calculate the coefficients
    comp = coeff(U, training(:,15), mean_img);
    
    %used components for reconstruction
    usedcomp = 10;
    %reconstruction face
    recface =  reconstruction(U,comp, mean_img, usedcomp);
    
    figure('Name',['1. Reconstructed Face using ',num2str(usedcomp),' components'],'NumberTitle','off')
    viewcolumn(recface);
    
    %used components for animated reconstruction
    
    usedcomp = 65;
    %animation
    animate(U, comp, mean_img, usedcomp, '1. Reconstruction of a face from trainingsset');
    
    figure('Name','Original Face - Reconstruction 1','NumberTitle','off')
    viewcolumn(training(:,15));
    
     
% % % % %    
% % % % %   Reconstruction 2 of the test face (not in the trainingsset)
% % % % %

    %calculate the coefficients
    
    comp = coeff(U, test, mean_img);
    
    %used components for reconstruction
    usedcomp = 10;
    %reconstruction face
    recface =  reconstruction(U,comp, mean_img, usedcomp);
    
    figure('Name',['2. Reconstructed Face using ',num2str(usedcomp),' components'],'NumberTitle','off')
    viewcolumn(recface);
    
    %used components for animated reconstruction

    usedcomp = 65;
    %animation
    animate(U, comp, mean_img, usedcomp, '2. Reconstruction of the test face (not in the trainingsset)');
    
    figure('Name','Original Face - Reconstruction 2','NumberTitle','off')
    viewcolumn(test);
    
  
% % % % %    
% % % % %   Reconstruction 3 the own face (not in trainingsset)
% % % % %

    %calculate the coefficients
   
    comp = coeff(U, training_all(:,74), mean_img);
    
    %used components for reconstruction

    usedcomp = 10;
    %reconstruction face
    recface =  reconstruction(U,comp, mean_img, usedcomp);
    
    figure('Name',['3. Reconstructed Face using ',num2str(usedcomp),' components'],'NumberTitle','off')
    viewcolumn(recface);
    
    
    %used components for animated reconstruction
   
    usedcomp = 65;
    %animation
    animate(U, comp, mean_img, usedcomp, '3. Reconstruction the own face (not in trainingsset_all)');
    
    figure('Name','Original Face - Reconstruction 3','NumberTitle','off')
    viewcolumn(training_all(:,74));
  
    
% % % % %    
% % % % %   Reconstruction 4 the own face (is in trainingsset)
% % % % %
    
    %calculate the coefficients
    
    comp_all = coeff(U_all, training_all(:,74), mean_img_all);
    
    %used components for reconstruction
    usedcomp_all = 10;
    %reconstruction face
    recface_all =  reconstruction(U_all,comp_all, mean_img_all, usedcomp_all);
    
    figure('Name',['4. Reconstructed Face using ',num2str(usedcomp_all),' components'],'NumberTitle','off')
    viewcolumn(recface_all);
    
    
    %used components for animated reconstruction
  
    usedcomp_all = 70;
    %animation
    animate(U_all, comp_all, mean_img_all, usedcomp_all, '4. Reconstruction the own face (is in trainingsset_all)');
    
    figure('Name','Original Face - Reconstruction 4','NumberTitle','off')
    viewcolumn(training_all(:,74));
   
end



% viewcolumn
%   use: to view a face corresponding to a column of a matrix
%   parameter: image = matrix column
% % % % % % % % % % % % % 
function viewcolumn(image)

    global rows;
    global cols;
    
    colormap(gray(256))
    image_rs = reshape(image, rows, cols);
    imagesc(image_rs);
    axis image;
end

% eigsort
%   use: sort the eigenvectors and eigenvalues in order
%        of largest to smallest eigenvalue.
%   parameter: eigenvectors = eigenvectors
%              eigenvalues = eigenvalues
%   return:    eigenvectorsSort = sorted eigenvectors
%              eigenvaluesSort = sortetd eigenvalues
% % % % % % % % % % % % % 
function [eigenvectorsSort, eigenvaluesSort] = eigsort(eigenvectors, eigenvalues)
    
    %diag: there are only values in the diagonal 
    [eigenvaluesSort, index] = sort(diag(eigenvalues), 'descend');
    
%    eigenvaluesSort = diag(eigenvalues);
    
    temp = zeros(size(eigenvectors,1), size(eigenvectors,2));
    
    for i=1 : size(index,1) 
       temp(:,i) = eigenvectors(:,index(i)); 
    end
    
    eigenvectorsSort = temp;
end

% coeff
%   use: calculates the coefficients of expansion of an image
%        in terms of the eigenfaces
%   parameter: U = matrix of eigenfaces
%              test = test face
%              mean_img = mean face
%   return: comp = vector of principal components
% % % % % % % % % % % % % 
function[comp] = coeff(U, test, mean_img)
    comp = U' * (test - mean_img);
end

% reconstruction
%   use: reconstructs a face using a limited number of components
%   parameter: U = matrix of eigenfaces
%              comp = vector of principal components
%              mean_img = mean face
%              usedcomp = how many compontents should be used
%   return: recface = reconstructed face
% % % % % % % % % % % % % 
function[recface] = reconstruction(U,comp, mean_img, usedcomp)
    recface = U(:, 1:usedcomp) * comp(1:usedcomp) + mean_img;
end

% reconstruction
%   use: procedure which animates the reconstruction of the face
%   parameter: U = matrix of eigenfaces
%              comp = vector of principal components
%              mean_img = mean face
%              usedcomp = how many compontents should be used
%              name = name of the figure
function animate(U, comp, mean_img, usedcomp, name)
    
figure('Name',['Animated Reconstruction (pause = 0,1) ', name],'NumberTitle','off')

disp('Animated Reconstruction - Progress:');

    for i=1 : usedcomp   
        viewcolumn(reconstruction(U,comp, mean_img, i));
        pause(0.1)
        disp([num2str(i), ' von ', num2str(usedcomp)])
    end
end


