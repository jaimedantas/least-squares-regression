% -- RLM --

% Vector of outputs
t = output;
% Vector of 1's
o = ones(100,1);
% Number of samples
N = 100;

% Design matrix for W = 1
X = [o, input];

% -- 30 interactions (to find the design matrix of W = 30) --
for W = 2:30
% Design matrix for W = 30
X = [X, input.^W];
end
[x_row,x_column] = size(X);

% -- i interactions (over lambda) --
for i = 1:30
% Regularizer
lambda = exp((-1)*i);
w_i = (X'* X + lambda * eye(x_column))^-1 * X' * t;
       polynomials_wi{i,1} =  w_i;
       
       % Empirical Square Loss
       E(i) =  1/2 * 1/N * norm((X * polynomials_wi{i}) - t)^2 + lambda/2 * norm(polynomials_wi{i})^2;
       end
       
       % Polynomial with the Min RLM
       [minimum_RLM, i] = min(E)
       
       % Line Graph
       figure
       plot(E, 'LineWidth', 2);
       grid;
       axis([1 30 0 2.6]);
       title('Empirical Square Loss for RLM of W = 30 Polynomial with Regularizer λ');
       ylabel('Regularized Risk');
       xlabel('i');
       
       print -depsc epsM20R
       
       % Polynomial Order 30 with i = 26
       figure
       hold on
       p_w30_i26 = flip(polynomials_wi{26}');
                        fplot(poly2sym(p_w30_i26),[min(input) max(input)], 'LineWidth',2)
                        hold off
                        
                        title('Polynomial of Order 30 and i = 26 and Dataset');
                        ylabel('t');
                        xlabel('x');
                        hold on
                        
                        scatter(input, output)
                        axis([-1.1 1.1 -2 1.5]);
                        legend('W = 30 and i = 26','Dataset');
                        hold off
                        print -depsc epsRLMDataset
