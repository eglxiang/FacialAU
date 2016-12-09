function [vec_video]= ProcessVideo(videomatrix,new_height,new_width,do_normalize)

videomatrix = ResizeImages2(videomatrix,new_height,new_width);
[num_frames,height,width]=size(videomatrix);
vec_video=reshape(videomatrix,[num_frames,height*width])'; % Each face is a column
%vec_video = vec_video -vec_video(:,1)*ones(1,num_frames);% subtract neutral

if(do_normalize==1)
    inv_norms=1./(sqrt(sum(vec_video.*vec_video,1))+0.000001); % l2 norm along column
    vec_video=(vec_video.*(ones(height*width,1)*inv_norms));
end

end

