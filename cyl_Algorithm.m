%Learning Algorithm diving_cylinder
%% Simulation Parameters
zielTiefe   = 0.7;                                              %target depth          
useExistingProperties = 0;                                      %0 = new learning tast; 1 = use existing properties
gamma       = 0.9;                                              %dicounting factor     
exploProbability = 0.05;                                        %probability of an explorational action
NumFailuresBeforeExploStop = 600;                               %number of failures before exploration of the environment stops
numFailuresToStartDisplay = 700;                                %number of failures before display started
wave = 0;                                                       %produces a wave signal for zielTiefe
maxFailures = 6000000;                                          %max number of failures before termination
tolerance   = 0.001;                                            %tolerance of change in value
noLearningThreshold = 100;                                      %termination criterion
displayStarted = numFailuresToStartDisplay == 0;
%% Timeparameters
time = 0;                                                       %overall timsteps of calculation
timeStepsToFailure = [];                                        %timesteps before failure happened
numFailures = 0;                                                %initial value of Failures
timeAtStartOfCurrentTrial = 0;                                  %initial timestep 
%% Sarting state
z = zielTiefe; z_dot = 0.0;                                     %definition of the starting state
state = get_state231(z, z_dot, zielTiefe);                      %calculation of the starting state
numStates   = 231;                                              %number of total states+2 (from get_state231)
%% Setup of transition and reward
if (useExistingProperties == 0)
transitionCounts  = zeros(numStates, numStates, 2);             %matrix to count transitions from state to state under action x
transitionProbs = zeros(numStates, numStates, 2)/numStates;     %matrix to calculate transition probabilities from state to state
rewardCounts = zeros(numStates, 2);                             %setting up reward counts
reward =zeros(numStates, 1);                                    %setting up rewards
value = zeros(numStates, 1);                                    %setting up values of the states
end
consecutiveNoLearningTrials = 0;                                %initial value of consecutiveNoLearningTrials
alpha =0;                                                       %initial value of alpha
%% Definition of plot parameter
global timePlot;
global zPlot;
global zielTiefePlot,
global k
k = 1;
timePlot(1)=0;
zPlot(1)=0;
zielTiefePlot(1)=0;
%% Loop 
while (consecutiveNoLearningTrials < noLearningThreshold)
    if wave == 1;
    zielTiefe   = 0.7 + sin(time/200) * 0.02; 
    end
    %% Calculation score value to decide next action
    score1 = transitionProbs(state, : , 1) * value;            
    score2 = transitionProbs(state, : , 2) * value;
    %% Exploration moves with certain probability
    if (numFailures<NumFailuresBeforeExploStop)                 %Exploration only for number of failure < border
    explo_prob = exploProbability;                              %Exploration with certain probability
    randomValue=rand(1);                                        %Getting random value for determining exploratoin
    else
    explo_prob = 0;
    end
    %% Deciding next action with exploration probability and score value
    if (score1 > score2)                
         if (randomValue > explo_prob)
        action = 1;
         else 
        action = 2;
         end
    elseif (score2 > score1)
         if (randomValue > explo_prob)
        action = 2;
         else 
        action = 1;
         end
    else                                                        % in case of equal score values
        if(randomValue <= 0.5)
            action = 1;
        else
            action = 2;
        end
    end
 %% Calculation cylinder dynamics and new state
[z, z_dot, alpha] = cyl_dynamics(action, z, z_dot, alpha);      %Calculating cylinder dynamics
[newState] = get_state231(z, z_dot, zielTiefe);                 %Getting new state of the system
time = time + 1;                                                %Raising time step
if displayStarted==1
realTimeOfTrial = (time-timeAtStartOfCurrentTrial)*0.025;       %time of current trial in s               
show_cyl(action, z, z_dot, alpha, zielTiefe, realTimeOfTrial);  %visialization of the cylinder
end
%% Rewards
if (newState == numStates)
    if randomValue > explo_prob;                                %negative reward only if termination is not reached with exploration move
        R = -1;                                                 %negative reward
    else
        R = 0;                                                  %no negative reward for exploration
    end
else
    R = 0;
end
%% Updating transition and reward
transitionCounts(state, newState, action) = ...                 %updating trasition counts for triple state/newState/action
    transitionCounts(state, newState, action) + 1;
rewardCounts(newState, 1) = rewardCounts(newState, 1) +R;       %updating rewad for new state
rewardCounts(newState, 2) = rewardCounts(newState, 2) +1;       %updating rewad counts for new state
%% Updating transition properties (policy) 
if (newState==numStates)                                        
for a = 1:2                                                     %over action
for s = 1:numStates                                             %over all numstates (matrix state/newState/action
den = sum(transitionCounts(s,:,a));                             %determine total number of transitions out of state s under action a
if (den > 0)
transitionProbs(s, :, a) = transitionCounts(s, :, a) /den;      %updating transition properties for all state/newState/action triplets
end
end
end
for s = 1:numStates                                             %calculating reward of states
if (rewardCounts(s, 2) > 0)
reward(s) = rewardCounts(s, 1) / rewardCounts(s, 2);            %gettign reward by 
end
end
%% Updating state values until convergence
iterations = 0;
newValue = zeros(numStates, 1);
while true
iterations = iterations + 1;
for s =1:numStates
value1 = transitionProbs(s,:,1) * value;                        %calculating value of states under action 1
value2 = transitionProbs(s,:,2) * value;                        %calculating value of states under action 2                       
newValue(s) = max([value1, value2]);                            %getting maximum value of states
end
newValue = reward + gamma * newValue;                           %updating new value with reward (Bellman equation) 
diff = max(abs(value - newValue));                              %checking change of value function
value = newValue;
if (diff < tolerance)                                           %if change in value function < tolerance terminate
    break;
end
end
if (iterations == 1)
consecutiveNoLearningTrials = consecutiveNoLearningTrials + 1;  %counts of no Learning (change in value function < tolerance)
else 
consecutiveNoLearningTrials = 0;
end
end
%% Resetting plot parameters
if (newState == numStates)
realTimeOfTrial = 0;                                            %resetting real time of current trial in s
timePlot = [];
zPlot = [];
zielTiefePlot = [];
k = [];    
k = 1;
timePlot = 1;
zPlot =1;
zielTiefePlot =1;
numFailures = numFailures + 1                                       %number of Failures
timeStepsToFailure(numFailures) = time - timeAtStartOfCurrentTrial; %vector consiting of number of time steps 
timeAtStartOfCurrentTrial = time;                                   %time of learning at start current trial                               
if (numFailures > ...                                               %starting display when certain number of failures happened (definition above)
    numFailuresToStartDisplay-1)
displayStarted = 1;
end
%% Reinitiate State
z = zielTiefe; z_dot = 0; alpha = 0;                            %reinitiation of the next trial
else
state = newState;                                               %updating state
end
end
plot_learning_curve