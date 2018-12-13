img = imresize(im2double(imread('images/tile.jpg')), 1, 'bilinear');

[rows, cols, depth] = size(img);
mask_l = false(rows,cols);
mask_r = false(rows,cols);
mask_l(:,1:5) = true;
mask_r(:,(cols-5):cols) = true;
img_back = zeros(rows,((cols*2)-5),depth);
img_front = zeros(rows,((cols*2)-5),depth);
[long_r, long_c,depth] = size(img_back);
img_back(:,1:cols,:) = img;
img_front(:,((long_c-cols+1):long_c),:) = img;
imshow(img_front);
mask = false(rows,((cols*2)-5));
mask(:,((long_c-cols+1):long_c)) = true;
dP_r = [1,(long_c-cols+1);rows,(long_c-cols+1);rows,long_c;1,long_c];
% get source region mask from the user
%[objmask, sx, sy] = getMask(im_object);
%init_dP = [sy' sx'];
% align im_s and mask_s with im_background
%[im_s, mask_s, dP] = alignSource(im_object, objmask, im_background, init_dP);
% dP_l = [1,1;rows,1;rows,5;1,5];

% 
% mask_nl = ~mask_l;
% mask_nr = ~mask_r;
% backl = img;
% backr = img;
% 
% left = img;
% right = img;
% backl(repmat(mask_nl, [1 1 3])) = 0;
% backr(repmat(mask_nr, [1 1 3])) = 0;
% left(repmat(mask_nl, [1 1 3])) = 0;
% right(repmat(mask_nr, [1 1 3])) = 0;
% size(backl)
% size(backr)
% % figure;
% % imagesc(im_src);
% % axis ij;
% % figure;
% % imagesc(im_bgr);
% % axis ij;
% 
% [merge_img] = mvc_clone(left,backl,dP_l,mask_l);
% [merge_img2] = mvc_clone(right,backr,dP_r,mask_r);
% imshow(merge_img);
% %merge_img(repmat(mask_nl, [1 1 3])) = img(repmat(mask_nl, [1 1 3]));
% %merge_img2(repmat(mask_nr, [1 1 3])) = img(repmat(mask_nr, [1 1 3]));
% 
% figure,imshow(cat(2,merge_img2,merge_img));