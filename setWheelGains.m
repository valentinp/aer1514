function setWheelGains(kl, kr)
    set_param('robulink/kl', 'Value', num2str(kl));
    set_param('robulink/kr', 'Value', num2str(kr));
end