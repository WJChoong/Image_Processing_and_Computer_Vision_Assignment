% Main code
imageA = imread('D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\100\R2.png'); % Load Diagram A image
imageB = imread('D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\Real\100.png'); % Load Diagram B image
imageA = imresize(imageA, [344, 789]); % Resize to a common size
imageB = imresize(imageB, [344, 789]); % Resize to a common size

% Extract features from both images
% imageA = extractEdges(smoothenImageA);
% imageB = extractEdges(smoothenImageB);

croppedImageA = cropImage(imageA);
croppedImageB = cropImage(imageB);

enhancedImageA = enhanceFeaturesAndEdges(croppedImageA);
enhancedImageB = enhanceFeaturesAndEdges(croppedImageB);

%enhancedImageA = enhanceImageFeatures(croppedImageA);
%enhancedImageB = enhanceImageFeatures(croppedImageB);

smoothenImageA = imgaussfilt(enhancedImageA, 1);
smoothenImageB = imgaussfilt(enhancedImageB, 1);

featuresA = extractEdges(smoothenImageA);
featuresB = extractEdges(smoothenImageB);

subplot(1, 2, 1);
imshow(featuresA);
title('Image 1');

subplot(1, 2, 2);
imshow(featuresB);
title('Image 2');

% Compare the extracted features
similarity = compareFeatures(featuresA, featuresB);

% Display the similarity result
threshold = 0.5; % Set a threshold for similarity
if similarity < threshold
    disp('Diagram A and Diagram B have similar features.');
else
    disp('Diagram A and Diagram B do not have similar features.');
end

function similarity = compareFeatures(featuresA, featuresB)
    % Compare the extracted features of Diagram A and Diagram B
    % Example: Compute the normalized correlation coefficient as similarity measure
    %correlation = corr2(featuresA, featuresB);
    %similarity = correlation;

    % Compare the extracted features of Diagram A and Diagram B
    
    % Count the number of matching edge pixels
    matchingPixels = sum(featuresA & featuresB);
    
    % Normalize the count by the total number of edge pixels
    totalEdgePixels = sum(featuresA | featuresB);
    similarityRatio = matchingPixels / totalEdgePixels;
    fprintf('Similarity Ratio: %.4f\n', similarityRatio);
    similarity = similarityRatio;
end

function croppedImage = cropImage(originalImage)
    % Define the cropping coordinates
    topLeftRow = 270;    % Row index of the top-left corner
    topLeftCol = 35;    % Column index of the top-left corner
    bottomRightRow = 344;% Row index of the bottom-right corner
    bottomRightCol = 100;% Column index of the bottom-right corner
    
    % Crop the image
    croppedImage = originalImage(topLeftRow:bottomRightRow, topLeftCol:bottomRightCol, :);
end

function sharpenedImage = enhanceFeaturesAndEdges(inputImage)
    % Apply unsharp masking to enhance features and edges
    blurredImage = imgaussfilt(inputImage, 2); % Apply Gaussian blur
    highPassImage = inputImage - blurredImage;  % High-pass filter
    sharpeningAmount = 1.5; % Adjust the sharpening amount as needed
    sharpenedImage = inputImage + sharpeningAmount * highPassImage;
    
    % Apply color enhancement to further improve the result
    contrast_range = [0.1 0.9]; % Adjust contrast range for better visibility
    enhancedImage = imadjust(sharpenedImage, contrast_range, [0 1]);
    sharpenedImage = enhancedImage;
end

function edgesImage = extractEdges(image)
    % Convert the image to grayscale
    grayImage = rgb2gray(image);
    
    % Apply Canny edge detection
    edges = edge(grayImage, 'Canny');
    
    % Return the edges image
    edgesImage = edges;
end


