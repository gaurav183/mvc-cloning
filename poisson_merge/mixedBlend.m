
function [image_out] = mixedBlend(image_src,image_mask, image_bgd)
[b_height, b_width, b_depth] = size(image_bgd);
image_out = zeros(b_height,b_width,b_depth);
pixels = b_height*b_width;
im2idx = zeros(b_height, b_width);
im2idx(1:pixels) = 1:pixels;
num_pts = 5*b_width*b_height;
Ax = zeros(num_pts,1);
Ay = zeros(num_pts,1);
Av = zeros(num_pts,1);
b = zeros(pixels,1);
laplacianFilter = [0,1,0;1,-4,1;0,1,0];
for color = 1:3
    cur_bgd_grad = conv2(image_bgd(:,:,color), laplacianFilter, 'same');
    cur_src_grad = conv2(image_src(:,:,color), laplacianFilter, 'same');
    pt_count = 1;
    for i = 1:b_height
        for j = 1:b_width
            cur_eq = im2idx(i,j);
            if (image_mask(i,j) == 1)
                Ax(pt_count) = cur_eq;
                Ay(pt_count) = cur_eq;
                Av(pt_count) = -4;
                pt_count = pt_count + 1;
                Ax(pt_count) = im2idx(i-1,j);
                Ay(pt_count) = cur_eq;
                Av(pt_count) = 1;
                pt_count = pt_count + 1;
                Ax(pt_count) = im2idx(i+1,j);
                Ay(pt_count) = cur_eq;
                Av(pt_count) = 1;
                pt_count = pt_count + 1;
                Ax(pt_count) = im2idx(i,j-1);
                Ay(pt_count) = cur_eq;
                Av(pt_count) = 1;
                pt_count = pt_count + 1;
                Ax(pt_count) = im2idx(i,j+1);
                Ay(pt_count) = cur_eq;
                Av(pt_count) = 1;
                pt_count = pt_count + 1;
                bgd_grad = abs(cur_bgd_grad(i,j));
                src_grad = abs(cur_src_grad(i,j));
                if (src_grad > bgd_grad)
                    b(cur_eq) = cur_src_grad(i,j);
                else
                    b(cur_eq) = cur_bgd_grad(i,j);
                end
            else
                Ax(pt_count) = cur_eq;
                Ay(pt_count) = cur_eq;
                Av(pt_count) = 1;
                b(cur_eq) = image_bgd(i,j,color);
                pt_count = pt_count + 1;
            end
        end
    end
    A = sparse(Ay(1:(pt_count-1)),Ax(1:(pt_count-1)),Av(1:(pt_count-1)),pixels,pixels);
    v = A\b;
    image_out(:,:,color) = reshape(v,b_height,b_width);
end
end



