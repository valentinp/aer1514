function drive( v, omega )
   global vAbsMax; global omegaAbsMax;

   v = str2double(num2str(v));
   omega = str2double(num2str(omega));
   
   % Safety first!
   v = sign(v)*min(abs(v),vAbsMax);
   omega = sign(omega)*min(abs(omega),omegaAbsMax);

   set_param('robulink/v','Value',num2str(v));
   set_param('robulink/omega','Value',num2str(omega));
end