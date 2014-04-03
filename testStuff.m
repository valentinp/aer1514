oldpower = get_param('robulink/armPower','Value');
newpower = get(hObject,'String');
if sum(~(isstrprop(newpower,'digit') | newpower == '.')) == 0 % i.e. if actually a number
    set_param('robulink/armPower','Value',newpower);
else
    set(hObject,'String',num2str(oldpower));
end
drawnow;