% This function returns a discretized value (a number) for a continuous state vector. 
function [state] = get_state56(z, z_dot, zielTiefe)
total_states=56; %2 more than maxmimum number of states
positionTol = 0.015; %positionToleraz which gives the boarder of Failure in one direction. positionTol is discretizised with 5 steps
%% Discretising position
if ((z < zielTiefe - positionTol) || (z > zielTiefe +  positionTol));                 %termination state if z is outside the boundaries
  state = total_states-1;                               
else
if (z >= (zielTiefe - positionTol*(1/4)) && z < (zielTiefe))
    state = 0;
  elseif (z <= (zielTiefe + positionTol*(1/4)) && z > (zielTiefe))
    state = 1;
  elseif (z >= (zielTiefe - positionTol*(2/4)) && z < (zielTiefe - positionTol*(1/4)))
    state = 2;
  elseif (z <= (zielTiefe + positionTol*(2/4)) && z > (zielTiefe + positionTol*(1/4)))
    state = 3;
  elseif (z >= (zielTiefe - positionTol*(3/4)) && z < (zielTiefe - positionTol*(2/4)))
    state = 4;
  elseif (z <= (zielTiefe + positionTol*(3/4)) && z > (zielTiefe + positionTol*(2/4)))
    state = 5;
  elseif (z >= (zielTiefe - positionTol) && z < (zielTiefe - positionTol*(3/4)))
    state = 6;
  else 
    state = 7;
end
%% Discretising velocity
 if (z_dot >= -0.01 && z_dot <= 0) 		       
    state = state + 8;
 elseif (z_dot <= 0.01 && z_dot > 0)
    state = state + 16;
 elseif (z_dot >= -0.02 && z_dot < -0.01)
    state = state + 24;
 elseif (z_dot <= 0.02 && z_dot > 0.01)
    state = state + 32;  
 elseif (z_dot < -0.02)
    state = state + 40;
 else
    state = state + 48; 
 end
end
state = state+1;    %return state+1