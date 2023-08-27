imageFilePath = 'D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\100\R2.png';
imageFilePath2 = 'D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\100\R2.png';
originalImage = imread(imageFilePath);
cloneImage = imread(imageFilePath2);

originalImage = imresize(originalImage, [344, 789]); % Resize to a common size
cloneImage = imresize(cloneImage, [344, 789]); % Resize to a common size

croppedImage = cropImage(originalImage);
croppedImage2 = cropImage(cloneImage);

croppedImage = imgaussfilt(croppedImage, 1); % Adjust the standard deviation (second argument) as needed
croppedImage2 = imgaussfilt(croppedImage2, 1); % Adjust the standard deviation (second argument) as needed

compareHOGFeatures(croppedImage, croppedImage2);
% Display the original and cropped images
% subplot(1, 2, 1);
% imshow(originalImage);
% title('Original Image');

function croppedImage = cropImage(originalImage)
    % Define the cropping coordinates
    topLeftRow = 1;    % Row index of the top-left corner
    topLeftCol = 30;    % Column index of the top-left corner
    bottomRightRow = 100;% Row index of the bottom-right corner
    bottomRightCol = 200;% Column index of the bottom-right corner
    
    % Crop the image
    croppedImage = originalImage(topLeftRow:bottomRightRow, topLeftCol:bottomRightCol, :);
end

% lower than 0.80 is true
function cosineSim = compareHOGFeatures(image1, image2)
    % Convert the images to grayscale
    grayImage1 = rgb2gray(image1);
    grayImage2 = rgb2gray(image2);

    % Define HOG parameters
    cellSize = [4 4]; % Size of each cell
    numBins = 9;      % Number of histogram bins

    % Compute HOG features for the two images
    hogFeatures1 = extractHOGFeatures(grayImage1, 'CellSize', cellSize, 'NumBins', numBins);
    hogFeatures2 = extractHOGFeatures(grayImage2, 'CellSize', cellSize, 'NumBins', numBins);
    hogFeatures1 = double(hogFeatures1);
    hogFeatures2 = double(hogFeatures2);

    % Compute cosine similarity between the two HOG feature vectors
    cosineSimilarity = dot(hogFeatures1, hogFeatures2) / (norm(hogFeatures1) * norm(hogFeatures2));

    % Display the images
    subplot(1, 2, 1);
    imshow(image1);
    title('Image 1');

    subplot(1, 2, 2);
    imshow(image2);
    title('Image 2');

    % Display the cosine similarity
    disp(['Cosine Similarity: ', num2str(cosineSimilarity)]);
    cosineSim = cosineSimilarity;
end