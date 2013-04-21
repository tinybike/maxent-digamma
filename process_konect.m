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
        counts = hist(in_edges, min(in_edges):max(in_edges));
    case 'out'
        counts = hist(out_edges, min(out_edges):max(out_edges));
    otherwise
        edges = [in_edges; out_edges];
        counts = hist(edges, min(edges):max(edges));        
end

counts(~counts) = [];
counts = counts';