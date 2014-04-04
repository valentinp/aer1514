groundtruth = [ 0,0;
                -0.6,-0.3;
                -0.6,-0.9;
                -0.6,-2.4;
                0.6,-2.4;
                0.6,-1.2;
                0.9,-0.3];
            
ourvalues = sampleList_w(1:2,:)';

diff = ourvalues - groundtruth;
diff = sum(diff.^2,2);

score = sum(0.01 ./ (diff + 0.01))