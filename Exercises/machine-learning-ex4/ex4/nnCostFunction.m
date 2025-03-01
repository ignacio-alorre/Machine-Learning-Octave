function [J grad] = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, ...
                                   num_labels, X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

	%Part1 - Feedforward
	
	%Map the y vector into a Matrix
	yBin = zeros(m,num_labels);
	
	for i = 1 : m
		yBin(i,y(i)) = 1;
	end
		
	%The first step will be to calculate ho(x) or a3
	%Input Layer
	a1 = [ones(m,1), X];
	
	%Hidden Layer
	z2 = a1 * Theta1';
	a2 = sigmoid(z2);
	a2 = [ones(m,1), a2];
	
	%Output Layer
	z3 = a2 * Theta2';
	a3 = sigmoid(z3);
	
	%Cost Function
	onesMat = ones(size(yBin));
	J = sum(sum((-yBin.*log(a3))-((onesMat-yBin).*log(onesMat-a3)), 2))/m;
	
	%Regularization parameters without bias parameter
	tempTheta1 = Theta1(:, 2:input_layer_size+1);
	sumTheta1 = sum(sum(tempTheta1.^2));
	
	tempTheta2 = Theta2(:, 2:hidden_layer_size+1);
	sumTheta2 = sum(sum(tempTheta2.^2));
	
	%Regularization term
	RegParam= (lambda/(2*m))*(sumTheta1+sumTheta2);
	J = J + RegParam;
	
	%Part 2: Backpropagation 
	d3 = a3 - yBin;
	d2 = (d3 * Theta2).* sigmoidGradient([ones(m,1),z2]);	
	d2temp = d2(:,2:end);
	
	%Theta1_grad = Theta1_grad + ((d2temp' * a1))/m;
	%Theta2_grad = Theta2_grad + ((d3' * a2))/m;
		
	%Part 3: Regularization
	
	tempTheta1 = Theta1;
	tempTheta1(:,1) = 0;
	
	tempTheta2 = Theta2;
	tempTheta2(:,1) = 0;
	
	Reg_Theta1 = (lambda/m)*tempTheta1;
	Reg_Theta2 = (lambda/m)*tempTheta2;

	Theta1_grad = Theta1_grad + ((d2temp' * a1))/m + Reg_Theta1;
	Theta2_grad = Theta2_grad + ((d3' * a2))/m + Reg_Theta2;
	
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
