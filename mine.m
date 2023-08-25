clc

currentFolderPath = pwd;
disp(['Current folder path: ' currentFolderPath]);

% Load the real image
imagePath ='C:\Users\Felicia\OneDrive\Desktop\Currency\Real\10.png';
currencyImage = imread(imagePath);

% Input Image
imagePathInput ='C:\Users\Felicia\OneDrive\Desktop\Currency\10\F2.png';
currencyImageInput = imread(imagePathInput);

% Determine the maximum dimensions
maxWidth = max(size(currencyImage, 2), size(currencyImageInput, 2));
maxHeight = max(size(currencyImage, 1), size(currencyImageInput, 1));

% Resize both images to the maximum dimensions
currencyImage = imresize(currencyImage, [maxHeight, maxWidth]);
currencyImageInput = imresize(currencyImageInput, [maxHeight, maxWidth]);


option = "10"; 


if option == "100"
    % Define the dimensions of the crop region
    cropWidth = 1000;    % Specify the width of the crop region
    cropHeight = 100;    % Specify the height of the crop region
    cropTopOffset = 20;  % Specify the offset from the top to adjust cropping
    cropLeftOffset = 150; % Specify the offset from the left to adjust cropping
    cropRightOffset = 690;% Specify the offset from the right to adjust cropping

elseif option == "50"
    % Define the dimensions of the crop region
    cropWidth = maxWidth / 2;    % Specify the width of the crop region
    cropHeight = maxHeight / 4;  % Specify the height of the crop region
    cropTopOffset = 15;  % Specify the offset from the top to adjust cropping
    cropLeftOffset = 150; % Specify the offset from the left to adjust cropping
    cropRightOffset = 400;% Specify the offset from the right to adjust cropping

elseif option == "20"
    % Define the dimensions of the crop region
    cropWidth = maxWidth / 2;    % Specify the width of the crop region
    cropHeight = maxHeight / 4;    % Specify the height of the crop region
    cropTopOffset = 20;  % Specify the offset from the top to adjust cropping
    cropLeftOffset = 300; % Specify the offset from the left to adjust cropping
    cropRightOffset = 200;% Specify the offset from the right to adjust cropping

elseif option == "10"
    % Define the dimensions of the crop region
    cropWidth = maxWidth / 2.5;    % Specify the width of the crop region
    cropHeight = maxHeight / 4;    % Specify the height of the crop region
    cropTopOffset = 20;  % Specify the offset from the top to adjust cropping
    cropLeftOffset = 530; % Specify the offset from the left to adjust cropping
    cropRightOffset = 400;% Specify the offset from the right to adjust cropping

end


% Calculate the coordinates for cropping (top middle)
cropTopLeftX = cropLeftOffset + 1; % Adjusted to include the left offset
cropTopLeftY = cropTopOffset + 1;  % Adjusted to include the top offset
cropBottomRightX = cropTopLeftX + cropWidth - 1; % Adjusted to include the left offset and width
cropBottomRightY = cropTopOffset + cropHeight;

% Calculate the coordinates for cropping (top middle) for input image
cropTopLeftXInput = cropLeftOffset + 1; % Adjusted to include the left offset
cropTopLeftYInput = cropTopOffset + 1;  % Adjusted to include the top offset
cropBottomRightXInput = cropTopLeftXInput + cropWidth - 1; % Adjusted to include the left offset and width
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


% Convert recognized texts to uppercase for consistent comparison
recognizedTextCroppedUpper = upper(recognizedTextCropped);
recognizedTextInputUpper = upper(recognizedTextInput);

% Define the target text to check for
targetText = 'BANK NEGARA MALAYSIA';

% Check if the target text is present in the recognized texts
isTargetPresentCropped = contains(recognizedTextCroppedUpper, targetText);
isTargetPresentInput = contains(recognizedTextInputUpper, targetText);

% Determine if the currency is real or fake based on target text presence
if isTargetPresentCropped
    disp('Real Currency: "BANK NEGARA MALAYSIA" detected in cropped image.');
else
    disp('Fake Currency: "BANK NEGARA MALAYSIA" not detected in cropped image.');
end

if isTargetPresentInput
    disp('Real Currency: "BANK NEGARA MALAYSIA" detected in input image.');
else
    disp('Fake Currency: "BANK NEGARA MALAYSIA" not detected in input image.');
end



%%
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
