%exercise 3.3 group 15

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

%mean image berechnen
mean = mean(training,2);

% A berechnen
% A = training - mean

A = zeros(size(training,1),size(training,2));

for i = 1 : size(training,2)
    A(:,i) = training(:,i) - mean;
end












