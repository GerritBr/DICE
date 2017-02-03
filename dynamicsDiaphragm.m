function [V] = dynamicsDiaphragm(V, dt)
diam = 0.07;                        % diameter of cylinder in m
height = 0.09;                      % height of cylinder in m
V0 = pi/4 * diam^2 * height;        % volume of cylinder in m^3
Vmax = 0.05*V0/2; 
Vstep=((2*Vmax)/0.5)*dt;
%calculating the possible varaible volume restricted by DICE dynamics 
if V(2)<=0
    Vstell= -max(Vmax,V(2));
else
    Vstell= min(Vmax,V(2));
end 
if Vstell<0
    if V(1) > Vstell && V(1)<= Vstell+Vstep;
        V(1) = Vstell;
    elseif V(1) < Vstell && V(1)>=Vstell-Vstep;
        V(1) = Vstell;    
    elseif V(1)<Vstell-Vstep
        V(1) = V(1)+Vstep;        
    elseif V(1)>Vstell+Vstep
        V(1) = V(1)-Vstep;
    else 
        V(1) = Vstell;
    end
else
    if V(1) > Vstell && V(1)<= Vstell+Vstep;
        V(1) = Vstell;
    elseif V(1) < Vstell && V(1)>=Vstell-Vstep;
        V(1) = Vstell;    
    elseif V(1)>Vstell+Vstep
        V(1) = V(1)-Vstep;
    elseif V(1)<Vstell-Vstep
        V(1) = V(1)+Vstep;
    else 
        V(1) = Vstell;
    end
end
end
 