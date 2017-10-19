%% Initialization of all variables

trainLocation = 'faces\trainset\';
testLocation = 'faces\testset\';
destLocation = 'faces\destNC\';
noOfImages = 30181;
imcell = cell(1,noOfImages);
mkdir(destLocation);

%% Reading all the files into a cell array

for i=1:noOfImages
    I = imread([trainLocation int2str(i) '.jpg']);
    resizedGray = imresize(rgb2gray(I), [32 32]);
    imcell{i} = resizedGray;
end

%% Do the SSD comparison and find the closest match and then writing out

for i=1:1
    tempImage = imread([testLocation int2str(i) '.jpg']);
    testImage = imresize(tempImage, [32 32]);
    minNC = -1;
    currentIndex = -1;
    
    for j=1:noOfImages
        trainImage = imcell{j};
        nc = det(normxcorr2(tempImage, trainImage));
        if (nc < minSSD) || (minNC == -1)
            minSSD = nc;
            currentIndex = j;
        end
    end
    
    %Adding color to the Grayscale Image
    trainImage = imread([trainLocation int2str(currentIndex) '.jpg']);
    tempImage = cat(3,tempImage,tempImage,tempImage);
    
    %Converting both the test image and the matched training image to HSV
    hsvtest = rgb2hsv(tempImage) ;
    hsvtrain = rgb2hsv(trainImage) ;
    
    %Copying the saturation and hue values from the training image to the
    %test image
    hsvtest(:,:,1) = hsvtrain(:,:,1);
    hsvtest(:,:,2) = hsvtrain(:,:,2);
    result = hsv2rgb(hsvtest);
    imwrite(result, [destLocation 'result_' int2str(i) '_' int2str(currentIndex) '.jpg'], 'jpg');   
end

%%


