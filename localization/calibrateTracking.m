function calibStruct = calibrateTracking(context)

global height;
global width;

%Set up GUI
f = figure();
imgHandle = imshow(zeros(height,width,3,'uint8'));

[rgb,~] = getKinectData(context);
displayKinectRGB(rgb,imgHandle); 
 
disp('Select top left and bottom right corners of the BLUE ball');  
[x_blue,y_blue] = ginput(2);
disp('Select top left and bottom right corners of the RED ball');  
[x_red,y_red] = ginput(2);

 
 hsv = rgb2hsv(rgb);
 blue_pixels = hsv(round(y_blue(1)):round(y_blue(2)), round(x_blue(1)):round(x_blue(2)), :);
 red_pixels = hsv(round(y_red(1)):round(y_red(2)), round(x_red(1)):round(x_red(2)),:);
 
 blue_h = double(blue_pixels(:,:,1));
 red_h = double(red_pixels(:,:,1));
 blue_h = blue_h(:);
 red_h = red_h(:);
 
 red_s = double(red_pixels(:,:,2));
 blue_s = double(blue_pixels(:,:,2));
 blue_s = blue_s(:);
 red_s = red_s(:);

 red_v = double(red_pixels(:,:,3));
 blue_v = double(blue_pixels(:,:,3));
 blue_v = blue_v(:);
 red_v = red_v(:);

 sigma_const = 0.8;
 sigma_const_min = 1;
 
 red_h_rng = [median(red_h)-sigma_const*std(red_h), median(red_h)+sigma_const*std(red_h)];
 blue_h_rng = [median(blue_h)-sigma_const*std(blue_h), median(blue_h)+sigma_const*std(blue_h)];
 
 blue_v_min = median(blue_v) - sigma_const_min*std(blue_v);
 red_v_min = median(red_v) - sigma_const_min*std(red_v);
 
 blue_s_min = median(blue_s) - sigma_const_min*std(blue_s);
 red_s_min = median(red_s) - sigma_const_min*std(red_s);
 
 
calibStruct.red_h_rng = red_h_rng;
calibStruct.blue_h_rng = blue_h_rng;

calibStruct.blue_v_min = blue_v_min;
calibStruct.red_v_min = red_v_min;

calibStruct.blue_s_min = blue_s_min;
calibStruct.red_s_min = red_s_min;

save('trackingCalibration.mat', 'calibStruct'); 

close(f);
  
end