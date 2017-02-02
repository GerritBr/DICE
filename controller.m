function [V, z_err] = controller(z, V, time, z_d, controllaw)
global rho_W;
global g;
global k;
global V_0;
global m_0;
lambda= 1;
Kappa = 1;
steepness = 0.5;
dhat=0;
eta = 1;
a = 0.4;
Vmax = 0.05*V_0/2;
%error variables
z_err(1) = z(1)-z_d(1);                  % position error
z_err(2) = z(2)-z_d(2);                  % velocity error
z_err(3) = z(3)-z_d(3);
%sliding surface
%% Control force signum function
if controllaw == 0
% SMC for equation of motion 2nd order
s=z_err(2)+lambda*z_err(1);        % sliding surface
Vc=(1/(m_0*(m_0*g))*(-rho_W*g*V_0+m_0*g+k*sign(z(2))*z(2)^2)+m_0*(z_d(3)-lambda*z_err(2))-(1/sqrt(2)*m_0*Kappa*sat(s, steepness)));
elseif controllaw == 1 
% SMC for equation of motion 3rd order
s=z_err(3)+2*lambda*z_err(2)+lambda^2*z_err(1);
Vc = -1/(a*rho_W*g)*(a*rho_W*g*V(1)-2*k*z(3)*abs(z(2))-m_0*(z_d(4)-2*lambda*z_err(3)-lambda^2*z_err(2))+0*dhat+eta*sat(s, steepness));
end
if Vc<0
    if Vc < -Vmax
        V(2) = -Vmax;
    else
        V(2) = Vc;
    end
else
    if Vc > Vmax
        V(2) = Vmax;
    else
        V(2) = Vc;
    end
end
function y=sat(s,steepness)
kk=1/steepness;
% sat is the saturation function with unit limits and unit slope.
if abs(s)>steepness
% elseif x<-steepness 
y=sign(s);
else 
y=kk*s;
end
end
end