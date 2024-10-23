function parsave(folder,filename, dataDR)
    
    filepath = fullfile(folder,filename);
    save(filepath,'dataDR');
end