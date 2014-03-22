terrain = terrainAssessment(context,rgb,depth,1);

terrainAssessment_T_rg = localizeRover(context,rgb,depth, terrain.T_gk);
terrain = markTerrainAroundRoverSafe(terrain,terrainAssessment_T_rg);

h = figure; h = imagesc(zeros(480,640,3,'uint8')); displayKinectRGB(rgb,h); hold on;
overlayTerrainGrid(h, terrain, context);