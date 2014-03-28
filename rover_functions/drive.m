function drive( v, omega )
   global vMax; global omegaAbsMax;

   % Safety first!
   v = min(v,vMax);
   omega = sign(omega)*min(abs(omega),omegaAbsMax);

   set_param('robulink/v','Value',num2str(v));
   set_param('robulink/omega','Value',num2str(omega));
end