clc
clear
close all
%%
load('Normal_Image.mat');
Im_Origin = images(:,:,4612);
Im = Im_Origin;
%%
Im_Sensor = MCA_Sensor(Im);
%%
Im = imrotate(Im,270);
figure;
subplot(121);
imagesc(Im);
colorbar ('Ticks', []);colormap jet;
ax=gca
ax.XAxis.Visible='off';
ax.YAxis.Visible='off';
subplot(122);
imagesc(Im_Sensor);
colorbar ('Ticks', []);colormap jet;
ax=gca
ax.XAxis.Visible='off';
ax.YAxis.Visible='off';
%%
bw_Im = imbinarize(Im,256/2);
bw_Sensor = imbinarize(Im_Sensor,256/2);
Edge_Im =edge(bw_Im,'canny');
Edge_Sensor =edge(bw_Sensor,'canny');

figure;
subplot(121);
imagesc(Edge_Im)
ax=gca
ax.XAxis.Visible='off';
ax.YAxis.Visible='off';
subplot(122);
imagesc(Edge_Sensor)
ax=gca
ax.XAxis.Visible='off';
ax.YAxis.Visible='off';