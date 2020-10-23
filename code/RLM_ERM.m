% -- EMR --

% Vector of outputs
t = output;
% Vector of 1's
o = ones(100,1);
% Number of samples
N = 100;

% -- First interaction --
% Design matrix for W = 1
X_ERM = [o, input];
w_1 = (X_ERM'* X_ERM)^-1 * X_ERM' * t;
polynomials_wi_ERM = {w_1};   % <------ contains all w_i for W = 1,...,30
design_matrix = {X_ERM};      % <------ contains all x_i for W = 1,...,30
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

% Design matrix for W = 1
X = [o, input];

% -- 20 interactions (to find the design matrix of W = 20) --
for W = 2:20
    % Design matrix for W = 20
    X = [X, input.^W];
end
[x_row,x_column] = size(X);

% -- i interactions (over lambda) --
for i = 1:30
    % Regularizer
    lambda = exp((-1)*i);
    w_i = (X'* X + lambda * eye(x_column))^-1 * X' * t;
    polynomials_wi{i,1} =  w_i;
    
    % Empirical Square Loss %
    E_RLM(i) =  1/2 * 1/N * norm((X * polynomials_wi{i}) - t)^2 + lambda/2 * norm(polynomials_wi{i})^2; % Regularizer
end

%Line Graph for RLM and ERM
figure
plot(E_RLM, 'LineWidth', 2);
grid;
axis([1 30 0 2.6]);
title('Empirical Square Loss for EMR and RLM');
ylabel('Empirical Risk, Regularized Risk'); 
xlabel('W, i'); 
hold on
plot(E_ERM, 'LineWidth', 2);
legend('Polynomial W = 20 with Regularizer','Polynomial W = 1 up to W = 30 without Regularizer');
hold off

% ERM Polynomial Order 2 and 27
figure
p2 = flip(polynomials_wi_ERM{11}');
p27 = flip(polynomials_wi_ERM{21}');

fplot(poly2sym(p2),[min(input) max(input)], 'LineWidth',2)

title('Polynomial of Order 2 and 27');
ylabel('t, Empirical Risk'); 
xlabel('x, W');
hold on

fplot(poly2sym(p27),[min(input) max(input)],'LineWidth',2);

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('W = 2.','W = 27', 'Dataset');
hold off
print -depsc epsERM2_27

% RLM Polynomial Order 20 with i = 2 and i = 30
figure
p2 = flip(polynomials_wi{2}');
p30 = flip(polynomials_wi{30}');

fplot(poly2sym(p2),[min(input) max(input)], 'LineWidth',2)

title('Polynomial of Order 20 i = 2 and i = 30');
ylabel('t, Regularized Risk'); 
xlabel('x, i');
hold on

fplot(poly2sym(p30),[min(input) max(input)],'LineWidth',2);

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('i = 2.','i = 30', 'Dataset');
hold off
print -depsc epsRLM2_30

% RLM Polynomial of Order 20 and i = 30 and ERM of order 20
figure('Position', [10 10 900 400])
p30_rlm = flip(polynomials_wi{30}');
p21_erm = flip(polynomials_wi_ERM{20}');

fplot(poly2sym(p30_rlm),[min(input) max(input)], 'LineWidth',1)

title('RLM Polynomial of Order 20 and i = 30 and ERM of Order 20');
ylabel('t'); 
xlabel('x');
hold on

fplot(poly2sym(p21_erm),[min(input) max(input)],'LineWidth',1);

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('RLM of W = 20 and i = 30.','ERM of W = 20', 'Dataset');
hold off
print -depsc eps2Poly


