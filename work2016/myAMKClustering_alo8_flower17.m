clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'flower17'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10; caltech101_mit
%% %% washington; wisconsin; texas; cornell; caltech101_nTrain25_48
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
% load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = kcenter(KH);
KH = knorm(KH);
qnorm = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.1:0.1:0.1];
for ie =1:length(epsionset)
    for iter = 1:1
        load([path,'work2016/generateAbsentMatrix/',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        
        %%%%%%%%--Initialization with Zero---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        algorithm_chosen1 = 'algorithm2';
        [H_normalized6,gamma6,obj6,KH6] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_chosen1);
        res1 = myNMIACC(H_normalized6,Y,numclass);
        
%         %%%%%%%%%%%%%----Initialization with mean---%%%%%%%%%%%%%%%%%%%%
%         algorithm_chosen2 = 'algorithm3';
%         [H_normalized7,gamma7,obj7,KH7] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_chosen2);
%         res2 = myNMIACC(H_normalized7,Y,numclass);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              
%         %%%%%%%%%%%%%----Initialization with knn---%%%%%%%%%%%%%%%%%%%%
%         algorithm_chosen3 = 'algorithm0';
%         [H_normalized8,gamma8,obj8,KH8] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_chosen3);
%         res3 = myNMIACC(H_normalized8,Y,numclass);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        algorithm_choose8 = 'algorithm2';
%         lambdaset8 = 2.^[-15:2:15];
        lambdaset8 = 2.^-15;
        accval8 = zeros(length(lambdaset8),1);
        nmival8 = zeros(length(lambdaset8),1);
        purval8 = zeros(length(lambdaset8),1);
        algval8 = zeros(length(lambdaset8),1);
        for il =1:length(lambdaset8)
            [H_normalized8,gamma8,obj8,KH8] = myamkcwithlambda(KH,S,numclass,qnorm,algorithm_choose8,lambdaset8(il));
            res8 = myNMIACC(H_normalized8,Y,numclass);
            accval8(il) = res8(1);
            nmival8(il) = res8(2);
            purval8(il) = res8(3);
        end    
        save([path,'work2016/myAbsentMKCresParaSel/',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_alg8_iter_',num2str(iter),'.mat'],'res1','res2','res3','accval8','nmival8','purval8');
    end
end
