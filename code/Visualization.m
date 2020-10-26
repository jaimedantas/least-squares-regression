% -- Visualization --
% -- EMR --

% Vector of outputs
t = output;
% Vector of 1's
o = ones(100,1);
% Number of samples
N = 100;

% -- First interaction --
% Design matrix for M = 1
X_ERM = [o, input];
w_1 = (X_ERM'* X_ERM)^-1 * X_ERM' * t;
polynomials_wi_ERM = {w_1};   % <------ contains all w_i for W = 1,...,30
design_matrix = {X_ERM};    % <------ contains all x_i for W = 1,...,30
% -- W-1 interactions --
for W = 2:30
    % Design matrix
    X_ERM = [X_ERM, input.^W];
    w_ERM = (X_ERM'* X_ERM)^-1 * X_ERM' * t;
    polynomials_wi_ERM{W,1} =  w_ERM;
    design_matrix{W,1} = X_ERM;
end

% Empirical Square Loss 
for W = 1:30
    E_ERM(W) =  1/2 * 1/N * norm((design_matrix{W} * polynomials_wi_ERM{W}) - t)^2;
end

% -- RLM --
lambda = 0.0025;

% Design matrix for W = 1
w_1_RLM = (design_matrix{1,1}'* design_matrix{1,1} + lambda * eye(2))^-1 * design_matrix{1,1}' * t;
polynomials_wi = {w_1_RLM};   % <------ contains all w_i for W = 1,...,30
% -- W-1 interactions --
for W = 2:30
    w_i = (design_matrix{W,1}'* design_matrix{W,1} + lambda * eye(W+1))^-1 * design_matrix{W,1}' * t;
    polynomials_wi{W,1} =  w_i;
end

% Empirical Square Loss
for W = 1:30
    E_RLM(W) =  1/2 * 1/N * norm((design_matrix{W} * polynomials_wi{W}) - t)^2;
end

% ERM Polynomials
figure
p1 = flip(polynomials_wi_ERM{1}');
p5 = flip(polynomials_wi_ERM{5}');
p10 = flip(polynomials_wi_ERM{10}');
p20 = flip(polynomials_wi_ERM{20}');
p30 = flip(polynomials_wi_ERM{30}');

fplot(poly2sym(p1),[min(input) max(input)], 'LineWidth',2)

title('Polynomial of Order 1, 5, 10, 20 and 30 - ERM');
ylabel('t'); 
xlabel('x');
hold on

fplot(poly2sym(p5),[min(input) max(input)],'LineWidth',2);
fplot(poly2sym(p10),[min(input) max(input)],'LineWidth',2);
fplot(poly2sym(p20),[min(input) max(input)],'LineWidth',2);
fplot(poly2sym(p30),[min(input) max(input)],'LineWidth',2);

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('W = 1','W = 5','W = 10','W = 20','W = 30', 'Dataset');
hold off
print -depsc ERMPolynomials

% RLM Polynomials
figure
p1 = flip(polynomials_wi{1}');
p5 = flip(polynomials_wi{5}');
p10 = flip(polynomials_wi{10}');
p20 = flip(polynomials_wi{20}');
p30 = flip(polynomials_wi{30}');

fplot(poly2sym(p1),[min(input) max(input)], 'LineWidth',2)

title('Polynomial of Order 1, 5, 10, 20 and 30 - RLM with λ=0.0025');
ylabel('t'); 
xlabel('x');
hold on

fplot(poly2sym(p5),[min(input) max(input)],'LineWidth',2);
fplot(poly2sym(p10),[min(input) max(input)],'LineWidth',2);
fplot(poly2sym(p20),[min(input) max(input)],'LineWidth',2);
fplot(poly2sym(p30),[min(input) max(input)],'LineWidth',2);

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('W = 1','W = 5','W = 10','W = 20','W = 30', 'Dataset');
hold off
print -depsc RLMPolynomials

% Bar chart for RLM x ERM
figure('Position', [10 10 900 400])
x_axis = [1 5 10 20 30];
numbins = size(x_axis,2);
x1 = [1:numbins];

y_axies_ERM = [E_ERM(1) E_ERM(5) E_ERM(10) E_ERM(20) E_ERM(30)];
y_axies = [E_RLM(1) E_RLM(5) E_RLM(10) E_RLM(20) E_RLM(30); y_axies_ERM];

b = bar(x1,y_axies);
leg = legend('RLM','ERM');
leg.FontSize = 14;
pos = get(leg,'position');
new_pos=pos;
new_pos(1)=pos(1)-0.33;
set(leg,'position',new_pos);
set(gca, 'XTickLabel',{'W = 1','W = 5', 'W = 10', 'W = 20','W = 30'})
xlabel('Order of the Polynomial')
ylabel('Empirical Square Loss')
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom')
title('Empirical Square Loss for RLM with Regularizer λ=0.0025 and ERM for W = 1, 5, 10, 20 and 30');
print -depsc bar_ERM_RLM
