function calibStruct = calibrateTracking(context)

global height;
global width;

%Set up GUI
f = figure();
imgHandle = imshow(zeros(height,width,3,'uint8'));

[rgb,~] = getKinectData(context);
displayKinectRGB(rgb,imgHandle); 
 
disp('Select top left and bottom right corners of the blue ball');  
[x_blue,y_blue] = ginput(2);
disp('Select top left and bottom right corners of the red ball');  
[x_red,y_red] = ginput(2);

 
 blue_pixels = rgb(round(y_blue(1)):round(y_blue(2)), round(x_blue(1)):round(x_blue(2)), :);
 red_pixels = rgb(round(y_red(1)):round(y_red(2)), round(x_red(1)):round(x_red(2)),:);
 
 blue_r = double(blue_pixels(:,:,1));
 blue_g = double(blue_pixels(:,:,2));
 blue_b = double(blue_pixels(:,:,3));
 
 red_r = double(red_pixels(:,:,1));
 red_g = double(red_pixels(:,:,2));
 red_b = double(red_pixels(:,:,3));
 
 blue_r = blue_r(:);
 blue_g = blue_g(:);
 blue_b = blue_b(:);
 
 red_r = red_r(:);
 red_g = red_g(:);
 red_b = red_b(:);
 
 blue_br = blue_b./blue_r;
 blue_rg = blue_r./blue_g;
 blue_gb = blue_g./blue_b;

 red_br = red_b./red_r;
 red_rg = red_r./red_g;
 red_gb = red_g./red_b;
 
 blue_sigma = 1;
 red_sigma = 1;
 
 blue_r_rng = [mean(blue_r)-blue_sigma*std(blue_r), mean(blue_r)+blue_sigma*std(blue_r)];
 blue_g_rng = [mean(blue_g)-blue_sigma*std(blue_g), mean(blue_g)+blue_sigma*std(blue_g)];
 blue_b_rng = [mean(blue_b)-blue_sigma*std(blue_b), mean(blue_b)+blue_sigma*std(blue_b)];

 blue_br_rng = [mean(blue_br)-blue_sigma*std(blue_br), mean(blue_br)+blue_sigma*std(blue_br)];
 blue_rg_rng = [mean(blue_rg)-blue_sigma*std(blue_rg), mean(blue_rg)+blue_sigma*std(blue_rg)];
 blue_gb_rng = [mean(blue_gb)-blue_sigma*std(blue_gb), mean(blue_gb)+blue_sigma*std(blue_gb)];
 
 red_r_rng = [mean(red_r)-red_sigma*std(red_r), mean(red_r)+red_sigma*std(red_r)];
 red_g_rng = [mean(red_g)-red_sigma*std(red_g), mean(red_g)+red_sigma*std(red_g)];
 red_b_rng = [mean(red_b)-red_sigma*std(red_b), mean(red_b)+red_sigma*std(red_b)];

 
 red_br_rng = [mean(red_br)-red_sigma*std(red_br), mean(red_br)+red_sigma*std(red_br)];
 red_rg_rng = [mean(red_rg)-red_sigma*std(red_rg), mean(red_rg)+red_sigma*std(red_rg)];
 red_gb_rng = [mean(red_gb)-red_sigma*std(red_gb), mean(red_gb)+red_sigma*std(red_gb)];
 
calibStruct.red_r_rng = red_r_rng;
calibStruct.red_g_rng = red_g_rng;
calibStruct.red_b_rng = red_b_rng;

calibStruct.blue_r_rng = blue_r_rng;
calibStruct.blue_g_rng = blue_g_rng;
calibStruct.blue_b_rng = blue_b_rng;

calibStruct.blue_br_rng = blue_br_rng;
calibStruct.blue_rg_rng = blue_rg_rng;
calibStruct.blue_gb_rng = blue_gb_rng;

calibStruct.red_br_rng = red_br_rng;
calibStruct.red_rg_rng = red_rg_rng;
calibStruct.red_gb_rng = red_gb_rng;

 
%disp('Is this good localization?');
%displayLocalization(axesHandle,rgb,calibStruct);

close(f);
  
end