% -- RLM for different lamda - plot polynomial --

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

    % Polynomial
    p10 = flip(polynomials_wi{10}');
    fplot(poly2sym(p10),[min(input) max(input)], 'LineWidth',2)
    hold on
    title('Polynomial of Order 10 - RLM');
    ylabel('t'); 
    xlabel('x');
    
    lambda = lambda * 0.1;
end
scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
leg = legend('λ = 0.025', 'λ = 0.0025', 'λ = 0.00025', 'λ = 0.000025', 'Dataset');
leg.FontSize = 10;
print -depsc RML_FOR_POLY_2
hold off
