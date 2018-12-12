function [merge_img] = stitch_poisson(src_img,tar_img)
    [rows, cols, depth] = size(src_img);
    mask =  zeros(rows,cols);
    mask(2:rows-1,2:cols-1) = 1;
    num_points = (rows-2)*(cols-2);
    r = zeros(num_points,1);
    c = zeros(num_points,1);

    k=1;
    for i=1:rows
        for j=1:cols
            if mask(i,j)==1
                r(k) = i;
                c(k) = j;
                k = k+1;
            end
        end
    end

    index_matr = zeros(rows, cols);
    im2idx = zeros(rows-2, cols-2);
    im2idx(1:num_points) = 1:num_points;
    index_matr(2:rows-1,2:cols-1) = im2idx;
    % calculate laplacian at each point in source image

    src_img = double(src_img);
    grad_filt = [0 -1 0; -1 4 -1; 0 -1 0];
    grad_img = imfilter(src_img,grad_filt);

    
    num_vars = num_points*5;
    B = zeros(num_points,3);
    ROW = zeros(num_vars,1);
    COL = zeros(num_vars,1);
    VAL = zeros(num_vars,1);
    cur_var = 1;
    cur_eq = 1;

    %determine A matrix
    
    for y = 2:rows-1
        for x = 2:cols-1
            if mask(y,x) == 1
                %point above
                if  (mask(y-1,x) == 1)
                    ROW(cur_var) = cur_eq;
                    COL(cur_var) = index_matr(y-1,x);
                    VAL(cur_var) = -1;
                    cur_var = cur_var + 1;
                else
                    for chnl=1:3
                        B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(tar_img(y-1,x,chnl));
                    end
                end
                
                % point bottom
                if mask(y+1,x) == 1
                    ROW(cur_var) = cur_eq;
                    COL(cur_var) = index_matr(y+1,x);
                    VAL(cur_var) = -1;
                    cur_var = cur_var + 1;
                else
                    for chnl=1:3
                        B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(tar_img(y+1,x,chnl));
                    end
                end

                %point left
                if mask(y,x-1) == 1
                    ROW(cur_var) = cur_eq;
                    COL(cur_var) = index_matr(y,x-1);
                    VAL(cur_var) = -1;
                    cur_var = cur_var + 1;
                else
                    for chnl =1:3
                        B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(tar_img(y,x-1,chnl));
                    end
                end

                % point right
                if mask(y,x+1) == 1
                    ROW(cur_var) = cur_eq;
                    COL(cur_var) = index_matr(y,x+1);
                    VAL(cur_var) = -1;
                    cur_var = cur_var + 1;
                else
                    for chnl=1:3
                        B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(tar_img(y ,x+1,chnl));
                    end
                end
                ROW(cur_var) = cur_eq;
                COL(cur_var) = index_matr(y,x);
                VAL(cur_var) = 4;
                cur_var = cur_var + 1;
                
                for  chnl =1:3
                    B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + grad_img(y,x,chnl);
                end
                
                cur_eq = cur_eq + 1;
            end
        end
    end
    
    A = sparse(ROW(1:(cur_var-1)),COL(1:(cur_var-1)),VAL(1:(cur_var-1)),num_points,num_points);
    merge_img = double(tar_img);
    
    solns = A\B;
    for k = 1:num_points
        merge_img(r(k),c(k),:) = solns(k,:);
    end
    merge_img = uint8(merge_img);

end