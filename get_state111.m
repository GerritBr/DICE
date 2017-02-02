% This function returns a discretized value (a number) for a continuous state vector. 
function [state] = get_state111(z, z_dot, zielTiefe)
total_states=111; %2 more than maxmimum number of states
positionTol = 0.01; %positionToleraz which gives the boarder of Failure in one direction. positionTol is discretizised with 5 steps
%% Discretising position
if ((z < zielTiefe - positionTol) || (z > zielTiefe +  positionTol));                 %termination state if z is outside the boundaries
  state = total_states-1;                               
else
if (z >= (zielTiefe - positionTol*(1/5)) && z < (zielTiefe))
    state = 0;
  elseif (z <= (zielTiefe + positionTol*(1/5)) && z > (zielTiefe))
    state = 1;
  elseif (z >= (zielTiefe - positionTol*(2/5)) && z < (zielTiefe - positionTol*(1/5)))
    state = 2;
  elseif (z <= (zielTiefe + positionTol*(2/5)) && z > (zielTiefe + positionTol*(1/5)))
    state = 3;
  elseif (z >= (zielTiefe - positionTol*(3/5)) && z < (zielTiefe - positionTol*(2/5)))
    state = 4;
  elseif (z <= (zielTiefe + positionTol*(3/5)) && z > (zielTiefe + positionTol*(2/5)))
    state = 5;
  elseif (z >= (zielTiefe - positionTol*(4/5)) && z < (zielTiefe - positionTol*(3/5)))
    state = 6;
  elseif (z <= (zielTiefe + positionTol*(4/5)) && z > (zielTiefe + positionTol*(3/5)))
    state = 7;
  elseif (z >= (zielTiefe - positionTol) && z < (zielTiefe - positionTol*(4/5)))
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
 elseif (z_dot < -0.04)
    state = state + 90;
 else 
    state = state + 100;
 end
end
state = state+1;    %return state+1