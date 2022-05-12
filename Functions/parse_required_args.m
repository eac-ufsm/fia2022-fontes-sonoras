function output = parse_required_args(args, inputs)
    output = containers.Map();
    parsed_args = {};
    for i = 1:2:length(inputs)
        if ismember(inputs{i}, args)
            output(inputs{i}) = inputs{i+1};
            parsed_args{end+1} = inputs{i};
        end
    end
end