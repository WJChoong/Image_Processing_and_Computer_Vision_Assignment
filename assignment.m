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
            method = getSelectedMethod(); % Get the selected method
            % Perform fake currency detection using the 6 functions
            result = performFakeCurrencyDetection(selectedImagePath, method);
            
            if result
                resultMessage = 'The image is not detected as fake currency.';
            else
                resultMessage = 'The image is detected as fake currency.';
            end

            set(resultText, 'String', resultMessage);
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
    
        if ~checkFeature1(imagePath, method) || ~checkFeature2(imagePath, method) || ...
           ~checkFeature3(imagePath, method) || ~checkFeature4(imagePath, method) || ...
           ~checkFeature5(imagePath, method) || ~checkFeature6(imagePath, method)
            result = false; 
        end
    end

    % Placeholder functions for fake currency detection features
    function result = checkFeature1(imagePath, method)
        selectedMethod = getSelectedMethod();
        fprintf('Selected Method: %s\n', selectedMethod);
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
        selectedMethod = getSelectedMethod();
        fprintf('Selected Method: %s\n', selectedMethod);
        result = true;
    end

    function result = checkFeature4(imagePath, method)
        selectedMethod = getSelectedMethod();
        fprintf('Selected Method: %s\n', selectedMethod);
        result = true;
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
