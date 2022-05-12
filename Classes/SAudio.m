classdef SAudio< master_mvs
    properties
       Source = Source
       MicArray = MicArray
       c0 = 343;
    end
    methods
        function this = SAudio(varargin)
            if ~isempty(varargin)
                 required_args = ["data","Fs"];
                required_inputs = parse_required_args(...
                    required_args, varargin);
                default_args = containers.Map({'c0'},{343});
                default_inputs = parse_default_args(...
                    default_args, varargin);
               this.time_data = required_inputs('data');
               this.Fs = required_inputs('Fs');
               this.c0 = default_inputs('c0');
            end
            
           
        end
    end
    
end