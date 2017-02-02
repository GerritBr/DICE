function [z, V] = dynamics(z, dt, V, naturefactor, controllaw)
global rho_W;
global g;
global k;
global V_0;
global m_0;
global alpha_max;
global A_Membran; 
a = 2;
%explicit euler to determine next velocity 
velocity_before = z(2);
velocity_next = velocity_before + ((rho_W*g*(V_0+V(1))/m_0)-g-(k*sign(velocity_before)*velocity_before^2)/m_0)*(dt/naturefactor);
if controllaw == 1
volume_rate = a*(V(2)-V(1));
end
%getting new position and velocity through Euler
z(2) = velocity_next;
z(1) = z(1) + velocity_next*(dt/naturefactor);
if controllaw == 1
V(1) = V(1) + volume_rate*(dt/naturefactor);
Vstep=volume_rate*(dt/naturefactor);
VstepProzent= abs(Vstep)/(((2*0.05*V_0/2)/0.5)*(dt/naturefactor));
end
end