im_background = imresize(im2double(imread('data/beach.png')), 1, 'bilinear');
im_object = imresize(im2double(imread('data/bear2.png')), 0.7, 'bilinear');


% get source region mask from the user
% [objmask, sx, sy] = getMask(im_object);
% init_dP = [sy' sx'];
% align im_s and mask_s with im_background
% im_background = merge_img;
[im_s, mask_s, dP] = alignSource(im_object, objmask, im_background, init_dP);
dP

mask_ns = ~mask_s;
im_src = im_background;
im_bgr = im_background;
im_src(repmat(mask_ns, [1 1 3])) = 0;
im_bgr(repmat(mask_ns, [1 1 3])) = 0;
im_src(repmat(mask_s, [1 1 3])) = im_s(repmat(mask_s, [1 1 3]));

% figure;
% imagesc(im_src);
% axis ij;
% figure;
% imagesc(im_bgr);
% axis ij;

% [merge_img] = stitch_poisson(im_src,im_bgr);
[merge_img, rxes] = mvc_clone(im_src,im_bgr,dP,mask_s);
merge_img(repmat(mask_ns, [1 1 3])) = im_background(repmat(mask_ns, [1 1 3]));

figure;
imagesc(merge_img);
axis ij;
% figure(3), hold off, imshow(im_blend)