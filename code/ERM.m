% -- EMR --

% Vector of outputs
t = output;
% Vector of 1's
o = ones(100,1);
% Number of samples
N = 100;

% -- First interaction --
% Design matrix for W = 1
X = [o, input];
w_1 = (X'* X)^-1 * X' * t;
polynomials_wi = {w_1};   % <------ contains all w_i for W = 1,...,30
design_matrix = {X};    % <------ contains all x_i for W = 1,...,30
% -- W-1 interactions --
for W = 2:30
    % Design matrix
    X = [X, input.^W];
    w_i = (X'* X)^-1 * X' * t;
    polynomials_wi{W,1} =  w_i;
    design_matrix{W,1} = X;
end

% Empirical Square Loss
for W = 1:30
    E(W) =  1/2 * 1/N * norm((design_matrix{W} * polynomials_wi{W}) - t)^2;
end

% Polynomial with the Min ERM
[minimum_ERM,orderW] = min(E)

% Line Graph
figure
plot(E, 'LineWidth', 2);
axis([1 30 0 1]);
grid;
title('Empirical Square Loss for ERM of W Polynomials');
ylabel('Empirical Risk'); 
xlabel('W'); 
print -depsc epsERM

% Polynomial Order 21
figure
p21 = flip(polynomials_wi{27}');

fplot(poly2sym(p21),[min(input) max(input)], 'LineWidth',2)
title('Polynomial of Order 21 and Dataset');
ylabel('t'); 
xlabel('x');
hold on

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('W = 21','Dataset');
hold off
print -depsc epsERMDataset

% Polynomial Order 6
figure
p6 = flip(polynomials_wi{6}');

fplot(poly2sym(p6),[min(input) max(input)], 'LineWidth',2)
title('Polynomial of Order 6 and Dataset');
ylabel('t'); 
xlabel('x');
hold on

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('W = 6','Dataset');
hold off
print -depsc epsERMOrder6



