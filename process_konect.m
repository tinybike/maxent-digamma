function counts = process_konect(data_path, delim, directed)
% Process edge list data (from the Konect website), and output the counts.
if strcmp(version, '8.1.0.604 (R2013a)')
    if strcmp(data_path, 'network_data/out.movielens-100k_rating')
        fid = fopen(data_path);
        data = textscan(fid, '%d %d %d %d', 'delimiter', ' ',...
            'headerlines', 3, 'CollectOutput', 1);
        fclose(fid);
        out_edges = double(data{1}(:,1));
        in_edges = double(data{1}(:,2));
    else
        try
            data = importdata(data_path, delim, 2);
            out_edges = data.data(:,1);
            in_edges = data.data(:,2);
        catch
            try
                data = importdata(data_path, '\t', 1);
                out_edges = data.data(:,1);
                in_edges = data.data(:,2);
            catch
                try
                    data = importdata(data_path, delim);
                    out_edges = data.data(:,1);
                    in_edges = data.data(:,2);
                catch
                    % Facebook wall post data refuses to be read by importdata
                    % -- should we count self-posts or not??
                    fid = fopen(data_path);
                    data = textscan(fid, '%d %d %d %d', 'delimiter', '\t',...
                        'headerlines', 1, 'CollectOutput', 1);
                    fclose(fid);
                    out_edges = double(data{1}(:,1));
                    in_edges = double(data{1}(:,2));

    %                 % 1. Remove self-connections
    %                 selfies = in_edges == out_edges;
    %                 in_edges(selfies) = [];
    %                 out_edges(selfies) = [];

                    % 2. ONLY self-posts
                    selfies = in_edges == out_edges;
                    in_edges(~selfies) = [];
                    out_edges(~selfies) = [];

    %                 % 3. One post per person (i.e. number of different people
    %                 % posting on your wall, rather than number of posts)
    %                 unique_edges = unique([in_edges out_edges], 'rows');
    %                 in_edges = unique_edges(:,1);
    %                 out_edges = unique_edges(:,2);
                end
            end
        end
    end
else
    if strcmp(data_path, 'network_data/out.facebook-wosn-wall')
        fid = fopen(data_path);
        data = textscan(fid, '%d %d %d %d', 'delimiter', '\t',...
            'headerlines', 1, 'CollectOutput', 1);
        fclose(fid);
        out_edges = double(data{1}(:,1));
        in_edges = double(data{1}(:,2));
        selfies = in_edges == out_edges;
        in_edges(~selfies) = [];
        out_edges(~selfies) = [];
    else
        data = importdata(data_path, delim);
        out_edges = data(:,1);
        in_edges = data(:,2);
    end
end

clear data

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