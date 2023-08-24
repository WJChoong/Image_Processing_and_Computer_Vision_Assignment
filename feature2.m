% Main code
imageA = imread('D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\20\R2.png'); % Load Diagram A image
imageB = imread('D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\Real\20.png'); % Load Diagram B image
imageA = imresize(imageA, [344, 789]); % Resize to a common size
imageB = imresize(imageB, [344, 789]); % Resize to a common size

% Apply Gaussian smoothing
sigma = 0.4; % Adjust the sigma value for desired smoothing strength
imageA = imgaussfilt(imageA, sigma);

croppedImageA = cropImage(imageA);
croppedImageB = cropImage(imageB);

% Extract features from both images
featuresA = extractFeaturesA(croppedImageA);
featuresB = extractFeaturesB(croppedImageB);

% Compare the extracted features
similarity = compareFeatures(featuresA, featuresB);

% Display the similarity result
threshold = 0.5; % Set a threshold for similarity
if similarity < threshold
    disp('Diagram A and Diagram B have similar features.');
else
    disp('Diagram A and Diagram B do not have similar features.');
end

function featuresA = extractFeaturesA(imageA)
    % Apply necessary image processing techniques to extract features from Diagram A
    % Example: Convert to grayscale, perform spatial filtering, enhance contrast, and detect edges
    grayA = rgb2gray(imageA);
    filteredA = imfilter(grayA, fspecial('gaussian', [5 5], 2));
    enhancedA = imadjust(filteredA, [0.3 0.7], [0 1]);
    edgesA = edge(enhancedA, 'Canny');
    
    featuresA = edgesA; % Using edges as features for demonstration
end

function featuresB = extractFeaturesB(imageB)
    % Apply necessary image processing techniques to extract features from Diagram B
    % Example: Convert to grayscale, perform spatial filtering, enhance contrast, and detect edges
    grayB = rgb2gray(imageB);
    filteredB = imfilter(grayB, fspecial('gaussian', [5 5], 2));
    enhancedB = imadjust(filteredB, [0.3 0.7], [0 1]);
    edgesB = edge(enhancedB, 'Canny');
    
    featuresB = edgesB; % Using edges as features for demonstration
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
    topLeftRow = 250;    % Row index of the top-left corner
    topLeftCol = 30;    % Column index of the top-left corner
    bottomRightRow = 344;% Row index of the bottom-right corner
    bottomRightCol = 100;% Column index of the bottom-right corner
    
    % Crop the image
    croppedImage = originalImage(topLeftRow:bottomRightRow, topLeftCol:bottomRightCol, :);
end