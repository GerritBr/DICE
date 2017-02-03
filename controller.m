function [V, z_err] = controller(z, V, zd)
rho_W = 1000;                       % density of water in m^3/kg
g = 9.81;                           % gravitional acc  in m/s^2
k = 1;                              % visc. damping constant
diam = 0.07;                        % diameter of cylinder in m
height = 0.09;                      % height of cylinder in m
V0 = pi/4 * diam^2 * height;        % volume of cylinder in m^3
m_C = rho_W*V0;                     % mass of cylinder in kg

lambda= 1;
Kappa = 1;
steepness = 0.5;
dhat=0;
eta = 1;
a = 0.4;
Vmax = 0.05*V0/2;
%error variables
z_err(1) = z(1)-zd(1);                  % position error
z_err(2) = z(2)-zd(2);                  % velocity error
z_err(3) = z(3)-zd(3);
%sliding surface
%% Control force signum function
% SMC for equation of motion 2nd order
s=z_err(2)+lambda*z_err(1);        % sliding surface
Vc=(1/(m_C*(m_C*g))*(-rho_W*g*V0+m_C*g+k*sign(z(2))*z(2)^2)+m_C*(zd(3)-lambda*z_err(2))-(1/sqrt(2)*m_C*Kappa*sat(s, steepness)));
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