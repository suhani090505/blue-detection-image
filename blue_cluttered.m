clc;
clear;
close all;

% Step 1: Read the Image
img = imread('cluttered_image.jpg'); % Replace with your image filename
figure, imshow(img);
title('Original Image');

% Step 2: Convert to HSV Color Space
hsv_img = rgb2hsv(img);
hue = hsv_img(:,:,1);
sat = hsv_img(:,:,2);
val = hsv_img(:,:,3);

% Step 3: Create Mask for Blue Color
blue_mask = (hue >= 0.55 & hue <= 0.75) & (sat > 0.4) & (val > 0.2);

% Step 4: Clean Up the Mask
blue_mask_cleaned = imopen(blue_mask, strel('disk', 5));
blue_mask_cleaned = imclose(blue_mask_cleaned, strel('disk', 5));
blue_mask_cleaned = imfill(blue_mask_cleaned, 'holes');

% Step 5: Label and Extract Object Properties
labeled = bwlabel(blue_mask_cleaned);
stats = regionprops(labeled, 'BoundingBox', 'Area');

% Step 6: Show Final Results
figure, imshow(img);
title('Detected Blue Objects');
hold on;
for i = 1:length(stats)
    if stats(i).Area > 300 % Minimum area threshold to filter noise
        rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'cyan', 'LineWidth', 2);
    end
end
