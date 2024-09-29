clc
clear

XTest = load("Data/XTest.mat");
XTest = XTest.XTest;
XTrain = load("Data/XTrain.mat");
XTrain = XTrain.XTrain;
ytrain = load("Data/ytrain.mat");
ytrain = ytrain.ytrain;
ytest = load("Data/ytest.mat");
ytest = ytest.ytest;


By = [ytest(1:75); ytest(301:375)];

Fy = [ytest(76:150); ytest(376:450)];

Hy = [ytest(151:225); ytest(451:525)];

My = [ytest(226:300);ytest(526:600)];

B = [XTest(:,1:75), XTest(:,301:375)];

F = [XTest(:,76:150), XTest(:,376:450)];

H = [XTest(:,151:225), XTest(:,451:525)];

M = [XTest(:,226:300), XTest(:,526:600)];
