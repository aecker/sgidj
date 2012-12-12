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
    n = count((tables{i}.popRel & restrictions{i}) - tables{i});
    fprintf('%-8s%s%s\n', sprintf('[%d]', n), class(tables{i}), restr)
end
fprintf('\n')
