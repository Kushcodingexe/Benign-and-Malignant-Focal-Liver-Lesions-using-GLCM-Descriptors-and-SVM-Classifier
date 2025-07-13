clc;
clear all;
% % mean GLCM features
OverallFeaturesTrain=xlsread("C:\Users\PLC Lab1\Downloads\Project_Files -copy2\GLCM_d_3_mean\GLCM_d_3_mean_features_train.xlsx",'A1:M1815');
OverallFeaturesTest=xlsread("C:\Users\PLC Lab1\Downloads\Project_Files -copy2\GLCM_d_3_mean\GLCM_d_3_mean_features_test.xlsx",'A1:M90');

% range GLCM features
% OverallFeaturesTrain=xlsread("C:\Users\PLC Lab1\Downloads\Project_Files -copy2\GLCM_d_4_range\GLCM_d_4_range_features_train.xlsx",'A1:Q1815');
% OverallFeaturesTest=xlsread("C:\Users\PLC Lab1\Downloads\Project_Files -copy2\GLCM_d_4_range\GLCM_d_4_range_features_test.xlsx",'A1:Q90');

[OverallFeaturesTrainN,ps] = mapminmax(OverallFeaturesTrain',0,1);
OverallFeaturesTrainN = double(OverallFeaturesTrainN');
OverallFeaturesTestN = mapminmax('apply',OverallFeaturesTest',ps);
OverallFeaturesTestN = double(OverallFeaturesTestN');
% TrainLabel=[zeros(1,22),ones(1,31)]';
% TestLabel=[zeros(1,22),ones(1,31)]';

% Train Label ~ vector concatenation
TrainLabel = [zeros(591,1); ones(601,1); 2*ones(623,1)];
% TrainLabel=zeroes(1770,1); 
% TrainLabel(1:590)=0;
% TrainLabel(591:1180)=1;
% TrainLabel(1181:1770)=2;

% Test Label 
TestLabel = [zeros(30,1); ones(30,1); 2*ones(30,1)];
% % TestLabel = zeros(90, 1);  
% TestLabel(1:30) = 0;       
% Testabel(31:60) = 1;     
% TestLabel(60:90) = 2; 

bestcv = 0;
bestc=1;
bestg=1;
% grid search on libsvm
for log2c = -3:14,
for log2g = -12:4,
     cmd = ['-v 10 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
cv = svmtrain(TrainLabel,OverallFeaturesTrainN,cmd);
if (cv >= bestcv),
bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
end
fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv)
end
end
% bestc;
% bestg; 
cval=10;
Parameters=sprintf('-c %g -g %g -v %g',bestc,bestg,cval);
ParamFinal=sprintf('-c %g -g %g',bestc,bestg);
Model=svmtrain(TrainLabel,OverallFeaturesTrainN,Parameters);
FinalModel=svmtrain(TrainLabel,OverallFeaturesTrainN,ParamFinal);
[PredictedLabelOverallFeatures TestAccuracyOverallFeatures ProbabilityOverallFeatures]=svmpredict(TestLabel,OverallFeaturesTestN,FinalModel);

PredictedLabelOverallFeatures = svmpredict(TestLabel, OverallFeaturesTestN, FinalModel);

% Calculate confusion matrix elements
M11 = length(find(PredictedLabelOverallFeatures(1:30,:) == 0));
M12 = length(find(PredictedLabelOverallFeatures(1:30,:) == 1));
M13 = length(find(PredictedLabelOverallFeatures(1:30,:) == 2));
M21 = length(find(PredictedLabelOverallFeatures(31:60,:) == 0));
M22 = length(find(PredictedLabelOverallFeatures(31:60,:) == 1));
M23 = length(find(PredictedLabelOverallFeatures(31:60,:) == 2));
M31 = length(find(PredictedLabelOverallFeatures(61:90,:) == 0));
M32 = length(find(PredictedLabelOverallFeatures(61:90,:) == 1));
M33 = length(find(PredictedLabelOverallFeatures(61:90,:) == 2));

% Confusion matrix for 3 labels
% print('Mean')
% fprintf('range')
CM = [M11 M12 M13; M21 M22 M23; M31 M32 M33]

% M11=length(find(PredictedLabelOverallFeatures(1:21,:)==0));
% M12=length(find(PredictedLabelOverallFeatures(1:21,:)==1));
% M21=length(find(PredictedLabelOverallFeatures(22:51,:)==0));
% M22=length(find(PredictedLabelOverallFeatures(22:51,:)==1));
% CM=[M11 M12;M21 M22]
