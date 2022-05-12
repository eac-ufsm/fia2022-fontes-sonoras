function itaToHDF5(data, varargin)
    dArgs = containers.Map({'file_name'},{'ita_data.h5'});
    for i=1:2:length(varargin)
       dArgs(varargin{i}) = varargin{i+1}; 
    end
    h5create(dArgs('file_name'),'/data', size(data.time),'ChunkSize',[20 20]);
    h5write(dArgs('file_name'),'/data', data.time);
    h5writeatt(dArgs('file_name'),'/data','fs',data.fs);
end