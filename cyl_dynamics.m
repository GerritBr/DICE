function [new_z, alpha] = cyl_dynamics(action, z, alpha)
%% Constants
rho_W = 1000;                       % density of water in m^3/kg
g = 9.81;                           % gravitional acc  in m/s^2
diam = 0.07;                        % diameter of cylinder in m
height = 0.09;                      % height of cylinder in m
k = 1;                              % visc. damping constant
V0 = pi/4 * diam^2 * height;        % volume of cylinder in m^3
m_C = rho_W*V0;                     % mass of cylinder in kg
V0_err = 0.01* V0;                  % volumenerror hier positiv 1% des Gesamtvolumens
tau = 0.025;                        % time for calculation = 0.025s
%% Setting up Diaphragm parameters
alpha_max = 115;                           % max. angle of motor in one direction
s_ges = 0.5;                                % time for complete change of Volume (-Vmax to Vmax)
h = 0;                                      % stroke of diaphragm in m
a_diaphr = 707/10^6;                        % area of diaphragm in m^2
V_W = 0;                                    % variable volume of diving cell. Calculated through h and a_diaphr
volumeStep = tau * alpha_max/(s_ges);   % max summable volume during calculation time
%% Target depth
zd(1) = 0.7;                            % target depth of diving cell
%% Variation of volume
if (action == 1)
   if (alpha >= (volumeStep))  % if aplpha smaller than -maximum + volumestep subtract a volumestep
    alpha_new = alpha - tau * alpha_max/(s_ges) ;
    else 
    alpha_new = 0;                                 
    end
elseif (action == 2)
    if (alpha <= (alpha_max - volumeStep))  % if aplpha smaller than maximum - volumestep add a volumestep
    alpha_new = alpha + tau * alpha_max/(s_ges) ;
    else 
      alpha_new = alpha_max;
    end
end
alpha = alpha_new;
h_Hub = (-10 +20*(alpha/alpha_max)) /1000;      % calculate stroke of diaphragm in m
V_W = a_diaphr * h_Hub;                     % calculating variable volume of diaphragm in m^3
%% equations of motion
z_0 = [z(1); z(2)];
zhat = zeros(2,1);
zhat(1) = z_0(2);
zhat(2) = zhat(1) + sign(zhat(1)) * zhat(1)^2 * k * tau / m_C + tau * rho_W * g * (V_W + V0 + V0_err) / m_C  - tau * g;
% Return the new state variables (using Euler's method)
new_z(1)  = z(1) + tau * zhat(2);
new_z(2) = zhat(2);