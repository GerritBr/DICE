% This function displays the "animation"
function [] = show_cyl(action, z, z_dot, alpha, zielTiefe, realTimeOfTrial)
%% Defining global plot variables
global timePlot
global zPlot
global zielTiefePlot
global k
set(gcf,'DoubleBuffer','on');
%% plot parameters for diaphrgm
h_Membran = 10 * (alpha/57.5)/1000;  %Calculating diaphragm stroke for visualation
if(sign(h_Membran) == 1)
   m = 0;
   h = abs(h_Membran);
elseif(sign(h_Membran) == -1)
    m = -abs(h_Membran);
    h = abs(h_Membran);
else
    m = 0;
    h = 0;
end
%% Building plot vector of position
if (k < 400)
timePlot(k)= realTimeOfTrial;
zPlot(k) = z;
zielTiefePlot(k) = zielTiefe;
k = k+1;
else
    timePlot(1) =[];
    zPlot(1) =[];
    zielTiefePlot(1) =[];
    timePlot(k) = realTimeOfTrial;
    zPlot(k) = z;
    zielTiefePlot(k) = zielTiefe;
end
clf
positionVector1 = [0.1, 0.1, 0.3, 0.8];
positionVector2 = [0.5, 0.1, 0.4, 0.4];
%% Plot figure
h1 = subplot('Position',positionVector1);
plot(0, -z); 
%target depth and boundary lines
line ([-0.1 0.1], [z z]) 
line ([-0.1 0.1], [zielTiefe zielTiefe], 'color', 'green') 
line ([-0.1 0.1], [zielTiefe-0.01 zielTiefe-0.01], 'color', 'red') 
line ([-0.1 0.1], [zielTiefe+0.01 zielTiefe+0.01], 'color', 'red') 
%diving cell
rectangle('Position', [-0.02, z-0.045, 0.04, 0.09], 'FaceColor', 'cyan');
rectangle('Position', [-0.01, z+0.045+m, 0.02, h], 'FaceColor', 'red');
axis([-0.05 0.05 zielTiefe-0.10 zielTiefe+0.10]);
grid on;
ylabel ('depth [m]')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'YDir','reverse'); 
%position graph
h2 = subplot('Position',positionVector2);
plot(timePlot,zPlot,'b')
hold on;
plot(timePlot,zielTiefePlot,'g')
plot(timePlot,zielTiefePlot-0.01,'r')
plot(timePlot,zielTiefePlot+0.01,'r')
axis([realTimeOfTrial- 10, realTimeOfTrial, zielTiefe-0.10, zielTiefe+0.10]);
grid on;
xlabel ('time [s]');
ylabel ('depth [m]')
set(gca,'YDir','reverse');
drawnow;