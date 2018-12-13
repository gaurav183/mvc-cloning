function [output_img] = flashMerge(flash_img,no_flash_img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sigma = 40;
ts = 0.90;
[height,width,depth] = size(flash_img);
pixels = height*width;
num_eqs = 2*pixels + 1 - width - height;
num_pts = 2*width*height;
Ax = zeros(num_pts,1);
Ay = zeros(num_pts,1);
Av = zeros(num_pts,1);
A = sparse([],[],num_eqs,pixels,3*pixels);
b = zeros(num_eqs,1);
im2idx = zeros(height, width);
im2idx(1:pixels) = 1:pixels;
output_img = zeros(height,width,depth);
for color = 1:3
    ws = tanh(sigma*(flash_img(:,:,color) - ts));
    ws = (ws - min(min(ws)))/(max(max(ws)) - min(min(ws)));
    [gradFx, gradFy] = imgradientxy(flash_img(:,:,color));
    [gradNx, gradNy] = imgradientxy(no_flash_img(:,:,color));
    gradF = cat(3,gradFx,gradFy);
    gradN = cat(3,gradNx,gradNy);
    top = abs(sum(gradF.*gradN,3));
    %Mx = abs(dot(gradFx,gradNx))./(abs(gradFx).*abs(gradNx));
    M = top ./ (sqrt(sum(gradF.^2,3)).* sqrt(sum(gradN.^2,3)));
    M(isnan(M)) = 0;
%     Mx(isnan(Mx)) = 0;
%     My = abs(dot(gradFy,gradNy))./(abs(gradFy).*abs(gradNy));
%     My(isnan(My)) = 0;
    gradOutx = ws.*gradNx + (1 - ws).*(M.*gradFx + ((1 - M).* gradNx));%ws.*gradNx + (1 - ws).*(Mx.*gradFx + ((1 - Mx).* gradNx));
    gradOuty = ws.*gradNy + (1 - ws).*(M.*gradFy + ((1 - M).* gradNy));%ws.*gradNy + (1 - ws).*(My.*gradFy + ((1 - My).* gradNy));
    pt_count = 1; 
    eq_count = 1;
    for i = 1:height
        for j = 1:width 
        if (j < width)
            Ax(pt_count) = im2idx(i,j);
            Ay(pt_count) = eq_count;
            Av(pt_count) = -1;
            pt_count = pt_count + 1;
            Ax(pt_count) = im2idx(i,j+1);
            Ay(pt_count) = eq_count;
            Av(pt_count) = 1;
            b(eq_count) = gradOutx(i,j);
            pt_count = pt_count + 1;
            eq_count = eq_count + 1;
        end
        if (i < height)
            Ax(pt_count) = im2idx(i,j);
            Ay(pt_count) = eq_count;
            Av(pt_count) = -1;
            pt_count = pt_count + 1;
            Ax(pt_count) = im2idx(i+1,j);
            Ay(pt_count) = eq_count;
            Av(pt_count) = 1;
            b(eq_count) = gradOuty(i,j);
            pt_count = pt_count + 1;
            eq_count = eq_count + 1;
        end
        end
    end
    %Ax(pt_count) = im2idx(1,1);
    Ax(pt_count) = im2idx(1400,1000w);
    Ay(pt_count) = eq_count;
    Av(pt_count) = 1;
    %b(eq_count) = flash_img(1,1,color);
    b(eq_count) = flash_img(1400,1000,color);
    A = sparse(Ay(1:pt_count),Ax(1:pt_count),Av(1:pt_count),num_eqs,pixels);
    v = A\b;
    output_img(:,:,color) = reshape(v,height,width);
end
end

