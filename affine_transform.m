function mosaic = affine_transform(imgLeft, imgRight)
%% Part 2A.1
img_1_2_L = imgLeft;
img_1_2_LResize = imresize(img_1_2_L,0.7);
img_1_2_L_gray = rgb2gray(img_1_2_LResize);
img_1_2_L_single = im2single(img_1_2_L_gray);

img_1_2_R = imgRight;
img_1_2_RResize = imresize(img_1_2_R,0.7);
img_1_2_R_gray = rgb2gray(img_1_2_RResize);
img_1_2_R_single = im2single(img_1_2_R_gray); 

%% Part 2A.2
[f1,d1] = vl_sift(img_1_2_L_single);
[f2,d2] = vl_sift(img_1_2_R_single);

%% Part 2A.3
[matches, scores] = vl_ubcmatch(d1,d2) ;
dist =dist2(single(d1)',single(d2)');

%% Part 2A.4
prune = 150;
[matches1, matches2] = find(dist < prune);
m1 = f1(:, matches1);
m2 = f2(:, matches2);

%% Part 2A.5 & 2A.6
m1_Points = m1(1:2,:)';
m1_Points(:, 3) = 1;
rho = 0.7;
N = 50;
inliers = 0;
count = 0;
perm = randperm(length(m1),3);

for i = 1:N
    m1_Perm = [m1(1:2, perm); [1,1,1]]';
    m2_Perm = m2(1:2, perm);
    N2 = length(m1_Points);
    affine = m1_Perm\m2_Perm';
    transformation = m1_Points * affine - m2(1:2,:)';
    for j = 1:N2
        if transformation(j,1) < rho && transformation(j,2)< rho
            count = count + 1;
        end
    end
end

if count > inliers
    inliers = count;
    optimalTransformation = affine;
end
optimalTransformation = [optimalTransformation'; [0 0 1]];

%% Part 2A.7
warpImage = maketform('affine', optimalTransformation');
mosaic = imtransform(img_1_2_L, warpImage);