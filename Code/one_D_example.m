clc;
clear variables;


clc;
clear all;

rng('default');
clf;

%% network params
dims = [1,10,10,1];
dim_in = dims(1);
dim_out = dims(end);
num_neurons = sum(dims(2:end-1));
num_layers = length(dims)-2;
net = nnsequential(dims,'relu');



% cvx_solver mosek;

x_min = -2;
x_max = 2;

if(1)
    x = x_min:1e-2:x_max;
    f = net.eval(x);
    plot(x,f,'linewidth',2);
    xlabel('$x$','Interpreter','latex','fontsize',16);
    ylabel('$f(x)$','Interpreter','latex','fontsize',16);
    axis tight;
    grid on;
    hold on;
end

x_star = -1;


%% MIP for PI

[certified_radius,time,status,preimage] = nn_local_inv_MILP(net,x_star,'PI');

disp(['preimages are: ' num2str(preimage)]);

scatter(x_star,net.eval(x_star),'red');

x_ = [x_star+certified_radius,x_star+certified_radius,x_star-certified_radius,x_star-certified_radius];
y_ = [min(f),max(f),max(f),min(f)];
patch('XData',x_,'YData',y_,'EdgeColor','none','FaceColor','red','FaceAlpha',0.2);

title(['certified radius = ' , num2str(certified_radius)],'interpreter','latex','fontsize',16)
