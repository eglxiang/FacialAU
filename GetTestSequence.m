function [test_sequence]=GetTestSequence(video_directory,class_num,test_index,new_height,new_width,do_normalize)

cd(video_directory);
exterior_folders=dir;
current_exterior_folder=exterior_folders(class_num+2).name;
cd(current_exterior_folder);
interior_files=dir;
video_name =interior_files(test_index+2).name;
load(video_name);
[test_sequence]= ProcessVideo(subset,new_height,new_width,do_normalize); %Images are now columns of a matrix


