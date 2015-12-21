clc
close all
clear
%%
%image reading
im1=imread('Test6_c1_3.JPG');
im1=rgb2gray(im1);
im2=imread('Test6_c1_4.JPG');
im2=rgb2gray(im2);
%%
%corner detection
C1=corner(im1);
C2=corner(im2);
figure
subplot(2,1,1)
imshow(im1)
hold on
plot(C1(:,1), C1(:,2), 'r*');
subplot(2,1,2)
imshow(im2)
hold on
plot(C2(:,1), C2(:,2), 'r*');
title('Corner detection')

%%
%coner pick
C1_picked_by_user=[60 100; 252 107; 54 249; 248 255];
figure
imshow(im1)
hold on
plot(C1_picked_by_user(1,1), C1_picked_by_user(1,2), 'r*');
plot(C1_picked_by_user(2,1), C1_picked_by_user(2,2), 'g*');
plot(C1_picked_by_user(3,1), C1_picked_by_user(3,2), 'b*');
plot(C1_picked_by_user(4,1), C1_picked_by_user(4,2), 'rx');

%%
im1=imfilter(im1,fspecial('gaussian',7,1.),'same','replicate');
im2=imfilter(im2,fspecial('gaussian',7,1.),'same','replicate');

im1=im2double(im1);
im2=im2double(im2);

%figure;imshow(im1);figure;imshow(im2);

cellsize=3;
gridspacing=1;

addpath(fullfile(pwd,'mexDenseSIFT'));
addpath(fullfile(pwd,'mexDiscreteFlow'));

sift1 = mexDenseSIFT(im1,cellsize,gridspacing);
sift2 = mexDenseSIFT(im2,cellsize,gridspacing);

SIFTflowpara.alpha=2*255;
SIFTflowpara.d=40*255;
SIFTflowpara.gamma=0.005*255;
SIFTflowpara.nlevels=4;
SIFTflowpara.wsize=2;
SIFTflowpara.topwsize=10;
SIFTflowpara.nTopIterations = 60;
SIFTflowpara.nIterations= 30;


tic;[vx,vy,energylist]=SIFTflowc2f(sift1,sift2,SIFTflowpara);toc
% image registration
% warpI2=warpImage(im2,vx,vy);
% figure;imshow(im1);figure;imshow(warpI2);

% display flow
clear flow;
flow(:,:,1)=vx;
flow(:,:,2)=vy;
%figure;imshow(flowToColor(flow));
% downsize vx and vy
vx_deci = vx(1:10:end, 1:10:end);%10 original
vy_deci = vy(1:10:end, 1:10:end);
% get coordinate for u and v in the original frame
[X,Y] = meshgrid(1:640, 1:480);
X_deci = X(1:10:end, 1:10:end);%20 orginal
Y_deci = Y(1:10:end, 1:10:end);
%draw velocity
figure;
imshow(im1);
hold on;
% draw the velocity vectors
quiver(X_deci,Y_deci,vx_deci,vy_deci, 'y')
title('SIFT flow velocity')
%return;
% this is the code doing the brute force matching
% tic;[flow2,energylist2]=mexDiscreteFlow(Sift1,Sift2,[alpha,alpha*20,60,30]);toc
% figure;imshow(flowToColor(flow2));
%%
%corner prediction based on velocity
% C2_predicted = [ C1_picked_by_user(1,1)+vx(C1_picked_by_user(1,1),C1_picked_by_user(1,2))  C1_picked_by_user(1,2)+vy(C1_picked_by_user(1,1),C1_picked_by_user(1,2));
%                 C1_picked_by_user(2,1)+vx(C1_picked_by_user(2,1),C1_picked_by_user(2,2))  C1_picked_by_user(2,2)+vy(C1_picked_by_user(2,1),C1_picked_by_user(2,2));
%                 C1_picked_by_user(3,1)+vx(C1_picked_by_user(3,1),C1_picked_by_user(3,2))  C1_picked_by_user(3,2)+vy(C1_picked_by_user(3,1),C1_picked_by_user(3,2));
%                 C1_picked_by_user(4,1)+vx(C1_picked_by_user(4,1),C1_picked_by_user(3,2))  C1_picked_by_user(4,2)+vy(C1_picked_by_user(4,1),C1_picked_by_user(4,2))];

C2_predicted = [ C1_picked_by_user(1,1)+vx(C1_picked_by_user(1,2),C1_picked_by_user(1,1))  C1_picked_by_user(1,2)+vy(C1_picked_by_user(1,2),C1_picked_by_user(1,1));
                C1_picked_by_user(2,1)+vx(C1_picked_by_user(2,2),C1_picked_by_user(2,1))  C1_picked_by_user(2,2)+vy(C1_picked_by_user(2,2),C1_picked_by_user(2,1));
                C1_picked_by_user(3,1)+vx(C1_picked_by_user(3,2),C1_picked_by_user(3,1))  C1_picked_by_user(3,2)+vy(C1_picked_by_user(3,2),C1_picked_by_user(3,1));
                C1_picked_by_user(4,1)+vx(C1_picked_by_user(4,2),C1_picked_by_user(3,1))  C1_picked_by_user(4,2)+vy(C1_picked_by_user(4,2),C1_picked_by_user(4,1))];
figure
imshow(im2)
hold on
plot(C1_picked_by_user(1,1), C1_picked_by_user(1,2), 'r*');
plot(C1_picked_by_user(2,1), C1_picked_by_user(2,2), 'g*');
plot(C1_picked_by_user(3,1), C1_picked_by_user(3,2), 'b*');
plot(C1_picked_by_user(4,1), C1_picked_by_user(4,2), 'rx');
figure
imshow(im2)
hold on
plot(C2_predicted(1,1), C2_predicted(1,2), 'r*');
plot(C2_predicted(2,1), C2_predicted(2,2), 'g*');
plot(C2_predicted(3,1), C2_predicted(3,2), 'b*');
plot(C2_predicted(4,1), C2_predicted(4,2), 'rx');
title('IMG2 Coner prediction')
%%


            
