function status(script)
% Check status of populate process on cluster
%   status(paramscript) checks the status (i.e. number of unpopulated keys)
%   for the given parameter script.
%
% AE 2012-12-12

res = parse(script);
tables = {};
restrictions = {};
k = 0;
for r = res
    switch r.cmd
        case 'table'
            k = k + 1;
            tables{k} = eval(r.arg); %#ok<*AGROW>
            restrictions{k} = {};
        case 'restr'
            restrictions{k}{end + 1} = eval(r.arg);
    end
end

fprintf('\n')
for i = 1 : k
    if ~isempty(restrictions{i})
        restr = sprintf(' & ''%s''', restrictions{i}{:});
    else
        restr = '';
    end
    total = count(tables{i}.popRel & restrictions{i});
    populated = count(tables{i} & restrictions{i});
    jobTable = eval([tables{i}.schema.package '.Jobs']);
    errors = count(jobTable & struct('status', 'error', 'table_name', class(tables{i})));
    running = count(jobTable & struct('status', 'reserved', 'table_name', class(tables{i})));
    fprintf('Table %s%s\n', class(tables{i}), restr)
    fprintf('  %d of %d populated (%.1f%%)\n', populated, total, populated / total * 100)
    fprintf('  %d errors\n', errors)
    fprintf('  %d running\n', running)
    fprintf('\n')
end
