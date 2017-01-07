clc;
close all;
clear all;

addpath(cd());

%%%%%%%%%%%%%%%%%%%%%%% TRAINING PHASE
fprintf('Generating Train and Test Indices \n');
%% Count Videos Per Emotions 
initial_directory= cd();

video_directory='../CamA';
new_height = 8;
new_width =  8; % so have a fat dictionary

num_videos_per_emotion=CountVideosPerEmotion(video_directory);
cd(initial_directory);
num_classes=length(num_videos_per_emotion);

%% Set Training and Testing Indices 
train_samples_per_class = 5;
test_samples_per_class = 5;
train_indices = zeros(num_classes, train_samples_per_class);
test_indices = zeros(num_classes, test_samples_per_class);

for i=1:num_classes
     join_indices = randperm(num_videos_per_emotion(i),train_samples_per_class+test_samples_per_class);
     train_indices(i,:) = join_indices(1:train_samples_per_class);
     test_indices(i,:) = join_indices(train_samples_per_class+1:train_samples_per_class+test_samples_per_class);  
end

%% Generate dictionary
num_frames_per_train_video = 10;
do_normalize_train=1;
fprintf('Generating Dictionary \n');
dictionary=GenerateDictionary(video_directory,train_indices,new_height,new_width,num_frames_per_train_video,do_normalize_train);
cd(initial_directory);

%%%%%%%%%%%%%%%%%%%%%%% TESTING PHASE
do_normalize_test=0;

% global_max_iter=30;
% lasso_max_iter=100;
global_max_iter=10;
lasso_max_iter=2;

% alpha =10;
alpha =15;

confussion_matrix=zeros(num_classes,num_classes);
num_correct_classified=0;
num_experiments_run=0;

for i=1:num_classes
    for j=1:test_samples_per_class
    fprintf('Test Task %d of %d \n',num_experiments_run,num_classes*test_samples_per_class);
    class_num=i;
    test_index=test_indices(i,j);
    test_sequence=GetTestSequence(video_directory,class_num,test_index,new_height,new_width,do_normalize_test);
    cd(initial_directory);    
    
%     dictionary = normc(dictionary);
%     test_sequence = normc(test_sequence); 
    
    [matched_label,X_recovered,L_recovered] = SolveModel(num_classes,train_samples_per_class,dictionary,test_sequence,num_frames_per_train_video,global_max_iter,lasso_max_iter,alpha, new_height, new_width);
    
    fprintf('Label: Matched %d - Real %d \n',matched_label,i);
    if(matched_label==i)
        num_correct_classified=num_correct_classified+1;
    end
    num_experiments_run=num_experiments_run+1;
    fprintf('Partial Recognition Rate = %f \n',num_correct_classified/num_experiments_run);
    confussion_matrix(i,matched_label)=confussion_matrix(i,matched_label)+1;
    end
end

fprintf('Recognition Rate = %f \n',num_correct_classified/num_experiments_run);
fprintf('Confusion Matrix  \n');
confussion_matrix