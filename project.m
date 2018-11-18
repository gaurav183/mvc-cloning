im_background = imresize(im2double(imread('data/target.png')), 1, 'bilinear');
im_object = imresize(im2double(imread('data/plane.png')), 0.5, 'bilinear');

% get source region mask from the user
[objmask, sx, sy] = getMask(im_object);
% align im_s and mask_s with im_background
[im_s, mask_s] = alignSource(im_object, objmask, im_background);

mask_ns = ~mask_s;
im_src = im_background;
im_bgr = im_background;
im_src(repmat(mask_ns, [1 1 3])) = 0;
im_bgr(repmat(mask_ns, [1 1 3])) = 0;
im_src(repmat(mask_s, [1 1 3])) = im_s(repmat(mask_s, [1 1 3]));

dP = [sy' sx'];
[merge_img] = mvc_clone(im_src,im_bgr,dP);
merge_img(repmat(mask_ns, [1 1 3])) = im_background(repmat(mask_ns, [1 1 3]));
% figure(3), hold off, imshow(im_blend)