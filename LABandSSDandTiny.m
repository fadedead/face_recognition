%% Initialization of all variables

trainLocation = 'faces\trainset\';
testLocation = 'faces\testset\';
destLocation = 'faces\destLAB\';
noOfImages = 30181;
imcell = cell(1,noOfImages);
mkdir(destLocation);
versaform = makecform('lab2srgb');
viceform = makecform('srgb2lab');

%% Reading all the files into a cell array

for i=1:noOfImages
    I = imread([trainLocation int2str(i) '.jpg']);
    resizedGray = imresize(rgb2gray(I), [32 32]);
    imcell{i} = resizedGray;
end

%% Do the SSD comparison and find the closest match and then writing out

for i=1:5
    tempImage = imread([testLocation int2str(i) '.jpg']);
    testImage = imresize(tempImage, [32 32]);
    minSSD = -1;
    currentIndex = -1;
    
    for j=1:noOfImages
        trainImage = imcell{j};
        ssd = sum((trainImage(:)-testImage(:)).^2);
        if (ssd < minSSD) || (minSSD == -1)
            minSSD = ssd;
            currentIndex = j;
        end
    end
    
    %Adding color to the Grayscale Image
    trainImage = imread([trainLocation int2str(currentIndex) '.jpg']);
    tempImage = cat(3,tempImage,tempImage,tempImage);
    
    %Converting both the test image and the matched training image to HSV
  
    lab_test = applycform(tempImage,viceform);
    lab_train = applycform(trainImage,viceform);
    
    %Copying the color from the training image to the test image using
    %l*a*b
    lab_test(:,:,2) = lab_train(:,:,2);
    lab_test(:,:,3) = lab_train(:,:,3);
    result = applycform(lab_test,versaform);
    imwrite(result, [destLocation 'result_' int2str(i) '_' int2str(currentIndex) '.jpg'], 'jpg');   
end

%%
