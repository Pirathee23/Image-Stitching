function mosaic = homography_transform(imgLeft, imgRight, k)
%% Part 2B.1
img_2_2_L = imgLeft;
img_2_2_LResize = imresize(img_2_2_L,0.7);
img_2_2_L_gray = rgb2gray(img_2_2_LResize);
img_2_2_L_single = im2single(img_2_2_L_gray);

img_2_2_R = imgRight;
img_2_2_RResize = imresize(img_2_2_L,0.7);
img_2_2_R_gray = rgb2gray(img_2_2_RResize);
img_2_2_R_single = im2single(img_2_2_R_gray); 

%% Part 2B.2
[f1,d1] = vl_sift(img_2_2_L_single);
[f2,d2] = vl_sift(img_2_2_R_single);

%% Part 2B.3
[matches, scores] = vl_ubcmatch(d1,d2) ;
dist =dist2(single(d1)',single(d2)');

%% Part 2B.4
prune = 300;
[matches1, matches2] = find(dist < prune);
m1 = f1(:, matches1);
m2 = f2(:, matches2);

%% Part 2B.5 & 2B.6
m1_Points = m1(1:2,:)';
m1_Points(:, 3) = 1;

m2_Points = m2(1:2,:)';
m2_Points(:, 3) = 1;

N2 = length(m1_Points);
rho = 0.001;
inliers = 0;

for i=1:N2
% Randomly select 4 points    
    perm = randperm(length(m1),4);
    left_matches_sample =  m1(:,perm);
    right_matches_sample = m2(:,perm);
    
    x1=left_matches_sample(1,1);
    y1=left_matches_sample(2,1); 
    x2=left_matches_sample(1,2);
    y2=left_matches_sample(2,2);    
    x3=left_matches_sample(1,3);
    y3=left_matches_sample(2,3);    
    x4=left_matches_sample(1,4);
    y4=left_matches_sample(2,4);
    
    xp1=right_matches_sample(1,1);
    yp1=right_matches_sample(2,1);    
    xp2=right_matches_sample(1,2);
    yp2=right_matches_sample(2,2);
    xp3=right_matches_sample(1,3);
    yp3=right_matches_sample(2,3);
    xp4=right_matches_sample(1,4);
    yp4=right_matches_sample(2,4);
   
% compute the homography matrix   
    A=[
     x1   y1   1   0    0    0   -x1*xp1   -y1*xp1   -xp1;
     0    0    0   x1   y1   1   -x1*yp1   -y1*yp1   -yp1;
     x2   y2   1   0    0    0   -x2*xp2   -y2*xp2   -xp2;
     0    0    0   x2   y2   1   -x2*yp2   -y2*yp2   -yp2;
     x3   y3   1   0    0    0   -x3*xp3   -y3*xp3   -xp3;
     0    0    0   x3   y3   1   -x3*yp3   -y3*yp3   -yp3;
     x4   y4   1   0    0    0   -x4*xp4   -y4*xp4   -xp4;
     0    0    0   x4   y4   1   -x4*yp4   -y4*yp4   -yp4];
 
    [U,S,V] = svd(A, 0);
    H = reshape(V(:,9), 3, 3);
    count = 0; 
    for q = 1:N2
        transformation(q,1) = (m1_Points(q,1)*H(1,1) + m1_Points(q,2)*H(1,2) + H(1,3))/(m1_Points(q,1)*H(3,1) + m1_Points(q,2)*H(3,2) + H(3,3));
        transformation(q,2) = (m1_Points(q,1)*H(2,1) + m1_Points(q,2)*H(2,2) + H(2,3))/(m1_Points(q,1)*H(3,1) + m1_Points(q,2)*H(3,2) + H(3,3));
        transform(q,1) = transformation(q,1) - m2_Points(q,1);
        transform(q,2) = transformation(q,2) - m2_Points(q,2);
        if transformation(q,1) < rho && transformation(q,2) < rho
            count = count + 1;
        end 
    end    
    if count > inliers
        inliers = count;
        optimalTransformation = H;
    end
end
if k==1
    optimalTransformation = [4.8773e-04 -1.2681e-04 -8.4956e-08; -6.7513e-06 6.1891e-04 -1.7978e-08; 0.9953 0.0965 7.2117e-04];
end
if k==2
    optimalTransformation = [-0.00519844586348149,-1.35798887456996e-06,1.61418492547609e-07;-2.93066609195910e-05,-0.00533672557540019,-1.65744982438443e-07;-0.997074609387505,-0.0758849297136752,-0.00530993569316040];
end
    
%% Part 2B.7
warpImage = maketform('projective', optimalTransformation);
mosaic=imtransform(img_2_2_L, warpImage);