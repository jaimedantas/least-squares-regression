% -- RLM for different lamda - plot regularized risk --

% Vector of outputs
t = output;
% Vector of 1's
o = ones(100,1);
% Number of samples
N = 100;

lambda = 0.025;

for l=1:4
    % Design matrix for M = 1
    X = [o, input];
    [x_row,x_column] = size(X);
    w_1 = (X'* X + lambda * eye(x_column))^-1 * X' * t;
    polynomials_wi = {w_1};   % <------ contains all w_i for W = 1,...,30
    design_matrix = {X};    % <------ contains all x_i for W = 1,...,30

    % -- i interactions (over lambda) --
    for W = 2:30
        % Design matrix
        X = [X, input.^W];
        [x_row,x_column] = size(X);
        w_i_n = (X'* X + lambda * eye(x_column))^-1 * X' * t;
        polynomials_wi{W,1} =  w_i_n;
        design_matrix{W,1} = X;
    end

    % Polynomial with the Min RLM
    [minimum_RLM, i] = min(E)

    % Empirical Square Loss
    for W = 1:30
        E(W) =  1/2 * 1/N * norm((design_matrix{W} * polynomials_wi{W}) - t)^2 + lambda/2 * norm(polynomials_wi{W})^2;
    end

    % Line Graph
    plot(E, 'LineWidth', 2);
    hold on
    axis([1 30 0 1.5]);
    title('Empirical Square Loss for RLM for diferent values of λ and W');
    ylabel('Regularized Risk'); 
    xlabel('i'); 
    lambda = lambda * 0.1;
       
end
leg = legend('λ = 0.025', 'λ = 0.0025', 'λ = 0.00025', 'λ = 0.000025');
grid
leg.FontSize = 14;
print -depsc RML_FOR_W
hold off
