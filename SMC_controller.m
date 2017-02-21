function [V, z_err] = SMC_controller(z, V, zd)
rho_W = 1000;                       % density of water in m^3/kg
g = 9.81;                           % gravitional acc  in m/s^2
k = 1;                              % visc. damping constant
diam = 0.07;                        % diameter of cylinder in m
height = 0.09;                      % height of cylinder in m
V0 = pi/4 * diam^2 * height;        % volume of cylinder in m^3
m_C = rho_W*V0;                     % mass of cylinder in kg
V_err = 0.01*V0;
Vmax = 0.05*V0;
%Control parameters
lambda= 0.6;
phi = 0.2;
eta = 1;
a = 0.4;
%error variables
z_err(1) = z(1)-zd(1);                  % position error
z_err(2) = z(2)-zd(2);                  % velocity error
z_err(3) = z(3)-zd(3);
%sliding surface
%% Control force signum function
% SMC for equation of motion 3rd order
s=z_err(3)+2*lambda*z_err(2)+lambda^2*z_err(1);
Vc = -1/(a*(rho_W*g)) * (a*rho_W*g*(V(1)+V_err) - 2*k*z(3)*abs(z(2)) - m_C*(zd(4) - 2*lambda*z_err(3) - lambda^2*z_err(2)) + eta*sat(s, phi));
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
function y=sat(s,phi)
kk=1/phi;
% sat is the saturation function with unit limits and unit slope.
if abs(s)>phi
% elseif x<-phi 
y=sign(s);
else 
y=kk*s;
end
end
end