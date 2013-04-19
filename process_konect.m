function counts = process_konect(data_path, delim, directed)
% Process edge list data (from the Konect website), and output the counts.

data = importdata(data_path, delim);

out_edges = data(:,1);
in_edges = data(:,2);

clear data

node_index = unique([in_edges out_edges]);
num_nodes = length(node_index);

switch directed
    case 'in'
        counts = zeros(num_nodes,1);
        for ii = 1:num_nodes
            counts(ii) = nnz(node_index(ii) == in_edges);    
        end
    case 'out'
        counts = zeros(num_nodes,1);
        for ii = 1:num_nodes
            counts(ii) = nnz(node_index(ii) == out_edges);
        end
    otherwise
        out_counts = zeros(num_nodes,1);
        in_counts = zeros(num_nodes,1);
        for ii = 1:num_nodes
            out_counts(ii) = nnz(node_index(ii) == out_edges);
            in_counts(ii) = nnz(node_index(ii) == in_edges);    
        end
        counts = in_counts + out_counts;
end

counts(~counts) = [];