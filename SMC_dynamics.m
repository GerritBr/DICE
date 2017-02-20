function [z, V] = dynamics(z, dt, V)
rho_W = 1000;                       % density of water in m^3/kg
g = 9.81;                           % gravitional acc  in m/s^2
k = 1;                              % visc. damping constant
diam = 0.07;                        % diameter of cylinder in m
height = 0.09;                      % height of cylinder in m
V0 = pi/4 * diam^2 * height;        % volume of cylinder in m^3
m_C = rho_W*V0;                     % mass of cylinder in kg
V_err = 0.01*V0;
a = 2;
%explicit euler to determine next velocity 
velocity_before = z(2);
velocity_next = velocity_before + ((rho_W*g*(V0+V(1)+V_err)/m_C)-g-(k*sign(velocity_before)*velocity_before^2)/m_C)*dt;
volume_rate = a*(V(2)-V(1));
%getting new position and velocity through Euler
z(2) = velocity_next;
z(1) = z(1) + velocity_next*dt;
V(1) = V(1) + volume_rate*dt;
end