imageFilePath = 'D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\Real\10.png';
imageFilePath2 = 'D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\Real\50.jpg';
originalImage = imread(imageFilePath);
cloneImage = imread(imageFilePath2);
croppedImage = cropImage(originalImage);
croppedImage2 = cropImage(cloneImage);
compareHOGFeatures(croppedImage, croppedImage2);
% Display the original and cropped images
%subplot(1, 2, 1);
%imshow(originalImage);
%title('Original Image');

function croppedImage = cropImage(originalImage)
    % Define the cropping coordinates
    topLeftRow = 1;    % Row index of the top-left corner
    topLeftCol = 150;    % Column index of the top-left corner
    bottomRightRow = 200;% Row index of the bottom-right corner
    bottomRightCol = 420;% Column index of the bottom-right corner
    
    % Crop the image
    croppedImage = originalImage(topLeftRow:bottomRightRow, topLeftCol:bottomRightCol, :);
end

% lower than 0.70 is false
function compareHOGFeatures(image1, image2)
    % Convert the images to grayscale
    grayImage1 = rgb2gray(image1);
    grayImage2 = rgb2gray(image2);

    % Define HOG parameters
    cellSize = [4 4]; % Size of each cell
    numBins = 9;      % Number of histogram bins

    % Compute HOG features for the two images
    hogFeatures1 = extractHOGFeatures(grayImage1, 'CellSize', cellSize, 'NumBins', numBins);
    hogFeatures2 = extractHOGFeatures(grayImage2, 'CellSize', cellSize, 'NumBins', numBins);

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
end
