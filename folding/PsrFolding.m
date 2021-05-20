function [pf_data, remaining] = PsrFolding(data,accerr,period,dt)

%------------------------------------------------
% Description:
% In this function, we will do:
% 1. do floding
%------------------------------------------------


% let's do floding next
acc_int = 0;
acc_double = accerr;

n_int = floor(period/dt);
n_double = period/dt;

[r,c] = size(data);
n = r;

pf_data = zeros(c, n_int);
sum_cnt = 0;
start_index = 1;
end_index = start_index + n_int - 1;
while(n > n_int)
    pf_data = pf_data + data(start_index:end_index,:)';
    sum_cnt = sum_cnt + 1;
    acc_int = acc_int + double(n_int);
    acc_double = acc_double + n_double;
    acc_err = acc_double - acc_int;
    if(acc_err > 1)
       acc_int = acc_int + 1; 
       n = n - 1;
       start_index = start_index + 1;
    end
    start_index = start_index +n_int;
    end_index = start_index + n_int - 1;
    n = n - n_int;
end
pf_data = pf_data/sum_cnt;
% we have some remaining data, so we need to return them back
% we also return the acc err back
% both of them will be useful, if we keeping doing folding
remaining{1} = data(start_index:r,:);
remaining{2} = acc_double - acc_int;
end

