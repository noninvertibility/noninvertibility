function output = nn_is_invertible(net,xc,radius)

%%% Description
% this function verifies whether a FFC neural network is invertible in
% the region {x | norm(x-xc,inf)<= r} by solving an MIQP
%
% parameters:
%               - net: nnsequential object
%               - xc: a given input to NN
%               - radius: distance of x from xc


output.x0 = [];
output.y0 = [];
output.time = [];
output.function_status = [];
output.solver_status = [];


% interval arithmetic to find the big M
x_min = xc-radius;
x_max = xc+radius;
%[Y_min,Y_max,X_min,X_max,~,~] = net.interval_arithmetic(x_min,x_max);


% number of hidden layers (activation layers)
%num_layers = length(net.dims)-2;

% input dimension
dim_in = net.dims(1);

% output dimension
dim_out = net.dims(end);

% number of neurons in the last hidden layer
dim_last_hidden = net.dims(end-1);

% total number of neurons
num_neurons = sum(net.dims(2:end-1));


Wout = net.weights{end};
%bout = net.biases{end}(:);


W = blkdiag(net.weights{1:end-1});
b = cat(1,net.biases{1:end-1});

%[Y_min,Y_max] = piecewise_linear_bounds_ReLU(net.weights,net.biases,xc,radius*ones(size(xc)));
%X_min = max(Y_min,0);
%X_max = max(Y_max,0);

[Y_min,Y_max,X_min,X_max,~,~] = net.interval_arithmetic(x_min,x_max);

A = [W zeros(size(W,1),dim_last_hidden)];
B = [zeros(num_neurons,dim_in) eye(num_neurons)];


dim_x = num_neurons + dim_in;
dim_y = dim_x;
dim_t = num_neurons;
dim_s = dim_t;

E0 = [eye(dim_in) zeros(dim_in,num_neurons)];
El = [zeros(dim_last_hidden,dim_in+num_neurons-dim_last_hidden) eye(dim_last_hidden)];


% AG * [x;t;y;s]>=bG

% x_{k+1} = max(W_k x_k + b_k,0) k=0,...,l-1
AG = [B-A zeros(size(B,1),dim_t) zeros(size(B,1),dim_y) zeros(size(B,1),dim_s)];
AG = [AG;A-B diag(Y_min) zeros(size(B,1),dim_y) zeros(size(B,1),dim_s)];
AG = [AG;B zeros(size(B,1),dim_t) zeros(size(B,1),dim_y) zeros(size(B,1),dim_s)];
AG = [AG;-B diag(Y_max) zeros(size(B,1),dim_y) zeros(size(B,1),dim_s)];

% y_{k+1} = max(W_k y_k + b_k,0) k=0,...,l-1
AG = [AG; zeros(size(B,1),dim_x) zeros(size(B,1),dim_t) B-A zeros(size(B,1),dim_s)];
AG = [AG; zeros(size(B,1),dim_x) zeros(size(B,1),dim_t) A-B diag(Y_min)];
AG = [AG; zeros(size(B,1),dim_x) zeros(size(B,1),dim_t) B zeros(size(B,1),dim_s)];
AG = [AG; zeros(size(B,1),dim_x) zeros(size(B,1),dim_t) -B diag(Y_max)];

bG = [b;-b+Y_min;zeros(size(B,1),1);zeros(size(B,1),1);b;-b+Y_min;zeros(size(B,1),1);zeros(size(B,1),1)];

% f(x0)==f(y0)
AG = [AG;Wout*El*[eye(dim_x) zeros(dim_x,dim_t) -eye(dim_y) zeros(dim_x,dim_s)]];
AG = [AG;-Wout*El*[eye(dim_x) zeros(dim_x,dim_t) -eye(dim_y) zeros(dim_x,dim_s)]];
bG = [bG;zeros(dim_out,1);zeros(dim_out,1)];


% linf: norm(x0-xc,inf) <= radius
% norm(x0-xc,inf) <= radius
AG = [AG;E0 zeros(dim_in,dim_t) zeros(dim_in,dim_y) zeros(dim_in,dim_s);-E0 zeros(dim_in,dim_t) zeros(dim_in,dim_y) zeros(dim_in,dim_s)];
bG = [bG;xc-radius;-xc-radius];
% norm(y0-xc,inf) <= radius
AG = [AG;zeros(dim_in,dim_x) zeros(dim_in,dim_t) E0  zeros(dim_in,dim_s);zeros(dim_in,dim_x) zeros(dim_in,dim_t) -E0 zeros(dim_in,dim_s)];
bG = [bG;xc-radius;-xc-radius];


% % norm(x0-y0,inf)>=r
% % [AG 0;BG] * [x;t;y;s|w;r;r']>=[bG;cg]
dim_r = dim_in;
 
M = 4*radius;

BG = [E0 zeros(dim_in,dim_t) -E0 zeros(dim_in,dim_s) -ones(dim_in,1) -M*eye(dim_in) zeros(dim_in,dim_in)];
BG = [BG;-E0 zeros(dim_in,dim_t) E0 zeros(dim_in,dim_s) ones(dim_in,1) zeros(dim_in,dim_in) zeros(dim_in,dim_in)];

BG = [BG;-E0 zeros(dim_in,dim_t) E0 zeros(dim_in,dim_s) -ones(dim_in,1) zeros(dim_in,dim_in) -M*eye(dim_in)];
BG = [BG;E0 zeros(dim_in,dim_t) -E0 zeros(dim_in,dim_s) ones(dim_in,1) zeros(dim_in,dim_in) zeros(dim_in,dim_in)];

BG = [BG;zeros(dim_in,dim_x) zeros(dim_in,dim_t) zeros(dim_in,dim_y) zeros(dim_in,dim_s) zeros(dim_in,1) -ones(dim_in,dim_in) -ones(dim_in,dim_in)];

BG = [BG;zeros(1,dim_x) zeros(1,dim_t) zeros(1,dim_y) zeros(1,dim_s) 0 ones(1,dim_in) ones(1,dim_in)];

BG = [BG;zeros(1,dim_x) zeros(1,dim_t) zeros(1,dim_y) zeros(1,dim_s) 0 -ones(1,dim_in) -ones(1,dim_in)];

cg = [-M*ones(dim_in,1);zeros(dim_in,1);-M*ones(dim_in,1);zeros(dim_in,1);-ones(dim_in,1);1;-1];

AG = [AG zeros(size(AG,1),1+2*dim_r);BG];
bG = [bG;cg];


try
    clear model;
    
    % maximize w subject to
    % {norm(x0-xc,inf)<=radius,norm(y0-xc,inf)<=radius,f(x0)=f(y0),
    % norm(x0-y0,inf)>=w}
    % if the optimal value is zero --> invertible 
    % if the optimal value is positive --> NON-invertible
    
    
    
    % objective function quadratic coefficient
    model.Q = sparse(zeros(dim_x+dim_y+dim_s+dim_t+2*dim_r+1));
    
    % objective function linear coefficient 
    model.obj = [zeros(dim_x+dim_y+dim_s+dim_t,1);1;zeros(dim_r,1);zeros(dim_r,1)];
    
    % The constant offset in the objective function
    model.objcon = 0;
    
    
    
    % constraints
    model.A = sparse(AG);
    model.rhs = bG;
    model.sense = repmat('>', 1, size(AG,1));
    
    % bounds on the decision variables
    model.lb = [x_min;X_min;zeros(dim_t,1);x_min;X_min;zeros(dim_s,1);0;zeros(2*dim_r,1)];
    model.ub = [x_max;X_max;ones(dim_t,1);x_max;X_max;ones(dim_s,1);2*radius;ones(2*dim_r,1)];
    
    % type of variables (continuous/integer)
    model.vtype = [repmat('C', 1, dim_x) repmat('B', 1, dim_t) repmat('C', 1, dim_y) repmat('B', 1, dim_s) repmat('C',1,1) repmat('B',1,2*dim_r)];
    
    model.modelsense = 'max';
   
    
    % initial guess
    % model.start = initguess;
    
    clear params;
    params.outputflag = 0;
    params.timelimit = 10*60*60;
    % params.NonConvex = 2;
    %global tol;
    %params.MIPGapAbs = ;
    
    result = gurobi(model, params);
    
catch gurobiError
    fprintf('Error reported\n');
    gurobiError.message
    gurobiError.message.stack
end



if strcmp(result.status, 'OPTIMAL')
    bound = result.objval;
    output.time = result.runtime;
    output.solver_status = result.status;
    output.x0 = E0*result.x(1:dim_x);
    output.y0 = E0*result.x(dim_x+dim_t+1:dim_x+dim_t+dim_y);
    %output.obj = result.x(dim_x+dim_t+dim_y+dim_s+1);
    if(bound<=1e-4)
        output.function_status = 1;
        %disp('function is invertible');
    else
        output.function_status = 0;
        %disp('function is not invertible');
    end
    
elseif strcmp(result.status, 'TIME_LIMIT')
    output.solver_status = result.status;
    output.function_status = -1;
    output.time = result.runtime;
    output.x0 = E0*result.x(1:dim_x);
    output.y0 = E0*result.x(dim_x+dim_t+1:dim_x+dim_t+dim_y);
    %disp('time limit reached.');
else
    output.function_status = -2;
    output.time = result.runtime;
    output.solver_status = result.status;
    output.x0 = E0*result.x(1:dim_x);
    output.y0 = E0*result.x(dim_x+dim_t+1:dim_x+dim_t+dim_y);
    %disp('infeasible or unbounded problem.');
end

end