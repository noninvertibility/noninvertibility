clc;
clear all;

addpath('../');

num_layers = 2;

for i=1:num_layers+1
    
    ID = fopen(['b',num2str(i),'.txt'],'r');
    biases{i} = fscanf(ID,'%f');
    fclose(ID);
    
    ID = fopen(['w',num2str(i),'.txt'],'r');
    weights{i} = fscanf(ID,'%f');
    fclose(ID);
end

%% network params
dims = [2,64,64,2];
dim_in = dims(1);
dim_out = dims(end);
num_neurons = sum(dims(2:end-1));
num_layers = length(dims)-2;
net = nnsequential(dims,'relu');

% input = [1.96433 1.24951 2.1]';
input = [0.666201 1.99221 2.1]';

weights{1} = reshape(weights{1},64,3);
weights{2} = reshape(weights{2},64,64);
weights{3} = reshape(weights{3},2,64);

net.weights{1} = weights{1}(:,1:2);
net.weights{2} = weights{2};
net.weights{3} = weights{3};

net.biases{1} = input(3)*weights{1}(:,end)+biases{1};
net.biases{2} = biases{2};
net.biases{3} = biases{3};

xc = input(1:2);
[certified_radius,time,status,preimage] = nn_local_inv_MILP(net,xc,'PI');