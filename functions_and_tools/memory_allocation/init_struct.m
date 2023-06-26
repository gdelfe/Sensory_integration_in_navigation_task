function new_struct = init_struct(old_struct)
    % Initialize the new structure
    new_struct = struct();

    % Get the field names of the old structure
    field_names = fieldnames(old_struct);

    % Loop over each field
    for i = 1:numel(field_names)
        % Get the current field name
        field_name = field_names{i};

        % Check if the current field is a structure
        if isstruct(old_struct.(field_name))
            % If it's a structure, call the function recursively
            new_struct.(field_name) = init_struct(old_struct.(field_name));
        else
            % If it's not a structure, initialize an empty field
            new_struct.(field_name) = [];
        end
    end
end
