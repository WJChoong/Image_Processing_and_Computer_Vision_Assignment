% Input Image
imagePathInput ='C:\Users\Felicia\OneDrive\Desktop\Currency\Real\10.png';
ImageInput = imread(imagePathInput);

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

% Create a figure
figure;

% Display the enhanced input image
imshow(enhancedImageInput);
title('Enhanced Input Currency Image');

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
else
    disp('Fake Currency: Target text not detected in input image.');
end

function enhancedImage = enhanceImage(inputImage)
    % Denoise the image using Gaussian filter
    denoisedImage = imgaussfilt(inputImage, 0.3);
    
    % Assign the enhanced image
    enhancedImage = denoisedImage;
end
