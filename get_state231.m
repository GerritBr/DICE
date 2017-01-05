% This function returns a discretized value (a number) for a continuous state vector. 
function [state] = get_state(z, z_dot, zielTiefe)
total_states=231; %2 more than maxmimum number of states
%% Discretising position
if ((z < zielTiefe - 0.01) || (z > zielTiefe +  0.01));                 %termination state if z is outside the boundaries
  state = total_states-1;                               
else
if (z >= (zielTiefe - 0.002) && z < (zielTiefe))
    state = 0;
  elseif (z <= (zielTiefe + 0.002) && z > (zielTiefe))
    state = 1;
  elseif (z >= (zielTiefe - 0.004) && z < (zielTiefe - 0.002))
    state = 2;
  elseif (z <= (zielTiefe + 0.004) && z > (zielTiefe + 0.002))
    state = 3;
  elseif (z >= (zielTiefe - 0.006) && z < (zielTiefe - 0.004))
    state = 4;
  elseif (z <= (zielTiefe + 0.006) && z > (zielTiefe + 0.004))
    state = 5;
  elseif (z >= (zielTiefe - 0.008) && z < (zielTiefe - 0.006))
    state = 6;
  elseif (z <= (zielTiefe + 0.008) && z > (zielTiefe + 0.006))
    state = 7;
  elseif (z >= (zielTiefe - 0.01) && z < (zielTiefe - 0.008))
    state = 8;
  else
    state = 9; 
end
%% Discretising velocity
 if (z_dot >= -0.01 && z_dot <= 0) 		       
    state = state + 10;
 elseif (z_dot <= 0.01 && z_dot > 0)
    state = state + 20;
 elseif (z_dot >= -0.02 && z_dot < -0.01)
    state = state + 30;
 elseif (z_dot <= 0.02 && z_dot > 0.01)
    state = state + 40;  
 elseif (z_dot >= -0.03 && z_dot < -0.02)
    state = state + 50;
 elseif (z_dot <= 0.03 && z_dot > 0.02)
    state = state + 60; 
 elseif (z_dot >= -0.04 && z_dot < -0.03)
    state = state + 70;
 elseif (z_dot <= 0.04 && z_dot > 0.03)
    state = state + 80;
 elseif (z_dot >= -0.05 && z_dot < -0.04)
    state = state + 90;
 elseif (z_dot <= 0.05 && z_dot > 0.04)
    state = state + 100;
 elseif (z_dot >= -0.06 && z_dot < -0.05)
    state = state + 110;
 elseif (z_dot <= 0.06 && z_dot > 0.05)
    state = state + 120; 
 elseif (z_dot >= -0.07 && z_dot < -0.06)
    state = state + 130;
 elseif (z_dot <= 0.07 && z_dot > 0.06)
    state = state + 140; 
elseif (z_dot >= -0.08 && z_dot < -0.07)
    state = state + 150;
 elseif (z_dot <= 0.08 && z_dot > 0.07)
    state = state + 160;  
 elseif (z_dot >= -0.09 && z_dot < -0.08)
    state = state + 170;
 elseif (z_dot <= 0.09 && z_dot > 0.08)
    state = state + 180; 
 elseif (z_dot >= -0.1 && z_dot < -0.09)
    state = state + 190;
 elseif (z_dot <= 0.1 && z_dot > 0.09)
    state = state + 200; 
 elseif (z_dot < -0.1)
    state = state + 210;
 else 
    state = state + 220;
 end
end
state = state+1;    %return state+1