figure;
for i = 2:size(T_rg_history,3)
    drawframe(T_rg_history(:,:,i));
    hold on;
    pause(0.3);
end