function [merge_img] = mvc_clone(src_img,target_img,dP)
% dP is an m x 2 matrix of (row,col) coordinates of the m boundary points
%
	[h_src, w_src, ~] = size(src_img);
    [h_trg, w_trg, ~] = size(target_img);
    
    all_lambda = zeros(h_src*w_src, m);
    for i=1:h_src
        for j=1:w_src
        	x = sub2ind([h_src,w_src], i, j);
       		all_lambda(x, :) = MVC(i,j,dPs); %i,j or j,i?
        end
    end
    
    diffs = zeros(1,m);
    for i=1:m
    	pi = dP(i,:);
        diffs(i) = target_img(pi(1), pi(2)) - src_img(pi(1), pi(2));
    end
    
    f = zeros(h_trg, w_trg);
    for i=1:h_trg
        for j=1:h_src
        	x = sub2ind([h_src,w_src], i, j);
            lamb_diff = all_lambda(x,:) .* diffs;
            rx = sum(lamb_diff);
            f(i,j) = src_img(i,j) + rx;
        end
  	end
    
end





