clc
close all
clear
%%
%image reading
im1=imread('Mars-1.jpg');
im2=imread('Mars-2.jpg');
im3=im1;
im1=imresize(imfilter(im1,fspecial('gaussian',7,1.),'same','replicate'),0.5,'bicubic');
im2=imresize(imfilter(im2,fspecial('gaussian',7,1.),'same','replicate'),0.5,'bicubic');

im1=im2double(im1);
im2=im2double(im2);

figure
subplot(1,2,1)
imshow(im1)
subplot(1,2,2)
imshow(im2);

%%
%SIFT flow
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

warpI2=warpImage(im2,vx,vy);
figure
subplot(1,2,1)
imshow(im1)
subplot(1,2,2)
imshow(warpI2);
figure
imshowpair(im1,warpI2,'diff');
%%
%display flow
clear flow;
flow(:,:,1)=vx;
flow(:,:,2)=vy;
%figure;imshow(flowToColor(flow));
save velocity2 vx vy
% downsize vx and vy
vx_deci = vx(1:10:end, 1:10:end);%10 original
vy_deci = vy(1:10:end, 1:10:end);
% get coordinate for u and v in the original frame
[X,Y] = meshgrid(1:320, 1:240);
X_deci = X(1:10:end, 1:10:end);%20 orginal
Y_deci = Y(1:10:end, 1:10:end);
%draw velocity
figure;
imshow(im1);
hold on;
% draw the velocity vectors
quiver(X_deci,Y_deci,vx_deci,vy_deci, 'y')
%%
return;
% this is the code doing the brute force matching
tic;[flow2,energylist2]=mexDiscreteFlow(Sift1,Sift2,[alpha,alpha*20,60,30]);toc
figure;imshow(flowToColor(flow2));
