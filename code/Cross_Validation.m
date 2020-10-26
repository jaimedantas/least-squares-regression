% -- Cross-Validation --

t = output;
x = input;
split_t = {};
split_x = {};
split_indexes = {};
i = 1;

% List of already picked indexes
already_picked = [];

% Randomly Split of Dataset in k = 10
for j = 1:10
    while i <= 10
        index = randi(100);

        % Already picked 
        if find(already_picked==index) > 0
            index = randi(100);
        else
            split_t{j}{i} = t(index);
            split_x{j}{i} = x(index);
            already_picked(end+1) = index;
            split_indexes{j}{i} = index;
            i = i + 1;
        end
    end    
    i = 1;
end

% 10-fold Cross-Validation for EMR
N = 10;
% Vector of 1's
o_training = ones(90,1);
o_testing = ones(10,1);


for k = 1:10
    
    % k-1 Training Folds
    training_x = [];
    training_t = [];
    % Testing fold
    testing_x = cell2mat(split_x{k});
    testing_t = cell2mat(split_t{k});
    
    % Training Data
    for i = 1:k-1
        training_x = [training_x, cell2mat(split_x{i})];
        training_t = [training_t, cell2mat(split_t{i})];
    end
    
    for j = k+1:10
        training_x = [training_x, cell2mat(split_x{j})];
        training_t = [training_t, cell2mat(split_t{j})];
    end
        
    % -- First interaction --
    % Design matrix for M = 1
    X_ERM_training = [o_training, training_x'];
    X_ERM_testing  = [o_testing, testing_x'];

    w_1_ERM = (X_ERM_training'* X_ERM_training)^-1 * X_ERM_training' * training_t';
    polynomials_wi_ERM = {w_1_ERM};                     % <------ contains all w_i for W = 1,...,30
    design_matrix_training = {X_ERM_training};          % <------ contains all x_i for W = 1,...,30
    design_matrix_testing = {X_ERM_testing};            % <------ contains all x_i for W = 1,...,30

    % -- W-1 interactions --
    for W = 2:30
        % Design matrix
        X_ERM_training = [X_ERM_training, training_x'.^W];
        X_ERM_testing = [X_ERM_testing, testing_x'.^W];

        % Polynomials W
        w_ERM = (X_ERM_training'* X_ERM_training)^-1 * X_ERM_training' * training_t';
        
        polynomials_wi_ERM{W,1} =  w_ERM;
        design_matrix_training{W,1} = X_ERM_training;
        design_matrix_testing{W,1} = X_ERM_testing;
    end
    
    % Empirical Square Loss
    for W = 1:30
        E{W}{k} =  1/2 * 1/N * norm((design_matrix_testing{W} * polynomials_wi_ERM{W}) - testing_t')^2;
    end
    
end

% Averaged EMR
for l=1:30
    sum = 0;
    for m=1:10
        sum = sum + E{l}{m};
    end
    E_mean(l) = sum/N;
end

[minimum_ERM, W] = min(E_mean)

% Line Graph
figure
plot(E_mean, 'LineWidth', 2);
axis([1 30 0 1]);
grid;
title('Empirical Square Loss for ERM of W Polynomials - Cross-Validation');
ylabel('Empirical Square Loss'); 
xlabel('W'); 
print -depsc epsERMcross_line


% Polynomial Order 6
figure
p6 = flip(polynomials_wi_ERM{6}');
fplot(poly2sym(p6),[min(input) max(input)], 'LineWidth',2)
title('Polynomial of Order 6 and Dataset - Cross-Validation');
ylabel('t'); 
xlabel('x');
hold on

scatter(input, output)
axis([-1.1 1.1 -2 1.5]);
legend('W = 21','Dataset');
print -depsc epsERMCrossPloy2
legend('ERM of order W = 6', 'Dataset');

hold off

%Plot all dataset
figure
hold on
for i = 1:10
    scatter(cell2mat(split_x{i}), cell2mat(split_t{i}))
end
title('Dataset Splited in 10 Folds');
ylabel('t'); 
xlabel('x'); 
axis([-1.1 1.1 -2 1.5]);
legend('N=1', 'N=2', 'N=3', 'N=4', 'N=5','N=6','N=7','N=8','N=9','N=10');
hold off
print -depsc epsCrossData


% Turns Warning Off
warning('off','all');

