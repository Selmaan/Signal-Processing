function impulseResponse = impulseAR(p)

impulseResponse = zeros(1e3,1);
impulseResponse(50) = 1;
p = p(:)';

for ind = 51:1e3
    impulseResponse(ind) = p*impulseResponse(ind-1:-1:ind-length(p));
end