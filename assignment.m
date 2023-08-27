function fakeCurrencyDetectionGui()

    clc
    % Create the main figure
    fig = figure('Position', [100, 100, 400, 400], 'Name', 'Fake Currency Detection GUI', 'NumberTitle', 'off', 'MenuBar', 'none');

    % Create UI components
    browseButton = uicontrol('Style', 'pushbutton', 'String', 'Browse', 'Position', [150, 330, 100, 30], 'Callback', @browseButtonCallback);
    runButton = uicontrol('Style', 'pushbutton', 'String', 'Run', 'Position', [150, 260, 100, 30], 'Callback', @runButtonCallback);
    pathText = uicontrol('Style', 'text', 'Position', [50, 200, 300, 30], 'HorizontalAlignment', 'left');
    resultText = uicontrol('Style', 'text', 'Position', [50, 150, 300, 30], 'HorizontalAlignment', 'center');

     % Create radio buttons
    radioMethod1 = uicontrol('Style', 'radio', 'String', '10', 'Position', [50, 160, 100, 20], 'Tag', 'method1');
    radioMethod2 = uicontrol('Style', 'radio', 'String', '20', 'Position', [150, 160, 100, 20], 'Tag', 'method2');
    radioMethod3 = uicontrol('Style', 'radio', 'String', '50', 'Position', [250, 160, 100, 20], 'Tag', 'method3');
    radioMethod4 = uicontrol('Style', 'radio', 'String', '100', 'Position', [350, 160, 100, 20], 'Tag', 'method4');

    % Initialize variables
    selectedImagePath = '';

    % Callback function for the Browse button
    function browseButtonCallback(~, ~)
        [fileName, filePath] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Select an Image');
        if fileName ~= 0
            selectedImagePath = fullfile(filePath, fileName);
            set(pathText, 'String', selectedImagePath);
            set(resultText, 'String', ''); % Clear previous result message
        end
    end

    % Callback function for the Run button
    function runButtonCallback(~, ~)
        if isempty(selectedImagePath)
            msgbox('Please select an image first.', 'Error', 'error');
        else
            % 
            method = getSelectedMethod(); % Get the selected method
            % Perform fake currency detection using the 6 functions
            result = performFakeCurrencyDetection(selectedImagePath, method);        
            
            if result
                msgbox('The image is detected as real currency!', 'Success');
            else
                msgbox('Please select an image first.', 'Error', 'error');
            end

            %set(resultText, 'String', resultMessage);
        end
    end

    % Get the selected detection method
    function method = getSelectedMethod()
        if get(radioMethod1, 'Value')
            method = '1';
        elseif get(radioMethod2, 'Value')
            method = '2';
        elseif get(radioMethod3, 'Value')
            method = '3';
        elseif get(radioMethod4, 'Value')
            method = '4';
        else
            method = '0'; 
        end
    end

    % Function to perform fake currency detection using 6 features
    function result = performFakeCurrencyDetection(imagePath, method)
        result = true;
        if method == '0'
            msgbox('Please select a currency first.', 'Error', 'error');
        end
    
        if ~checkFeature1(imagePath, method) || ~checkFeature2(imagePath, method) || ...
           ~checkFeature3(imagePath, method) || ~checkFeature4(imagePath, method) || ...
           ~checkFeature5(imagePath, method) || ~checkFeature6(imagePath, method)
            result = false; 
        end
    end

    % Placeholder functions for fake currency detection features
    function result = checkFeature1(imagePath, method)
        selectedMethod = getSelectedMethod();
        fprintf('Selected Method: %s\n', method);
        result = true;
    end

    function result = checkFeature2(imagePath, method)
        % Load the input image
        ImageInput = imread(imagePath);
    
        % Define the dimensions of the cropped region
        cropWidth = size(ImageInput, 2) / 2;  % Keep half of the width
        cropHeight = size(ImageInput, 1) / 4;  % Keep the top quarter of the height
    
        % Calculate the top left corner coordinates for cropping
        cropTopLeftX = floor((size(ImageInput, 2) - cropWidth) / 2) + 1;
        cropTopLeftY = 1;
    
        % Calculate the bottom right corner coordinates for cropping
        cropBottomRightX = cropTopLeftX + cropWidth - 1;
        cropBottomRightY = cropTopLeftY + cropHeight - 1;
    
        % Perform cropping
        croppedTopMiddleImage = ImageInput(cropTopLeftY:cropBottomRightY, cropTopLeftX:cropBottomRightX, :);
    
        % Enhance the input image to improve OCR accuracy
        enhancedImageInput = enhanceImage(croppedTopMiddleImage);
    
        % Use Tesseract to perform OCR on the enhanced image
        ocrResultInput = ocr(enhancedImageInput, 'TextLayout', 'Block', 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    
        % Extract and display the recognized text
        recognizedTextInput = ocrResultInput.Text;
    
        % Remove spaces and newline characters from recognized text
        recognizedTextInputProcessed = strrep(recognizedTextInput, ' ', '');
        recognizedTextInputProcessed = strrep(recognizedTextInputProcessed, newline, '');
    
        disp('Extracted Text from Input Image:');
        disp(recognizedTextInputProcessed);
    
        % Convert recognized text to uppercase
        recognizedTextInputUpper = upper(recognizedTextInputProcessed);
    
        % Define the target texts to check for
        targetTexts = 'BANKNEGARAMALAYSIA';
    
        % Check if any of the target texts are present in the recognized text
        isTargetPresentInput = any(contains(recognizedTextInputUpper, targetTexts));
    
        % Determine if the currency is real or fake based on target text presence
        if isTargetPresentInput
            disp('Real Currency: Target text detected in input image.');
            result = true;
        else
            disp('Fake Currency: Target text not detected in input image.');
            result = false;
        end
        
        result = true;
    end

    
    function result = checkFeature3(imagePath, method)
        checkImageNum = '';
        if method == '1'
            checkImageNum = '10';
        elseif method == '2'
            checkImageNum = '20';
        elseif method == '3'
            checkImageNum = '50';
        elseif method == '4'
            checkImageNum = '100';
        end
        checkImagePath = ['D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\Real\' checkImageNum '.png'];
        
        % import image
        importedImage = imread(imagePath);
        checkImage = imread(checkImagePath);

        % resize image
        importedImage = imresize(importedImage, [344, 789]);
        checkImage = imresize(checkImage, [344, 789]);
        
        % crop image
        croppedImportedImage = cropImage(importedImage, 1, 30, 100, 200);
        croppedCheckImage = cropImage(checkImage, 1, 30, 100, 200);

        % deblur image
        croppedImportedImage = imgaussfilt(croppedImportedImage, 1); 
        croppedCheckImage = imgaussfilt(croppedCheckImage, 1);
        
        % compare similarity
        cosineSimilarity = compareHOGFeatures(croppedImportedImage, croppedCheckImage);

        if cosineSimilarity > 0.6
            result = true;            
        else
            result = false;
        end
    end

    function result = checkFeature4(imagePath, method)
        checkImageNum = '';
        if method == '1'
            checkImageNum = '10';
        elseif method == '2'
            checkImageNum = '20';
        elseif method == '3'
            checkImageNum = '50';
        elseif method == '4'
            checkImageNum = '100';
        end
        checkImagePath = ['D:\GitHub\Image_Processing_and_Computer_Vision_Assignment\Currency\Real\' checkImageNum '.png'];
        
        importedImage = imread(imagePath);
        checkImage = imread(checkImagePath);

        % resize the image
        imageA = imresize(importedImage, [344, 789]); % Resize to a common size
        imageB = imresize(checkImage, [344, 789]); % Resize to a common size

        % crop the image
        croppedImageA = cropImage(imageA, 270, 35, 344, 100);
        croppedImageB = cropImage(imageB, 270, 35, 344, 100);

        % enhance the feature and edges
        enhancedImageA = enhanceFeaturesAndEdges(croppedImageA);
        enhancedImageB = enhanceFeaturesAndEdges(croppedImageB);

        % apply smoothing
        smoothenImageA = imgaussfilt(enhancedImageA, 1);
        smoothenImageB = imgaussfilt(enhancedImageB, 1);    
        
        % Extract features from both images
        featuresA = extractFeatures(smoothenImageA);
        featuresB = extractFeatures(smoothenImageB);
        
        % Compare the extracted features
        similarity = compareFeatures(featuresA, featuresB);
        
        % Display the similarity result
        if similarity > 0.45
            result = true;
        else
            result = false;
        end
    end

    function result = checkFeature5(imagePath, method)
        selectedMethod = getSelectedMethod();
        fprintf('Selected Method: %s\n', selectedMethod);
        result = true;
    end

    function result = checkFeature6(imagePath, method)
        selectedMethod = getSelectedMethod();
        fprintf('Selected Method: %s\n', selectedMethod);
        result = true;
    end



    function enhancedImage = enhanceImage(inputImage)
        % Denoise the image using Gaussian filter
        denoisedImage = imgaussfilt(inputImage, 0.3);
        
        % Assign the enhanced image
        enhancedImage = denoisedImage;
    end

end

function croppedImage = cropImage(originalImage, topLeftRow, topLeftCol, bottomRightRow, bottomRightCol)
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

    % Display the cosine similarity
    cosineSim = cosineSimilarity;
end

function features = extractFeatures(image)
    gray = rgb2gray(image);
    filtered = imfilter(gray, fspecial('gaussian', [5 5], 2));
    enhanced = imadjust(filtered, [0.3 0.7], [0 1]);
    edges = edge(enhanced, 'Canny');
    
    features = edges;
end

function similarity = compareFeatures(featuresA, featuresB)    
    % Count the number of matching edge pixels
    matchingPixels = sum(featuresA & featuresB);
    
    % Normalize the count by the total number of edge pixels
    totalEdgePixels = sum(featuresA | featuresB);
    similarityRatio = matchingPixels / totalEdgePixels;
    similarity = similarityRatio;
end

function sharpenedImage = enhanceFeaturesAndEdges(inputImage)
    % Apply unsharp masking to enhance features and edges
    blurredImage = imgaussfilt(inputImage, 2);
    highPassImage = inputImage - blurredImage;  
    sharpeningAmount = 1.5; 
    sharpenedImage = inputImage + sharpeningAmount * highPassImage;
    
    % Apply color enhancement to further improve the result
    contrast_range = [0.1 0.9];
    enhancedImage = imadjust(sharpenedImage, contrast_range, [0 1]);
    sharpenedImage = enhancedImage;
end