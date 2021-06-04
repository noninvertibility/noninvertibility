function [certified_radius,time,status,preimage] = nn_local_inv_MILP(net,xc,mode)

%
% DESCRIPTION HERE
%
%
time = 0;
certified_radius = 0;
preimage = xc;
iter = 0;
status = '';


r_max = 0.1;
if(strcmp(mode,'PI'))
    result = nn_is_pseudo_invertible(net,xc,r_max);
end

if(strcmp(mode,'BL'))
    result = nn_is_invertible(net,xc,r_max);
end


function_status = result.function_status;
time = time + result.time;
iter = iter + 1;

message = ['iter = ', num2str(iter),'| time: ', num2str(time),'| certified radius: ',num2str(certified_radius),'| method: MILP', '| solver: Gurobi'];
disp(message);

if(function_status==0)
    certified_radius = 0;
    preimage = [result.x0 result.y0];
    status = 'not pseudo invertible';
    return;
end

if(function_status==-1)
    certified_radius = 0;
    status = 'time limit reached';
    return;
end

if(function_status==-2)
    certified_radius = 0;
    status = 'problem infeasible or unbounded';
    return;
end


while(function_status==1)
    certified_radius = r_max;
    
    message = ['iter = ', num2str(iter),'| time: ', num2str(time),'| certified radius: ',num2str(certified_radius),'| method: MILP', '| solver: Gurobi'];
    disp(message);
    
    lower = r_max;
    
    r_max = 5*r_max;
    upper = r_max;
    
    if(strcmp(mode,'PI'))
        result = nn_is_pseudo_invertible(net,xc,r_max);
    end
    
    if(strcmp(mode,'BL'))
        result = nn_is_invertible(net,xc,r_max);
    end
    function_status = result.function_status;
    time = time + result.time;
    preimage = result.x0;
    iter = iter + 1;
end

if(function_status==-1)
    status = 'time limit reached';
    return;
end


for ii=1:25
    
    r_max = 0.5*(lower+upper);
    
    if(strcmp(mode,'PI'))
        result = nn_is_pseudo_invertible(net,xc,r_max);
    end
    
    if(strcmp(mode,'BL'))
        result = nn_is_invertible(net,xc,r_max);
    end
    
    
    function_status = result.function_status;
    time = time + result.time;
    message = ['iter = ', num2str(iter),'| time: ', num2str(time),'| certified radius: ',num2str(certified_radius),'| method: MILP', '| solver: Gurobi'];
    disp(message);
    iter = iter + 1;
    
    if(function_status==0)
        preimage = [result.x0 result.y0];
    end
    
    if(function_status==-1)
        status = 'time limit reached';
        return;
    end
    
    if(function_status==-2)
        status = 'problem infeasible or unbounded';
        return;
    end
    
    if(function_status==1)
        certified_radius = r_max;
        if(upper-lower<=1e-3)
            status = 'invertible';
            return;
        else
            lower = r_max;
        end
    else
        upper = r_max;
    end
    
    
end

end


