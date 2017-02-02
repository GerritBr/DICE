% This function returns a discretiz(1)ed value (a number) for a continuous state vector. 
function [state] = get_state111(z, zd, positionTol)
total_states=111; %2 more than maxmimum number of states
%% Discretising position
if ((z(1) < zd(1) - positionTol) || (z(1) > zd(1) +  positionTol));                 %termination state if z(1) is outside the boundaries
  state = total_states-1;                               
else
if (z(1) >= (zd(1) - positionTol*(1/5)) && z(1) < (zd(1)))
    state = 0;
  elseif (z(1) <= (zd(1) + positionTol*(1/5)) && z(1) > (zd(1)))
    state = 1;
  elseif (z(1) >= (zd(1) - positionTol*(2/5)) && z(1) < (zd(1) - positionTol*(1/5)))
    state = 2;
  elseif (z(1) <= (zd(1) + positionTol*(2/5)) && z(1) > (zd(1) + positionTol*(1/5)))
    state = 3;
  elseif (z(1) >= (zd(1) - positionTol*(3/5)) && z(1) < (zd(1) - positionTol*(2/5)))
    state = 4;
  elseif (z(1) <= (zd(1) + positionTol*(3/5)) && z(1) > (zd(1) + positionTol*(2/5)))
    state = 5;
  elseif (z(1) >= (zd(1) - positionTol*(4/5)) && z(1) < (zd(1) - positionTol*(3/5)))
    state = 6;
  elseif (z(1) <= (zd(1) + positionTol*(4/5)) && z(1) > (zd(1) + positionTol*(3/5)))
    state = 7;
  elseif (z(1) >= (zd(1) - positionTol) && z(1) < (zd(1) - positionTol*(4/5)))
    state = 8;
  else
    state = 9; 
end
%% Discretising velocity
 if (z(2) >= -0.01 && z(2) <= 0) 		       
    state = state + 10;
 elseif (z(2) <= 0.01 && z(2) > 0)
    state = state + 20;
 elseif (z(2) >= -0.02 && z(2) < -0.01)
    state = state + 30;
 elseif (z(2) <= 0.02 && z(2) > 0.01)
    state = state + 40;  
 elseif (z(2) >= -0.03 && z(2) < -0.02)
    state = state + 50;
 elseif (z(2) <= 0.03 && z(2) > 0.02)
    state = state + 60; 
 elseif (z(2) >= -0.04 && z(2) < -0.03)
    state = state + 70;
 elseif (z(2) <= 0.04 && z(2) > 0.03)
    state = state + 80;
 elseif (z(2) < -0.04)
    state = state + 90;
 else 
    state = state + 100;
 end
end
state = state+1;    %return state+1