function [merge_img, rxes] = mvc_clone(src_img,target_img,dP,mask)
% dP is an m x 2 matrix of (row,col) coordinates of the m boundary points
%
    [m,~] = size(dP);
    
    [r_m, c_m] = find(mask);
    
    % snap boundary points to closest point in mask
    for i=1:m
       sq_dists = ([r_m, c_m] - dP(i,:)).^2;
       dists = sum(sq_dists,2);
       [~,ind] = min(dists);
       dP(i,:) = [r_m(ind), c_m(ind)];
    end
    
    numP = numel(r_m);

    all_lambda = zeros(numP, m);

    
    for x=1:numP
        all_lambda(x, :) = MVC(r_m(x),c_m(x),dP);
    end
    
    all_lambda(imag(all_lambda) ~= 0) = 0;
    
    diffs = zeros(1,m,3);
    for d=1:3
        for i=1:m
            pi = dP(i,:);
            diffs(:,i,d) = target_img(pi(1), pi(2),d) - src_img(pi(1), pi(2),d);
        end
    end

    merge_img = target_img;
    
    % convex shape so inverse weighting of distance from center
    midR = (max(r_m)+min(r_m))/2;
    midC = (max(c_m)+min(c_m))/2;
    
    sq_dist = (dP - [midR, midC]).^2;
    dists = sum(sq_dist,2);
    maxDist = max(dists);
    
    rxes = zeros(numP*3,3);
        
    for d=1:3
        for x=1:numP
            lamb_diff = all_lambda(x,:) .* diffs(:,:,d);
            rx = sum(lamb_diff);
            ind_i = r_m(x);
            ind_j = c_m(x);
            
            w = 1;
                
            % weighting
%             sq_dist = ([midR, midC] - [ind_i, ind_j]).^2;
%             dist = sum(sq_dist);
%             
%             if (~(ismember([ind_i,ind_j],dP,'rows')) && dist<0.3*maxDist)                
%                 w = dist/(0.3*maxDist);
%             end
       
            
            merge_img(ind_i,ind_j,d) = src_img(ind_i,ind_j,d) + rx * w;
            rxes(x+numP*(d-1), :) = [ind_i,ind_j,rx]; 
        end
    end
    
end





