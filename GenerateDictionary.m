function [Dictionary]=GenerateDictionary(video_directory,train_indices,new_height,new_width,num_frames_per_video,do_normalize)

cd(video_directory);
exterior_folders=dir;
[num_exterior_folders,~]=size(exterior_folders);

[num_classes, train_samples_per_class]=size(train_indices);

Dictionary=zeros(new_height*new_width,num_classes*train_samples_per_class*num_frames_per_video);

position_to_insert=1;

for i=3:num_exterior_folders
    current_exterior_folder=exterior_folders(i).name;
    cd(current_exterior_folder);
    interior_files=dir;
    file_indices = train_indices(i-2,:)+2;
    for j=1:train_samples_per_class
        video_name =interior_files(file_indices(j)).name;    
        load(video_name);
        [column_video]= ProcessVideo(subset,new_height,new_width,do_normalize); %Images are now columns of a matrix
        Dictionary(:,position_to_insert:position_to_insert-1+num_frames_per_video)=column_video;
        position_to_insert=position_to_insert+num_frames_per_video;
    end
    cd ..;
end
end