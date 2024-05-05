clc
clear
close all

%%
WaitBarOpen = 1;
Sensors = 0;
%%
if(WaitBarOpen)
    hWaitBar = waitbar(0,'Running CNN Simulation');
end
% pool = gcp;

%%
NumberOfFeature = 11;
NumberOfSamples = 1000;
Xsize = 144;
Ysize = 192;
% images_origin = uint8( zeros(Xsize,Ysize,3,NumberOfFeature*NumberOfSamples) );
% images = zeros(Xsize,Ysize,NumberOfFeature*NumberOfSamples);
% labels  = zeros(NumberOfFeature*NumberOfSamples,1);
%%
load('Normal_Image.mat');
load('Normal_Image_NoFinger.mat');
load('Sensor_Image_new.mat');
load('Sensor_Image_NoFinger.mat');
load('Labels_GR.mat')
load('Labels_GR_NF.mat')
for i=6001:11000
    images(:,:,i)=images_Nofinger(:,:,i-6000);
    images_new(:,:,i)=images_Nofinger_Senor(:,:,i-6000);
end
Y = categorical([labels;labels_Nofinger]);   
%Y = categorical([labels]);  
X = reshape(images, [144,192,1,length(images)]); 
X_2 = reshape(images_new, [72,64,1,length(images_new)]);                                 
 
%%
M               = 100;
Epochs_max      = 100;
Epochs_min      = 10;
Epochs_delta    = 5;
num_train       = round(0.75*length(X));
num_val         = round(0.2*length(X));  


X_train = reshape(images(:,:,1:num_train), [144,192,1,num_train]); 
X_val = reshape(images(:,:,num_train+1:num_train+num_val), [144,192,1,num_val]); 
X_test = reshape(images(:,:,num_train+num_val+1:end), [144,192,1,length(images) - num_train - num_val]);
%%
Results = struct();
Results.MatrixPr = zeros((Epochs_max-Epochs_min)/Epochs_delta + 1,M);
Results.MatrixPr2 = zeros((Epochs_max-Epochs_min)/Epochs_delta + 1,M);
%%
for Epochs=Epochs_min:Epochs_delta:Epochs_max
    for m=1:M
        idx = randperm(length(images));   
        for i=1:NumberOfFeature
			if(Sensors == 0)
				X_train   = X(:,:,:,idx(1:num_train));
				X_val 	  = X(:,:,:,idx(num_train+1:num_train+num_val));
				X_test 	  = X(:,:,:,idx(num_train+num_val+1:end)); 
			else
				X_train_2 = X_2(:,:,:,idx(1:num_train));
				X_val_2   = X_2(:,:,:,idx(num_train+1:num_train+num_val));
				X_test_2  = X_2(:,:,:,idx(num_train+num_val+1:end)); 
			end
            Y_train = Y(idx(1:num_train),:);
            Y_val 	= Y(idx(num_train+1:num_train+num_val),:);
            Y_test 	= Y(idx(num_train+num_val+1:end),:);
        end
		
		if( Sensors == 0 )
			layers = [...
					  imageInputLayer([144,192,1]); 
					  batchNormalizationLayer(); 
					  convolution2dLayer(5,20);  
					  batchNormalizationLayer();
					  reluLayer()                 
					  maxPooling2dLayer(2,'Stride',2);
					  fullyConnectedLayer(NumberOfFeature);
					  softmaxLayer();           
					  classificationLayer(),...
				];
			options = trainingOptions('sgdm',...                        
									  'MiniBatchSize',128, ...
									  'MaxEpochs',Epochs,...                 
									  'ValidationData',{X_val,Y_val},...
									  'Verbose',false, ...          
									  'Shuffle','every-epoch', ...
									  'InitialLearnRate',1e-2);                                                               

			[net_cnn,info] = trainNetwork(X_train,Y_train,layers,options);

			testLabel = classify(net_cnn,X_test);
			precision = sum(testLabel==Y_test)/numel(testLabel);
			Results.MatrixPr((Epochs-Epochs_min)/Epochs_delta + 1,m) = precision*100;
		else
			 layers = [...
					   imageInputLayer([72,64,1]); 
					   batchNormalizationLayer(); 
					   convolution2dLayer(6,12);  
					   batchNormalizationLayer();
					   reluLayer()                 
					   maxPooling2dLayer(4,'Stride',4);
					   fullyConnectedLayer(NumberOfFeature);
					   softmaxLayer();           
					   classificationLayer(),...
				 ];
			 options = trainingOptions('sgdm',...                       
									   'MiniBatchSize',128, ...
									   'MaxEpochs',Epochs,...               
									   'ValidationData',{X_val_2,Y_val},... 
									   'Verbose',false, ...         
									   'Shuffle','every-epoch', ...
									   'L2Regularization',1.0e-4,...
									   'InitialLearnRate',1.0e-2);


			
			 [net_cnn,info2] = trainNetwork(X_train_2,Y_train,layers,options);
			 testLabel = classify(net_cnn,X_test_2);
			 precision = sum(testLabel==Y_test)/numel(testLabel);
			 Results.MatrixPr2((Epochs-Epochs_min)/Epochs_delta + 1,m) = precision*100;
		end

		if(Epochs == Epochs_max)
			if( Sensors == 0 )
				Results.MatrixTr(:,m) = info.TrainingAccuracy';
			else
				Results.MatrixTr2(:,m) = info2.TrainingAccuracy';
			end
		end
    
        if(WaitBarOpen)
             progress = (Epochs-Epochs_min)/Epochs_delta*M + m;
             progress = progress/(M*((Epochs_max-Epochs_min)/Epochs_delta + 1));
             waitbar(progress,hWaitBar,[num2str(progress*100,'%.1f'),'%']);
        end
		
    end
end

if(WaitBarOpen)
    warndlg('CNN Simulation Done.', 'WARN');
    close(hWaitBar);
    delete(hWaitBar);
end
