classdef volumedata
    properties
        volume
        dicominfo
        view
        alphamap
        colormap
    end
    
    methods
        function obj = loadmat(obj, filename)
            data = load(filename);
            obj.volume = data.v;
            obj.dicominfo = data.dicominfo;
        end

        function obj = showVolume(obj)
            if ~isempty(obj.volume) 
                obj.view = volshow(obj.volume);
            end
        end
        
        function updateVolume()

        end
    end
end