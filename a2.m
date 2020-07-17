% Change the below line to the location of vl_setup.m
%run('C:/Program Files/VLFEATROOT/toolbox/vl_setup.m')
run('/Applications/VLFEATROOT/toolbox/vl_setup.m')

%% Part 1.1
x = randn(size(1:500))';
y = randn(size(1:500))';
a = 4;
b = 1;
gamma = 3;
z = (a * x) + (b * y) + gamma;
z = z + randn(size(x));

%% Part 1.2
A = [x y ones(size(x))];
mb_estimate = A\z;
estimateA = mb_estimate(1);
estimateB = mb_estimate(2);
estimateGamma = mb_estimate(3);

%% Part 1.3
fprintf('Alpha Error is %.2f\n', abs(a - estimateA));
fprintf('Beta Error is %.2f\n', abs(b - estimateB));
fprintf('Gamma Error is %.2f\n', abs(gamma - estimateGamma));

%% Part 2A
imgLeft2A = imread('parliament-left.jpg');
imgRight2A = imread('parliament-right.jpg');
mosaic2A = affine_transform(imgLeft2A,imgRight2A);

figure(1);
blankImageA = zeros(2750, 3886, 3);
image(blankImageA);
hold on;
image ([0 2645], [100, 2750], mosaic2A);
image ([1520 3886], [295, 2695], imgRight2A);
title('Parliament Stitched Together');
fprintf("Paused! Press Enter to Continue!\n");
pause();

%% Part 2B-1
imgLeft2B = imread('Ryerson-left.jpg');
imgRight2B = imread('Ryerson-right.jpg');
mosaic2B = homography_transform(imgLeft2B,imgRight2B,1);

figure(2);
blankImageB = zeros(3082, 4551, 3);
image(blankImageB);
hold on;
image ([1412 4551], [0 3082], mosaic2B);
image ([0 2448], [350, 2798], imgRight2B);
title('Ryerson Statue Stitched Together');
fprintf("Paused! Press Enter to Continue!\n");
pause();

%% Part 2B-2 (Own Images)
imgLeft2C = imread('mountain_left.jpg');
imgRight2C = imread('mountain_right.jpg');
mosaic2C = homography_transform(imgRight2C,imgLeft2C,2);

figure(3);
blankImageC = zeros(3082, 4551, 3);
image(blankImageC);
hold on;
image ([0 4551], [95 2982], mosaic2C);
image ([0 3668], [0, 2928], imgLeft2C);
title('Mountains Stitched Together');
fprintf("Paused! Press Enter to Continue!\n");
pause();

%% Part 3.1 -BONUS
imgLeft_3_1 = imread('LakeDevo_2.jpg');
imgRight_3_1 = imread('LakeDevo_1.jpg');
mosaic_3_1 = homography_transform(imgLeft_3_1,imgRight_3_1,2);

figure(4);
blankImageThree = zeros(3082, 4000, 3);
image(blankImageB);
hold on;
image ([412 4551], [0 3082], mosaic_3_1);
image ([1520 3899], [970, 2848], imgRight_3_1);
title('Ryerson Lake Devo Bonue');
fprintf("This is Bonus 3.1\n");
fprintf("Paused! Press Enter to Continue!\n");
pause();

%% Part 3.2 -BONUS
imgLeft2A = imread('parliament-left.jpg');
imgRight2A = imread('parliament-right.jpg');
mosaic3 = affine_transform(imgLeft2A,imgRight2A);
Gaussian_filter = fspecial('gaussian',[13 13],5);
blend1 = imfilter (mosaic3,Gaussian_filter,'same');
blend2 = imfilter (imgRight2A,Gaussian_filter,'same');
figure(5);
blankImageA = zeros(2750, 3886, 3);
image(blankImageA);
hold on;
image ([0 2645], [100, 2750], blend1);
image ([1520 3886], [295, 2695], blend2);
title('Blended Image Bonus 3.2 Before');
fprintf("This is Bonus 3.2 Blending Before\n");

figure(6);
blankImageA = zeros(2750, 3886, 3);
image(blankImageA);
hold on;
image ([0 2645], [100, 2750], mosaic3);
image ([1520 3886], [295, 2695], imgRight2A);
title('Blended Image Bonus 3.2 After');
fprintf("This is Bonus 3.2 Blending After\n");
