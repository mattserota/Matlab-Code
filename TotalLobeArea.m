%--------------------------------------------%
%Note to self: If this does not detect the border use LobeAreaTest
%Alorightm

%--------------------------------------------%
%Make sure to do clear all and close all

%%%
clear all;
close all;
finallungarea = [];
n=input('Enter the Number of Images You want to Analyze: ');

for i=1:n
%%image=imread(['4-9-' num2str(i) '.jpg']);
image=imread(['4-1-1.jpg']);

%cell=imread('Test Tumor Image.jpg');
figure(1)
imshow(image);
title('Original Lung Image')


%Image is in RGB, so convert to grayscale
y= input('Would you like to Crop Type 1 for yes 0 for no: ');
    if (y == 1)
        b= input('How Many Times would you like to Crop? ');
           for i=1:b
             cell = imcrop(image);
croppedoriginal = cell;     
cell=rgb2gray(cell);
cell = imadjust(cell);
figure(2)
imshow(cell)
%cell = histeq(cell);
%cell = adapthisteq(cell);
% 
% y= disp('Would you like to Crop Type 1 for yes 0 for no");
%     if y= 1
%           cell = imcrop(cell)
%           
%     end
% 
% cell2 = im2bw(cell);
% cell2= -cell2;

%%%%HELP EDGE
%Detect edges
%%Zerocross
[binary threshold] = edge(cell,'zerocross');
%[binary threshold] = edge(cell,'sobel');
%%figure(3)
%%imshow(binary)
 fudgefactor=1;
bw=edge(cell,'zerocross',threshold*fudgefactor);
%%%figure(3)
%%%imshow(bw)
%title('binary mask')

%Fill in edge gaps using a line structural element
se90 = strel('line',2,90);
se0 = strel('line',2,0);
seC=strel('disk',3);

%bwdilate=imdilate(binary,[se0 se90]);
%bwdilate=imdilate(bw,[se90 se0]);
bwdilate=imdilate(binary,seC);
%%%figure(4)
%%%imshow(bwdilate)
title('dilated image')

%Fill in holes in the image
bwfill=imfill(bwdilate,'holes');
%%figure(5)
%%imshow(bwfill)
%%title('filled in image')

%Smooth out object.  Estimate shape using strel
%se90 = strel('line',8,90);
%se0 = strel('line',7,0);
%seD=strel('diamond',1);
%bwfinal=imerode(bwfill,[se90 se0]);
%seC=strel('diamond',4);
bwfinal=imerode(bwfill,seC);
%%%figure(6)
%%%imshow(bwfinal)
%%title('Pre-final image')
% 
% 
%if there are any images on the border...delete
bwnobord=imclearborder(bwfinal,4);
%%figure(7)
%%imshow(bwnobord)
title('No borders')

% %seC=strel('diamond',4);
% bwfinal=imerode(bwfill,seC);
% figure(8)
% imshow(bwfinal)
% title('final image')

% 
% %Fill in edge gaps using a line structural element
% se90 = strel('line',4,90);
% se0 = strel('line',3,0);
% seC=strel('disk',3);
% 
% %bwdilate=imdilate(bw,[se90 se0]);
% %bwdilate=imdilate(bw,[se90 se0]);
% bwdilate=imdilate(bw,seC);
% figure(4)
% imshow(bwdilate)
% title('dilated image')
% 
% %Fill in holes in the image
% bwfill=imfill(bwdilate,'holes');
% figure(5)
% imshow(bwfill)
% title('filled in image')
% 
% %Smooth out object.  Estimate shape using strel
% %se90 = strel('line',8,90);
% %se0 = strel('line',7,0);
% %seD=strel('diamond',1);
% %bwfinal=imerode(bwfill,[se90 se0]);
% seC=strel('diamond',2);
% bwfinal=imerode(bwfill,seC);
% figure(6)
% imshow(bwfinal)
% title('Pre-final image')
% 
% 
% %bwfinal=imerode(bwfinal,seD);
% %bwfinal=imdilate(bwfinal,seD);
% seD=strel('disk',1);
% %bwfinal=imerode(bwfinal,seD);
% bwfinal=imerode(bwfinal,[se90 se0]);
% bwfinal=imerode(bwfinal,[se90 se0]);
% bwfinal=imdilate(bwfinal,seD);
figure(7)
 imshow(bwfinal)
 title('Final-final image')

% %if there are any images on the border...delete
% bwnobord=imclearborder(bwfinal,4);
% imshow(bwnobord)



seD=strel('disk',3);
bwnobord=imerode(bwnobord,seD);
seD=strel('disk',3);
bwnobord=imdilate(bwnobord,seD);

figure(8)
imshow(bwnobord)
title('Get rid of junk')



bwoutline=bwperim(bwnobord);
%original=cell;
%bordercolor = [182;73;138];

find

croppedoriginal(bwoutline,1)= 1;
croppedoriginal(bwoutline,2) = 0;
croppedoriginal(bwoutline,3) = 0;
figure(9)
imshow(croppedoriginal)
title('Outline of isolated segment on image')


figure(10)
imshow(bwoutline)

[L,num]=bwlabel(bwnobord);

s= regionprops (L, 'Area', 'Centroid');

LungArea = cat(1,s. Area);
totallungarea (i) = max(LungArea);
      end
    end
%%finallungarea=sum(totallungarea);
finallungarea=[finallungarea; totallungarea'];




% z = input('How Many Lobes Do You See?');
% if z ~=1
%     for x = 1:z
%         %wait for button press is a built in command
%         b= waitforbuttonpress;
%         
%         %you want to click in the centriod of the first object
%         point1=get (gca, 'CurrentPoint');
%         
%         
%         %going through each object and getting out the centroid
%         %numel is built in - number of objects - s is hte # of objects
%         for k= 1:numel(s)
%         %centr is user defined, want to get the centroid out of hte object
%             centr=s(k).Centroid;
%             dist=sqrt((point1(1,1)-centr(1))^2+(point1(1,2)-centr(2))^2);
%             %going to have to play whit this tolerance and see whats good
%            if dist<100
%                    %if it meets the critera as  atumor save the area into
%                    %matrix TA
%                 CA(x) = s(k).Area
%                 %There should be no other objects that meet this criteria
%             end
%             
%         end
%     end
%     totallungarea(i) = sum(CA)
% else
 
 
% end


%Use this when doing the loop with multip[le images

%%finalcellarea = max(CellArea);


%%FinalArea = [];
%%b=1
%%for i=1:n
%      if area(i) > 100
%%FinalArea(b) = CellArea(i)

%%end
%end
        
%%FinalArea = [finalcellarea(i); CellArea(i)];
imwrite( croppedoriginal, ['Saved Outlined Image' num2str(i) '.tiff'])


end
save('TotalLungAreaCurcumin#4.txt', 'finallungarea', '-ascii')
