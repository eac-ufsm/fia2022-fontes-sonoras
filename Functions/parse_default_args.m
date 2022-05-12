function output = parse_default_args(default, input)
    output = default;
    for i = 1:2:length(input)
        if isKey(default, input{i})
            output(input{i}) = input{i+1};
        end
    end
end