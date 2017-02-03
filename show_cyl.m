% This function displays the "animation"
function [] = show_cyl(z, zd, alpha, positionTol, time)
%% Defining global plot variables
global timePlot
global zPlot
global zielTiefePlot
global k
set(gcf,'DoubleBuffer','on');
%% plot parameters for diaphrgm
alpha_max=115;
h_Membran = (-10 +20*(alpha/alpha_max)) /1000;  %Calculating diaphragm stroke for visualation
if(sign(h_Membran) == -1)
   m = 0;
   h = abs(h_Membran);
elseif(sign(h_Membran) == 1)
    m = -abs(h_Membran);
    h = abs(h_Membran);
else
    m = 0;
    h = 0;
end
%% Building plot vector of position
if (k < 400)
timePlot(k)= time*0.025;
zPlot(k) = z(1);
zielTiefePlot(k) = zd(1);
k = k+1;
else
    timePlot(1) =[];
    zPlot(1) =[];
    zielTiefePlot(1) =[];
    timePlot(k) = time*0.025;
    zPlot(k) = z(1);
    zielTiefePlot(k) = zd(1);
end
clf
positionVector1 = [0.1, 0.1, 0.3, 0.8];
positionVector2 = [0.5, 0.1, 0.4, 0.4];
%% Plot figure
h1 = subplot('Position',positionVector1);
plot(0, -z(1)); 
%target depth and boundary lines
line ([-0.1 0.1], [z(1) z(1)]) 
line ([-0.1 0.1], [zd(1) zd(1)], 'color', 'green') 
line ([-0.1 0.1], [zd(1)-positionTol zd(1)-positionTol], 'color', 'red') 
line ([-0.1 0.1], [zd(1)+positionTol zd(1)+positionTol], 'color', 'red') 
%diving cell
rectangle('Position', [-0.02, z(1)-0.045, 0.04, 0.09], 'FaceColor', 'cyan');
rectangle('Position', [-0.01, z(1)+0.045+m, 0.02, h], 'FaceColor', 'red');
axis([-0.05 0.05 zd(1)-0.10 zd(1)+0.10]);
grid on;
ylabel ('depth in m')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'YDir','reverse'); 
%position graph
h2 = subplot('Position',positionVector2);
plot(timePlot,zPlot,'b')
hold on;
plot(timePlot,zielTiefePlot,'g')
plot(timePlot,zielTiefePlot-positionTol,'r')
plot(timePlot,zielTiefePlot+positionTol,'r')
axis([(time*0.025)- 10, (time*0.025), zd(1)-0.10, zd(1)+0.10]);
grid on;
xlabel ('time in s');
ylabel ('depth in m')
set(gca,'YDir','reverse');
drawnow;