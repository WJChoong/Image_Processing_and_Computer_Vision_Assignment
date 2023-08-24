clc

currentFolderPath = pwd;
disp(['Current folder path: ' currentFolderPath]);

% Load the real image
imagePath ='C:\Users\Felicia\OneDrive\Desktop\100.png';
currencyImage = imread(imagePath);

% Input Image
imagePathInput ='C:\Users\Felicia\OneDrive\Desktop\F4.png';
currencyImageInput = imread(imagePathInput);

% Determine the maximum dimensions
maxWidth = max(size(currencyImage, 2), size(currencyImageInput, 2));
maxHeight = max(size(currencyImage, 1), size(currencyImageInput, 1));

% Resize both images to the maximum dimensions
currencyImage = imresize(currencyImage, [maxHeight, maxWidth]);
currencyImageInput = imresize(currencyImageInput, [maxHeight, maxWidth]);

% Define the dimensions of the crop region
cropWidth = 670;   % Specify the width of the crop region
cropHeight = 100;  % Specify the height of the crop region
cropTopOffset = 20; % Specify the offset from the top to adjust cropping
cropRightOffset = 650; % Specify the offset from the right to adjust cropping

% Calculate the coordinates for cropping (top middle)
cropTopLeftX = floor((size(currencyImage, 2) - cropWidth) / 2);
cropTopLeftY = cropTopOffset + 1; % Adjusted to include the top offset
cropBottomRightX = size(currencyImage, 2) - cropRightOffset;
cropBottomRightY = cropTopOffset + cropHeight;

% Calculate the coordinates for cropping (top middle)
cropTopLeftXInput = floor((size(currencyImageInput, 2) - cropWidth) / 2);
cropTopLeftYInput = cropTopOffset + 1; % Adjusted to include the top offset
cropBottomRightXInput = size(currencyImageInput, 2) - cropRightOffset;
cropBottomRightYInput = cropTopOffset + cropHeight;

% Perform cropping
croppedImage = currencyImage(cropTopLeftY:cropBottomRightY, cropTopLeftX:cropBottomRightX, :);
croppedImageInput = currencyImageInput(cropTopLeftYInput:cropBottomRightYInput, cropTopLeftXInput:cropBottomRightXInput, :);

% Create a figure
figure;

% Display the croppedImage on the left side
subplot(1, 2, 1);
imshow(croppedImage);
title('Cropped Image');

% Display the currencyImageFake on the right side
subplot(1, 2, 2);
imshow(croppedImageInput);
title('Input Currency Image');

% Adjust the layout for better spacing
sgtitle('Comparison of Images'); % Add a common title above the subplots


% Use Tesseract to perform OCR on the cropped images
ocrResultCropped = ocr(croppedImage);
ocrResultInput = ocr(croppedImageInput);

% Extract and display the recognized text
recognizedTextCropped = ocrResultCropped.Text;
recognizedTextInput = ocrResultInput.Text;

% Display the extracted text
disp('Extracted Text from Cropped Image:');
disp(recognizedTextCropped);

disp('Extracted Text from Input Image:');
disp(recognizedTextInput);


% Convert recognized texts to lowercase
recognizedTextCropped = lower(recognizedTextCropped);
recognizedTextInput = lower(recognizedTextInput);

% Create a dictionary of unique words
words = unique([strsplit(recognizedTextCropped), strsplit(recognizedTextInput)]);

% Convert recognized texts to word frequency vectors
vectorCropped = createWordFrequencyVector(words, recognizedTextCropped);
vectorInput = createWordFrequencyVector(words, recognizedTextInput);

% Calculate cosine similarity
cosineSimilarity = dot(vectorCropped, vectorInput) / (norm(vectorCropped) * norm(vectorInput));

% Define a threshold for considering the input as fake
cosineThreshold = 0.7; % Adjust as needed

% Compare cosine similarity with the threshold
if cosineSimilarity >= cosineThreshold
    disp('Input Currency is Likely Real');
else
    disp('Input Currency is Likely Fake');
end

function vector = createWordFrequencyVector(words, text)
    wordCounts = zeros(1, numel(words));
    
    % Tokenize the text
    tokens = strsplit(text);
    
    % Count word occurrences
    for i = 1:numel(tokens)
        wordIndex = find(strcmpi(words, tokens{i}));
        if ~isempty(wordIndex)
            wordCounts(wordIndex) = wordCounts(wordIndex) + 1;
        end
    end
    
    vector = wordCounts / sum(wordCounts); % Normalize to get word frequencies
end
