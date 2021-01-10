function W = graph_learning_BF(region1,region2,wsz,sigma_f, sigma_d)
regions = cell(2,1);
wl = cell(2,1);
regions{1}=region1./max(region1);
regions{2}=region2./max(region2);
regions{1}=region1;
regions{2}=region2;
for i = 1 : 2
    %ZAA = gsp_distanz(regions{i}');
    %[WsmoothAA,~] = bilateral_graph(ZAA, wsz, 2*sigma_f^2, 2*sigma_d^2);
    %[WsmoothAA,~] = bilateral_graph(regions{i}, wsz, 2*sigma_f^2, 2*sigma_d^2);
    [WsmoothAA,~] = smart_nnk_inverse_kernel_graph(regions{i}, wsz, 2*sigma_f^2, 2*sigma_d^2);
%     [thetaAA, theta_min_All, theta_max_All] = gsp_compute_graph_learning_theta(ZAA,ksmooth);
%     Rango_Theta_Pre_Post{i}=Rango_Theta(theta_min_All,theta_max_All);
%     [WsmoothAA] = gsp_learn_graph_log_degrees(ZAA*thetaAA,1,1);
%     WsmoothAA(WsmoothAA<1e-4) = 0;
    wl{i} = full(WsmoothAA);
end
%clear Xl Xl_AA
%% Multimodal Weights

%n = length();
W = min(cat(3,wl{1} , wl{2}),[],3);

% W = nan(size(wl{1},1),size(wl{1},2));
% for a = 1:size(wl{1},1)
%     for b = 1:size(wl{1},2)
%         W(a,b) = min(wl{1}(a,b),wl{2}(a,b));
%     end
% end

end

