function Im_Sensor = MCA_Sensor(Im_Origin)

    B = 500;%B^2
    delta_x = 36;%x0

    Im_1 = zeros(72,64);
    Im_2 = zeros(72,64);
    Im_3 = zeros(72,64);
    Im_4 = zeros(72,64);
    Im_5 = zeros(72,64);
    Im_6 = zeros(72,64);
    Im = double(Im_Origin);

    for i=1:72
        for j=1:64
            Im_1(i,j) = Im((i-1)*2+1,(j-1)*3+1)*filter_Lorenz_1(Im((i-1)*2+1,(j-1)*3+1),B,delta_x);
            Im_2(i,j) = Im((i-1)*2+1,(j-1)*3+2)*filter_Lorenz_2(Im((i-1)*2+1,(j-1)*3+2),B,delta_x);
            Im_3(i,j) = Im((i-1)*2+1,(j-1)*3+3)*filter_Lorenz_3(Im((i-1)*2+1,(j-1)*3+3),B,delta_x);
            Im_4(i,j) = Im((i-1)*2+2,(j-1)*3+1)*filter_Lorenz_4(Im((i-1)*2+2,(j-1)*3+1),B,delta_x);
            Im_5(i,j) = Im((i-1)*2+2,(j-1)*3+2)*filter_Lorenz_5(Im((i-1)*2+2,(j-1)*3+2),B,delta_x);
            Im_6(i,j) = Im((i-1)*2+2,(j-1)*3+3)*filter_Lorenz_6(Im((i-1)*2+2,(j-1)*3+3),B,delta_x);
        end
    end
    Im_1 = imrotate(Im_1,270);
    Im_2 = imrotate(Im_2,270);
    Im_3 = imrotate(Im_3,270);
    Im_4 = imrotate(Im_4,270);
    Im_5 = imrotate(Im_5,270);
    Im_6 = imrotate(Im_6,270);

    FigOn(Im_1,Im_2,Im_3,Im_4,Im_5,Im_6,B,delta_x);

    Im_Sensor = Im_1+ Im_2+Im_3 + Im_4 +  Im_5 + Im_6;    
    Im_Sensor = Im_Sensor./max(max(Im_Sensor))*256;
    Im_Sensor = round(Im_Sensor);
end


function y = filter_Lorenz_1(x,B,delta_x)
    y = B./(B+(x-delta_x).^2);
end
function y = filter_Lorenz_2(x,B,delta_x)
    y = (1-0.1)*(1+0.1)*B./((1+0.1)*B+(x-2*delta_x).^2);
end
function y = filter_Lorenz_3(x,B,delta_x)
    y = (1-0.25)*(1+0.25)*B./((1+0.25)*B+(x-3*delta_x).^2);
end
function y = filter_Lorenz_4(x,B,delta_x)
    y = (1-0.33)*(1+0.33)*B./((1+0.33)*B+(x-4*delta_x).^2);
end
function y = filter_Lorenz_5(x,B,delta_x)
    y = (1-0.46)*(1+0.46)*B./((1+0.46)*B+(x-5*delta_x).^2);
end
function y = filter_Lorenz_6(x,B,delta_x)
    y = (1-0.58)*(1+0.58)*B./((1+0.58)*B+(x-6*delta_x).^2);
end
function FigOn(Im_1,Im_2,Im_3,Im_4,Im_5,Im_6,B,delta_x)
        figure;
        subplot(231)
        imagesc(Im_1)
        colormap jet;
        ax=gca
        ax.XAxis.Visible='off';
        ax.YAxis.Visible='off';
        subplot(232)
        imagesc(Im_2)
        colormap jet;
        ax=gca
        ax.XAxis.Visible='off';
        ax.YAxis.Visible='off';
        subplot(233)
        imagesc(Im_3)
        colormap jet;
        ax=gca
        ax.XAxis.Visible='off';
        ax.YAxis.Visible='off';
        subplot(234)
        imagesc(Im_4)
        colormap jet;
        ax=gca
        ax.XAxis.Visible='off';
        ax.YAxis.Visible='off';
        subplot(235)
        imagesc(Im_5)
        colormap jet;
        ax=gca
        ax.XAxis.Visible='off';
        ax.YAxis.Visible='off';
        subplot(236)
        imagesc(Im_6)
        colormap jet;
        ax=gca
        ax.XAxis.Visible='off';
        ax.YAxis.Visible='off';

        %%
        %FIGURE OF THE FITTED LORENZ RESPPONSE
%         x=0:255;
% 
%         y1 = filter_Lorenz_1(x,B,delta_x)';
%         y2 = filter_Lorenz_2(x,B,delta_x)';
%         y3 = filter_Lorenz_3(x,B,delta_x)';
%         y4 = filter_Lorenz_4(x,B,delta_x)';
%         y5 = filter_Lorenz_5(x,B,delta_x)';
%         y6 = filter_Lorenz_6(x,B,delta_x)';
%         
%         figure;
%         plot(y1);
%         hold on 
%         plot(y2);
%         hold on 
%         plot(y3);
%         hold on 
%         plot(y4);
%         hold on
%         plot(y5);
%         hold on 
%         plot(y6);
%         hold on 
%         plot(y1+y2+y3+y4+y5+y6)
%         xlim([0 256])
end