img = imread('images/tile.jpg');

right = img;
left = img;
right(:,1,:) = (right(:,1,:) + left(:,end,:))/2;
left(:,end,:) = right(:,1,:);
right = stitch_poisson(tile_img,right);
left = stitch_poisson(tile_img,left);

figure,imshow(cat(2,left,right));