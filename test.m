n=0;
for i=1:terminalState
    for l=1:terminalState
        for a=1:2
            if transitionProbs(i,l,a)~=0;
               n=n+1;
            end
        end
    end
end
n