function W=graph_learning_GSP(region1,region2,ksmooth)
regions = cell(2,1);
wl = cell(2,1);
% regions{1}=region1./max(region1);
% regions{2}=region2./max(region2);
regions{1}=region1;
regions{2}=region2;
for i = 1 : 2
    ZAA = gsp_distanz(regions{i}');
    [thetaAA, theta_min_All, theta_max_All] = gsp_compute_graph_learning_theta(ZAA,ksmooth);
    Rango_Theta_Pre_Post{i}=Rango_Theta(theta_min_All,theta_max_All);
    [WsmoothAA] = gsp_learn_graph_log_degrees(ZAA*thetaAA,1,1);
    WsmoothAA(WsmoothAA<1e-4) = 0;
    wl{i} = WsmoothAA;
end
%clear Xl Xl_AA
%% Multimodal Weights

%n = length();
W = min(cat(3,wl{1} , wl{2}),[],3);
% block_size=max(biaoji);
% temp1 = sum(region1.*region1, 2);
% aa1=temp1(:,ones(block_size, 1));
% ab1 = region1*region1';
% temp2= sum(region1'.*region1', 1);
% bb1=temp2(ones(block_size, 1),:);
% 
% temp3 = sum(region2.*region2, 2);
% aa2=temp3(:,ones(block_size, 1));
% ab2 = region2*region2';
% temp4= sum(region2'.*region2', 1);
% bb2=temp4(ones(block_size, 1),:);
% clear temp1 temp2 temp3 temp4;
% dist1 = aa1 + bb1 - 2*ab1;
%   dist1 = -dist1/(2*sigma*sigma);
%   dist1=exp(dist1);
%   
%   dist2 = aa2 + bb2 - 2*ab2;
%   dist2 = -dist2/(2*sigma*sigma);
%   dist2=exp(dist2);
%   clear aa1 ab1 bb1 aa2 ab2 bb2;
%   diff=exp(-(region1-region2).^2/(2*sigma*sigma));
%   A=abs(dist1-dist2)+diff(:,ones(block_size, 1));
%   clear dist1 dist2;
%   A1 = triu(A);
% A1 = A1 + A1';
% A2 = tril(A);
% A2 = A2 + A2';
% clear A;
%  A = max(A1, A2);
%  clear A1 A2;
% 
% B = spdiags(diag(A), 0, block_size, block_size);
% A = A - B;
% W=A+lamata*diag(diff);
% 
% %     for i=1:max(biaoji)-1 
% %          W0(i)=lamata*(1-exp(-norm(region1(i,:)-region2(i,:),2)^2/2*dx^2));
% %        for j=i+1:max(biaoji) 
% %      W2(i,j)=exp(-norm(region1(i,:)-region1(j,:),2)^2/2*dx^2);
% %      W3(i,j)=exp(-norm(region2(i,:)-region2(j,:),2)^2/2*dx^2);
% %      
% % %    W(i,j)=1-min(W2(i,j),W3(i,j))/max(W2(i,j),W3(i,j));
% % %     W(i,j)=max(W2(i,j),W3(i,j))-min(W2(i,j),W3(i,j))+W0(i)+(1-exp(-norm(region1(j,:)-region2(j,:),2)^2/2*dx^2));
% % %  W(i,j)=abs(log(W2(i,j)/W3(i,j)));
% % % W1(j)=1-exp(-norm(region1(j,:)-region2(j,:),2)^2/2*dx^2)+0.00001;
% % % W1(i)=1-exp(-norm(region1(i,:)-region2(i,:),2)^2/2*dx^2)+0.00001;
% % W(i,j)=abs(W2(i,j)-W3(i,j))+W0(i);
% %        end
% %     % W(i,:)=(W(i,:)-min(W(i,:)))/(max(W(i,:)-min(W(i,:))));
% %     end
% %     clear W2 W3;
% % %    D=abs(W2-W3);
% % %     for i=1:max(biaoji) 
% % %        for j=i+1:max(biaoji) 
% % %            if D(i,j)<delta
% % %                W(i,j)=W3(i,j)+W2(i,j)/2;
% % %            else
% % %                W(i,j)=W3(i,j)+W2(i,j);
% % %            end
% % %        end
% % %     end
% %  W0=[W0,W0(1)];
% % % W0=zeros(1,max(biaoji));
% % W0=diag(W0);
% %      dusu=zeros(1,max(biaoji));
% %    W=[W;dusu];
% %    W=W+W';   
% %     W=W+W0 ;   
%     
