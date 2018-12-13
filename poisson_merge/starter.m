% starter script for project 3
DO_TOY = false;
DO_BLEND = true;
DO_MIXED  = false;
DO_COLOR2GRAY = false;
DO_FLASH = false;

if DO_TOY 
    toyim = im2double(imread('../data/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    disp(['Error: ' num2str(sqrt(sum(toyim(:)-im_out(:))))])
    imwrite(im_out,'../data/toy_result.png');
end

if DO_BLEND
    %im_background = imresize(im2double(imread('../data/hiking.jpg')), 0.5, 'bilinear');
    %im_object = imresize(im2double(imread('../data/penguin.jpg')), 0.5, 'bilinear');
    %im_background = imresize(im2double(imread('../data/ocean.jpeg')), 0.5, 'bilinear');
    %im_object = imresize(im2double(imread('../data/black_manta.png')), 0.5, 'bilinear');
    %im_background = imresize(im2double(imread('../data/sky.jpg')), 0.5, 'bilinear');
    %im_object = imresize(im2double(imread('../data/king.jpg')), 0.5, 'bilinear');
    im_background = imresize(im2double(imread('../data/beach.png')), 1, 'bilinear');
    im_object = imresize(im2double(imread('../data/bear2.png')), 0.7, 'bilinear');
    
    % get source region mask from the user
%     objmask = getMask(im_object);


    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(mask_s)
    figure;
    imagesc(im_blend);
    axis ij;
%     imwrite(im_blend, '../data/myblend_result3.png');
end

if DO_MIXED
    % read images
    %...
    %im_background = imresize(im2double(imread('../data/hiking.jpg')), 0.5, 'bilinear');
    %im_object = imresize(im2double(imread('../data/penguin.jpg')), 0.5, 'bilinear');
    %im_background = imresize(im2double(imread('../data/ocean.jpeg')), 0.5, 'bilinear');
    %im_object = imresize(im2double(imread('../data/black_manta.png')), 0.5, 'bilinear');
    %im_background = imresize(im2double(imread('../data/sky.jpg')), 0.5, 'bilinear');
    %im_object = imresize(im2double(imread('../data/king.jpg')), 0.5, 'bilinear');
    im_background = imresize(im2double(imread('../data/sunset.jpg')), 0.5, 'bilinear');
    im_object = imresize(im2double(imread('../data/ironman.jpg')), 0.5, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend);
    imwrite(im_blend, '../data/mymixedblend_result3.png');
end

if DO_FLASH
    %im_flash = im2double(imread('../data/museum_flash.png'));
    %im_no_flash = im2double(imread('../data/museum_ambient.png'));
    im_flash = im2double(imread('../data/flash.JPG'));
    im_no_flash = im2double(imread('../data/ambient.JPG'));
    output_img = flashMerge(im_flash,im_no_flash);
    figure(4), hold off, imshow(output_img);
    imwrite((output_img/18), '../data/myflash_merge.png');
end

if DO_COLOR2GRAY
    im_rgb = im2double(imread('./samples/colorBlindTest35.png'));
    im_gr = color2gray(im_rgb);
    figure(4), hold off, imagesc(im_gr), axis image, colormap gray
end
