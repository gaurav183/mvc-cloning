function [merge_img] = mvc_clone(src_img,target_img,dP,mask)
% dP is an m x 2 matrix of (row,col) coordinates of the m boundary points
%
    [m,~] = size(dP);
    
    [r_m, c_m] = find(mask);
    
    intDP = round(dP);
    for i=1:m
       sq_dists = ([r_m, c_m] - dP(i,:)).^2;
       dists = sum(sq_dists,2);
       [~,ind] = min(dists);
       intDP(i,:) = [r_m(ind), c_m(ind)];
    end
    
    numP = numel(r_m);

    all_lambda = zeros(numP, m);

    
    for x=1:numP
        all_lambda(x, :) = MVC(r_m(x),c_m(x),dP);
    end
    
    diffs = zeros(1,m,3);
    for d=1:3
        for i=1:m
            pi = intDP(i,:);
            diffs(:,i,d) = target_img(pi(1), pi(2),d) - src_img(pi(1), pi(2),d);
        end
    end

    merge_img = target_img;
    
    for d=1:3
        for x=1:numP
            lamb_diff = all_lambda(x,:) .* diffs(:,:,d);
            rx = sum(lamb_diff);
            ind_i = r_m(x);
            ind_j = c_m(x);
            merge_img(ind_i,ind_j,d) = src_img(ind_i,ind_j,d) + rx;
        end
    end
    
end





