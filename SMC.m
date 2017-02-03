%Implemented SMC in DICE
clc;
clear all;
close all;
% Constants
constants()                         % defining global constants
global rho_W;
global g;
global d_c;
global h_c;
global k;
global V_0;
global m_0;
global A_Membran;
global alpha_max;
% Diaphragm and stroke
alpha = 0;                          % angle motor [deg]
h = 0;                              % stroke diaphragm [m]
Vvar = 0;                           % varaiable volume of diving cell [m^3]                 
% Initiation
z0 = [0.0, 0.0, 0.0];               % initial parameters [z, z_dot, zddot]
V0 = [0.0, 0.0];                    % initial parameters [Vist, Vsoll]
naturefactor = 5;
controllaw = 0;                     % 0=2nd order system; 1=3rd order system
dynamicActuator = 1;                % 1 dynamic actuator on, 0 = off
wave = 0;                           % wave function 0=off, 1=on
z = z0;
V = V0;
dt = 0.025;                         % time step of Teensy [s]
tmax = 60;                          % simulation time [s]
time = 0;                           % start time [s]
% Loop 
i=1;   % iteration parameter for plots
%%
while time <tmax ; 
if wave == 0    
% Desired trajectories
z_d(1)=-0.7;      % desired position
z_d(2)=0;        % desired velocity
z_d(3)=0;        % desired acceleration
z_d(4)=0;       
elseif wave == 1
    w1=-0.7; %depth
    w2=0.2; %amplitude
    w3=20; %factor wavelength
z_d(1)=w1+w2*sin(2*pi*time/w3);             % desired position
z_d(2)=w2*cos(2*pi*time/w3)*(2*pi/w3);      % desired velocity
z_d(3)=-w2*sin(2*pi*time/w3)*(2*pi/w3)^2;   % desired acceleration
z_d(4)=-w2*cos(2*pi*time/w3)*(2*pi/w3)^3;
end
%% 2 block
[V]=controller(z, V, z_d, controllaw);        % getting variable volume from controller
n = 0;
while n < naturefactor+1
    if controllaw == 0
[V] = dynamicsDiaphragm(V, dt, dynamicActuator, naturefactor);    
    end
[z, V]=dynamics(z, dt, V, naturefactor, controllaw);         % getting new state through nature
n=n+1;
z_plot(i)=z(1);
z_dPlot(i) = z_d(1);
VvarPlot(i)=V(1);
timePlot(i)=time;
i=i+1;
time=time+dt/naturefactor
end
end
visualization(z_plot, z_dPlot, timePlot, VvarPlot, dt, tmax);



