function drive(v, omega)
    set_param('robulink/v', 'Value', num2str(v));
    set_param('robulink/omega', 'Value', num2str(omega));
end