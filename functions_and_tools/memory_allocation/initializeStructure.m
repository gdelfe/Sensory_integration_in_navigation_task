
% Recursive function to initialize the structure
function newStruct = initializeStructure(sourceStruct)
    newStruct = struct();
    
    % Get field names from the source structure
    fieldNames = fieldnames(sourceStruct);
    
    % Iterate over the field names
    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
        
        % Check if the field value is a struct (subfield)
        if isstruct(sourceStruct.(fieldName))
            % Recursively initialize the substructure
            newStruct.(fieldName) = initializeStructure(sourceStruct.(fieldName));
        else
            % Initialize the field with an empty value
            newStruct.(fieldName) = [];
        end
    end
end
