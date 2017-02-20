%Learning Algorithm diving_cylinder
clc;
close all;
%% Simulation Parameters
zd = [0.7, 0.0, 0.0, 0.0];                                       % target [zd, z_dotd, z_ddotd, z_dddotdes]          
positionTol = 0.01;
useExistingProperties = 0;                                      % 0 = new learning tast; 1 = use existing properties
numFailuresBeforeExploStop = 5000;                               % number of failures before exploration of the environment stops
timeBeforStartDisplay = 1000;
controler = 1;
wave = 0;                                                       % produces a wave signal for zielTiefe
gamma = 0.9;                                                    % dicounting factor     
exploProbability = 0.10;                                        % probability of an explorational action
tolerance   = 0.1;                                            % tolerance of change in value
%% Timeparameters
time = 0;                                                       % overall timsteps of calculation
timeStepsToFailure = [];                                        % timesteps before failure happened
numFailures = 0;                                                % initial value of Failures
timeAtStartOfCurrentTrial = 0;                                  % initial timestep 
%% Sarting state
z = [0.6, 0.0, 0.0];                                            % starting state [z, z_dot, z_ddot];
state = get_state111(z, zd, positionTol);                       % calculation of the starting state
terminalState   = 111;                                              % number of total states+2 (from get_state111)
%% Setup of transition and reward
if (useExistingProperties == 0)
transitionCounts  = zeros(terminalState, terminalState, 2);             % matrix to count transitions from state to state under action x
transitionProbs = zeros(terminalState, terminalState, 2)/terminalState;     % matrix for transition probabilities from state to state
rewardCounts = zeros(terminalState, 2);                             % setting up reward counts
reward = zeros(terminalState, 1);                                    % setting up rewards
value = zeros(terminalState, 1);                                    % setting up values of the states
end
%end
alpha =0;     % initial value of alpha
%% Definition of plot parameter (not part of the algorithm)
global timePlot;
global zPlot;
global zielTiefePlot,
global k
k = 1;
timePlot(1)=0;
zPlot(1)=0;
zielTiefePlot(1)=0;


%% Loop 
while (time < 5000000)
    %% Calculation score value to decide next action
    actionValue1 = transitionProbs(state, : , 1) * value;       % calculating total value if action 1 is taken            
    actionValue2 = transitionProbs(state, : , 2) * value;       % calculating total value if action 2 is taken
    %% Exploration moves with certain probability
    if (numFailures<numFailuresBeforeExploStop)   
        if(den(state)<300)
    explo_prob = exploProbability;                            % exploration with certain probability
        else
            explo_prob = 0;
        end
    randomValue = rand(1);                                      % getting random value for determining exploratoin
    else
    explo_prob = 0;
    end
    %% Determie next action 
    if (actionValue1 > actionValue2)                                                        
         if (randomValue > explo_prob)                          % if random value greater exploration parameter, no exploration
        action = 1;                                             % if no exploration take action 1
         else 
        action = 2;                                             % else, take action 2 as exploration move
         end
    elseif (actionValue2 > actionValue1)
         if (randomValue > explo_prob)
        action = 2;
         else 
        action = 1;
         end
    else                                                        % if both action values are equal determine next action radomly                                                       
        if(randomValue <= 0.5)
            action = 1;
        else
            action = 2;
        end
    end
 %% Calculation equation of motion and new state under action x
[z, alpha] = cyl_dynamics(action, z, alpha);      % calculating cylinder dynamics
[newState] = get_state111(z, zd, positionTol);                 % getting new state
time = time + 1;                                                % raising time step

%% Reward of the last step
if (newState == terminalState)
        R = -1;                                                 % negative reward if newState is terminal state
else
        R = 0;                                                  % no reward else
end
%% Updating transition probabilities (policy)
transitionCounts(state, newState, action) = ...                 % updating trasition counts for triple state/newState/action
    transitionCounts(state, newState, action) + 1;
rewardCounts(newState, 1) = rewardCounts(newState, 1) +R;       % updating total rewad for new state
rewardCounts(newState, 2) = rewardCounts(newState, 2) +1;       % updating rewad counts for new state
% Updating transition properties (policy) 
if (newState==terminalState)                                        
    for a = 1:2                                                     % updating transition probabilities of all states under action 1/2
        for s = 1:terminalState                                            
            den(s) = sum(transitionCounts(s,:,a));                             % summing up all transitions in state s under action a
                if (den(s) > 0)
                transitionProbs(s, :, a) = transitionCounts(s, :, a) /den(s);      % calculating new probability through transitionConts and den
                end
        end
    end
    for s = 1:terminalState                                             % calculating reward of last step
        if (rewardCounts(s, 2) > 0)
            reward(s) = rewardCounts(s, 1) / rewardCounts(s, 2);            
        end
    end
    %% Updating state values until convergence
    iterations = 0;
    newValue = zeros(terminalState, 1);
    while true
        iterations = iterations + 1;
        for s =1:terminalState
            newValue1 = transitionProbs(s,:,1) * value;                        % calculating value of states under action 1
            newValue2 = transitionProbs(s,:,2) * value;                        % calculating value of states under action 2                       
            newValue(s) = max([newValue1, newValue2]);                            % getting maximum value of states
        end
        newValue = reward + gamma * newValue;                           % updating new value with reward (Bellman equation) 
        diff = max(abs(value - newValue));                              % checking change of value function
        value = newValue;
        if (diff < tolerance)                                           % if change in value function < tolerance terminate
            break;
        end
    end
end

%% Resetting plot parameters (not part of the algorithm)
if (time-timeAtStartOfCurrentTrial)*0.025 > timeBeforStartDisplay       %displayStarted==1
 realTimeOfTrial = (time-timeAtStartOfCurrentTrial)*0.025;       % duration of current trial in s               
 show_cyl(z, zd, alpha, positionTol, time);  % visialization of the cylinder
end
%% %% Reinitiate State
if (newState == terminalState)
numFailures = numFailures + 1                                       %number of Failures
timeStepsToFailure(numFailures) = time - timeAtStartOfCurrentTrial; %vector consiting of number of time steps 

if (controler == 1)
dt=0.025;
Adiaphr = 707/10^6;                        % area of diaphragm in m^2
alpha_max = 115;
V = [0,0];
V(1) = Adiaphr * (-10 +20*(alpha/alpha_max)) /1000;
zaehl = 0;
while(true)
    [V] = SMC_controller(z, V, zd);
    [z, V]=SMC_dynamics(z, dt, V);                             % getting new state through nature
    alpha = ((V(1)/Adiaphr)*1000+10)/20*alpha_max;
    time = time + 1;
    if (time-timeAtStartOfCurrentTrial)*0.025 > timeBeforStartDisplay       %displayStarted==1
        realTimeOfTrial = (time-timeAtStartOfCurrentTrial)*0.025;       % duration of current trial in s               
        show_cyl(z, zd, alpha, positionTol, time);  % visialization of the cylinder
    end
    state = get_state111(z, zd, positionTol);                      % calculation of the starting state
    if state ~= terminalState
    zaehl = zaehl+1;
    else 
    zaehl = 0;
    end
    if zaehl > 100
    break;
    end
end
else                       
z(1) = zd(1)-0.01 + 2*rand(1)/100; 
z(2) = 0; 
alpha = 0;                            %reinitiation of the next trial
end
timeAtStartOfCurrentTrial = time;                                   %time of learning at start current trial        
else
state = newState;                                               %updating state
end
end
plot_learning_curve