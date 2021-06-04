d_list = [4, 6, 8, 10];
h_list = [5, 10, 20, 50];
r_list = [5, 10, 15, 20];

dl = length(d_list);
hl = length(h_list);
rl = length(r_list);
tl = 5;
time_table = zeros(dl, hl, rl, tl);

for i=1:dl
    d = d_list(i);
    for j=1:hl
        h = h_list(j);
        for l=1:tl
         %% network params
            dims = [d, h + 2 * d, d];
            dim_in = dims(1);
            dim_out = dims(end);
            num_neurons = sum(dims(2:end-1));
            num_layers = length(dims)-2;
            net = nnsequential(dims,'relu');

            alpha1 = rand(1);
            alpha2 = rand(1);

            w1 = 5 * rand(h, d) - 5;
            b1 = 5 * rand(h, 1) - 5;

            w2 = 5 * rand(d, h) - 5;
            b2 = 5 * rand(d, 1) - 5;

            w1 = 1./ (norm(w1) * (1 + alpha1)) * w1;
            w2 = 1./ (norm(w2) * (1 + alpha2)) * w2;

            w1_ = [w1; eye(d); -eye(d)];
            w2_ = [w2, eye(d), -eye(d)];
            b1_ = [b1; zeros(d, 1); zeros(d, 1)];
            b2_ = b2;

            net.weights{1} = w1_;
            net.weights{2} = w2_;

            net.biases{1} = b1_;
            net.biases{2} = b2_;

            xc = rand(d, 1);
            for k=1:rl
                r = r_list(k);
       
                output = nn_is_invertible(net,xc, r);
                time = output.time;
                time_table(i, j, l, k) = time;
                disp([i, j, l, k, time])
            end
        end
    end
end
% time_array = mean(time_table, 4);
save('exp.mat');