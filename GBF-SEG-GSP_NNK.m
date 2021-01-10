clc;
clear all;
close all;
addpath('C:/Users/ASUS/Documents/David Universidad/IX SEMESTRE/TRABAJO DE GRADO/Smoothness/Codes/GBF-CD/Data');
addpath(genpath([pwd , '/GSP']));
addpath(genpath([pwd , '/NNK']));
addpath(genpath([pwd , '/graph cut']));
addpath(genpath([pwd , '/minf']));

%tic

datasets = {'sardania_dataset','omodeo_dataset','alaska_dataset','Madeirinha_dataset',...
    'katios_dataset','dique_dataset','SF_dataset','Wenchuan_dataset','canada_dataset',...
    'california_flood','contest_dataset','toulouse_dataset','Bastrop_dataset',...
    'gloucester_dataset'};

%To tune the classes number for each dataset
stop=[0.0001,0.015,0.001,0.003,...
    0.001,0.000008,0.000235,0.0006,0.0002,...
    0.000115,0.00007,0.0000095,0.0025,...
    0.000015];

scales=[1,1,1,1,1,1,1,1,1,1,1,1,1,1];
%The minimum k-value for grid-search in the GSP approach corresponding to
%each dataset
kmin=[3,2,57,13,2,2,137,2,5,12,4,7,4,5];
k_Best=[6,1188,266,353,574,594,140,525,1662,336,431,269,11,218];
sigma_f_Best=[0.105,0.389,0.213,0.011,0.113,0.086,0.033,0.044,0.003,0.347,0.06,0.481,0.003,0.415];
gsp_start();%Initialize GSPBox

%% Application of GBF-SEG-GSP and GBF-SEG-NNK for all 14 datasets
for n=13:13
    %% Loading pre (p1) and post (p2) images for the corresponding dataset
    load(datasets{n});
    [rowOrg , colOrg]=size(before);

    p1=imresize(before,scales(n));
    p2=imresize(after,scales(n));
    disp(['Min before: ',num2str(min(p1(:)))])
    disp(['Max before: ',num2str(max(p1(:)))])
    disp(['Min after: ',num2str(min(p2(:)))])
    disp(['Max after: ',num2str(max(p2(:)))])
    cankao=gt;
    %% Vectorization of the images p1 and p2
    
    f1=p1(:,:,1);
    f1=im2double(f1);
    f2=p2(:,:,1);
    f2=im2double(f2);
    [N C]=size(f1);
    ff1=reshape(f1,N*C,1);
    ff2=reshape(f2,N*C,1);
    %p=abs(f1-f2);
    %% Prior computation
    prior1  = (f2(:,:,1) - f1)./((f2(:,:,1) + f1));
    prior2  = (f1 - f2(:,:,1))./((f2(:,:,1) + f1));
    prior = imbinarize(prior1) + imbinarize(prior2);
    prior = imbinarize(prior);
    %% Segmentation
    [A B D biaoji]=imgsegment(prior,20,stop(n));     
    max(biaoji)
    figure(1);
    imshow(B,[]);
    feature1=ff1;
    feature2=ff2;
    feature3=reshape(prior,N*C,1);
    NumClases=max(biaoji)-min(biaoji)+1;
    %% Construction of the vector w./ the representative pixels (mean) of each class
    region1=zeros(NumClases,1);%Processed pre-event
    region2=zeros(NumClases,1);%Processed post-event
    region3=zeros(NumClases,1);%Processed prior
    for j=min(biaoji):max(biaoji)                 
        tmp=find(biaoji==j);
          b1=feature1(tmp,:);
          b2=feature2(tmp,:);
          b3=feature3(tmp,:);
          region1(j-min(biaoji)+1,1:size(feature1,2))=mean(mean(b1));
          region2(j-min(biaoji)+1,1:size(feature1,2))=mean(mean(b2)); 
          region3(j-min(biaoji)+1,1:size(feature1,2))=mean(mean(b3));

    end
    region3=imbinarize(region3);
    prior=region3;
    %% Grid-search per method for each dataset
    KappaBest=0;
    sigma_d = 2; 
    wsz = 5; % Window size is (2*wsz + 1). For e.g wsz=5 --> 11x11 window
    for method=1:2
        metrics=[];
        if method==1
            %Grid-search limits for K in GSP
            LimMin=kmin(n);
            Step=1;
            LimMax=max(biaoji)-2;
            %Best k 
            LBest=k_Best(n);

        elseif method==2
            %Grid-search limits for sigma_f in NNK
            LimMin=0.001;
            Step=0.001;
            LimMax=1;
            %Best sigma_f
            LBest=sigma_f_Best(n);

        end
        %for Param=LimMin:Step:LimMax %Grid-search
        for Param=LBest:1:LBest
            close all
            %% Graph learning
            if method==1
                W=graph_learning_GSP(region1,region2,Param);%Fusioned GSP graph  
            end
            if method==2
                W = graph_learning_BF(region1,region2,wsz,Param, sigma_d);%Fusioned NNK graph 
            end
            disp('Fusion done')
            %% Spectral decomposition in eigenvectors and its eigenvalues
            [U_s,D_s] = eig(W);
            MI = zeros(1,max(biaoji));
            %% Best change map choice (considering the MI w./ the prior)
            for d = 2 : max(biaoji)
                labels = U_s(:,d)*sqrt(D_s(d,d));
                labels = imbinarize(abs(labels));
                MI(d) =  mi(prior,labels);%Mutual info. between and each spectral version
                clear Iaux;
            end
            i = find(MI == max(MI),1,'first');
            labels = U_s(:,i)*sqrt(D_s(i,i));
            labels = imbinarize(abs(labels));
            %% Expansion of the best change map
            %If the representative pixel of a class changes, all the pixels
            %belonging to the same class change as well.
            g=zeros(length(biaoji),1);
            for j=1:NumClases
                tmp=find(biaoji==(min(biaoji)-1+j));
                if labels(j)==1
                    g(tmp)=1;
                end

            end
            CH=reshape(g,N,C);
            Change_Map=reshape(CH,N,C);
            Change_Map=logical(Change_Map);
            Change_Map=imresize(Change_Map,[rowOrg colOrg]);
            figure, imshow(Change_Map,[]);
            title('Change_map')
            set(gca,'FontSize',12)
            drawnow
            %% Metrics and error map
            [MA, FA, Precision, recall, kappa, OE] = cohensKappa(cankao,Change_Map);
            if kappa>KappaBest
                KappaBest=kappa;
                if method==1
                    kBest=Param;
                end
                if method==2
                    sigma_fBest=Param;
                end
            end
            metrics(end+1,:)=[Param,MA, FA, Precision, recall,max(MI), kappa, OE];
       
        end
    %% Results summary creation
    if method==1
        filename = strcat('GSP_',datasets{n},'_',num2str(stop(n)),'_',num2str(max(biaoji)),'.xlsx');
    end
    if method==2
        filename = strcat('NNK_',datasets{n},'_',num2str(stop(n)),'_',num2str(max(biaoji)),'.xlsx');
    end
    writematrix(metrics,filename);    
    clear metrics     
    end
clearvars -except datasets scales stop kmin step
end
