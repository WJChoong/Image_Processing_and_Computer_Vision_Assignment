function guiExample()
    % Create the main figure window
    fig = uifigure('Name', 'GUI Example', 'Position', [100, 100, 300, 200]);
    
    % Create a ButtonGroup to group the radio buttons
    buttonGroup = uibuttongroup(fig, 'Position', [50, 100, 200, 80]);
    
    % Create radio buttons within the ButtonGroup to represent options
    option1RadioButton = uiradiobutton(buttonGroup, 'Text', 'Option 1', 'Position', [10, 40, 100, 20]);
    option2RadioButton = uiradiobutton(buttonGroup, 'Text', 'Option 2', 'Position', [10, 10, 100, 20]);
    option3RadioButton = uiradiobutton(buttonGroup, 'Text', 'Option 3', 'Position', [110, 40, 100, 20]);
    
    % Create the "Run" button
    runButton = uibutton(fig, 'Position', [110, 40, 80, 30], 'Text', 'Run', 'ButtonPushedFcn', @runButtonPressed);
    
    % Create the message bar
    messageBar = uilabel(fig, 'Position', [20, 20, 260, 20], 'Text', '', 'HorizontalAlignment', 'center');
    
    % Function to handle the "Run" button press event
    function runButtonPressed(src, event)
        disp('Run button pressed.');
        
        % Determine the selected option and update the message bar accordingly
        if option1RadioButton.Value
            messageBar.Text = 'Hello';
        elseif option2RadioButton.Value
            messageBar.Text = 'Bye bye';
        elseif option3RadioButton.Value
            messageBar.Text = 'See you';
        else
            % If no option is selected, display a warning message
            messageBar.Text = 'Please select an option before clicking Run.';
        end
    end
end
