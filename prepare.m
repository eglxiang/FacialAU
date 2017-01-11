img_h = 128;
img_w = 128;
num_frames_per_video = 10;

cd('CamB');
folders=dir();
[num_folders,~]=size(folders);

for i=3:num_folders
    current_folder=folders(i).name;
    cd(current_folder);
    files=dir();
    [num_files,~]=size(files);
    num_subsets = floor((num_files - 2)/num_frames_per_video);
    if num_subsets > 0
        subset = zeros(num_frames_per_video, img_h, img_w);
    end
    for j=1:num_subsets
        for k=1:num_frames_per_video
            current_img = im2double(imread(files((j-1)*num_frames_per_video + k + 2).name));
            subset(k,:,:)= current_img;
        end
        save(strcat(int2str(j),'.mat'), 'subset');
    end
    cd ..
end