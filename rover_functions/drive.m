function drive( v, omega )
   global vMax; global omegaAbsMax;

   v = str2double(num2str(v));
   omega = str2double(num2str(omega));
   
   % Safety first!
   v = min(v,vMax);
   omega = sign(omega)*min(abs(omega),omegaAbsMax);

   set_param('robulink/v','Value',num2str(v));
   set_param('robulink/omega','Value',num2str(omega));
end