function STMap(video_path, landmark_path, dst_path, fps)

fn=fps;
ap=0.3;
as=10;
wp=0.6;
ws=4; 
lmk_num = 81;
wpp=wp/(fn/2);
wss=ws/(fn/2);
[n,wn]=buttord(wpp,wss,ap,as); 
[b,a]=butter(n,wn); 
dst_path = cell2mat(dst_path);
if ~exist(dst_path)
    mkdir(dst_path);
end
obj = VideoReader(video_path);
numFrames = obj.NumberOfFrames;
frameRate = obj.FrameRate;
signal = [];
% get signal

%%%%%%%%%%%%%%%%%%% FRAME TO VIDEO %%%%%%%%%%%%%%%

[pathStr, name, ext] = fileparts(video_path)
savePath = strcat(pathStr,'/video_crop.avi')
video = VideoWriter(savePath)
video.FrameRate=frameRate;
open(video)
disp(numFrames)
for k = 1:numFrames
    disp(k)
    fid = fopen(strcat(landmark_path,'/', 'landmarks', num2str(k), '.dat'), 'r');
    if fid > 0
        landmarks = fread(fid,inf,'int');
        fclose(fid);
    else
        landmarks = zeros(lmk_num*2, 1);    
    end
    frame = read(obj,k);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %{
    if k == 1
        imwrite(frame,['C:\Users\samal\Desktop\', 'image123.jpg']);
    end
    %}
    
    %{
    if k ==1
        csvwrite('lmk1.csv',landmarks)
    end
    %}
    
    newLandmarks=[];
    i=1;
    %imshow(frame);
    while i < 162
        temp=[landmarks(i,1),landmarks(i+1,1)];
        i=i+2;
        newLandmarks=[newLandmarks;temp];
%         axis on
%         hold on;
%         % Plot cross at row 100, column 50
%         plot(temp(1),temp(2), 'r+', 'MarkerSize', 3, 'LineWidth', 2);
    end
    
    % BOUNDARY CREATION **************
    
    k = boundary(newLandmarks(:,1),newLandmarks(:,2),0);
    %disp(k)
    %hold on;
    %plot(newLandmarks(:,1),newLandmarks(:,2),'ro');
    %plot(newLandmarks(k,1),newLandmarks(k,2));
    
    
    mask = poly2mask(newLandmarks(k,1), newLandmarks(k,2), size(frame,1), size(frame,2));
    mask(:,:,2) = mask;
    mask(:,:,3) = mask(:,:,1);
    
    roi = frame;
    roi(mask == 0) = 0;
    %figure; 
    %imshow(roi);
    
    writeVideo(video,roi); %write the image to file
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
    %s = getROI_signal(frame,landmarks);
    %signal = [signal;s];
end
close(video);
disp('**********DONE DONE DONE************')

% % a = size(signal);
% % Combine_channel=zeros(15,a(1),3);
% % Combine_channel(:,:,1) = signal(:,1:15)';
% % Combine_channel(:,:,2) = signal(:,16:30)';
% % Combine_channel(:,:,3) = signal(:,31:45)';

% save_map_fullTime(dst_path, Combine_channel)
% fps_path = strcat(dst_path, '/fps.mat');
% eval(['save ', fps_path, ' fps']);
end