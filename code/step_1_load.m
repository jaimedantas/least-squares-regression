t = output;  % dataset1_outputs.txt
x = input;   % dataset1_inputs.txt

% Line Graph
scatter(x,t);
axis([-1.1 1.1 -2 1.5]);
title('Dataset');
ylabel('t'); 
xlabel('x'); 
print -depsc epsPlot2