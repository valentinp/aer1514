% function exportMap(sampleList_k, T_mk
% sampleList_m = homo2cart(T_mk*cart2homo(sampleList_k));

function exportMap(sampleList_k, framePoints_k)

csvwrite('worldpoints.txt',framePoints_k');
save('worldpoints.mat','framePoints_k');

csvwrite('map.txt',sampleList_k');
save('map.mat','sampleList_k');
end