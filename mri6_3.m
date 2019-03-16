clear
close all
clc

%% reading all the dcm files from folder and surface rendering for face reconstruction 
    ipfolder = 'E:\projects\MRI_Brain_Scan\MRI Brain Scan\Series 8\I0000';
    filenum = 417:476;
    ext = '_anon.dcm';
    filename = [ipfolder num2str(filenum(1)) ext];               
    info = dicominfo(filename);
    voxel_size = [info.PixelSpacing; info.SliceThickness]         %store voxel size
    hWaitBar = waitbar(1,'Reading DICOM files');
    I=dicomread('E:\projects\MRI_Brain_Scan\MRI Brain Scan\Series 8\I0000417_anon.dcm');
    figure
    hold on

for i=1:60
  filename = [ipfolder num2str(filenum(i)) ext];
  D(:,:,i) = uint8(dicomread(filename));
%   D(:,:,i) = imgaussfilt3(D(:,:,i));
  I=imfuse(I,D(:,:,i),'blend');
  waitbar((length(filenum)-i));
end
delete(hWaitBar)
title('Surface rendering of MRI images to form face structure')
imshow(I,'DisplayRange',[]);
hold off


%% display slices(every 4rt slice) along the y-orientation of the original brain
% data.
map =pink(90);
idxImages = 1:4:size(D,3);
figure
colormap(map)
for k = 1:15
    j = idxImages(k);
    subplot(3,5,k);
    image(D(:,:,j));                    %displays array as an image/displays jth dcm file 
    xlabel(['y = ' int2str(j)]);
    if k==3
        title('Some slices along the y-orientation of the original brain data');
    end
end

%% Volume rendering to reconstruct head structure
volumeViewer(D)
value = iptgetpref('volumeViewer')
