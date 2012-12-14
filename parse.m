function result = parse(file)
% Parse config file.
%   result = parse(file) returns a structure array containing commands and
%   arguments.
%
% AE 2012-12-12

fid = fopen(file);
if fid < 0
    error('Unable to open file %s!', file)
end
result = struct('cmd', {}, 'arg', {});
while ~feof(fid)
    str = strtrim(fgetl(fid));
    res = regexp(str, '^\s*(?<cmd>%|run|path|table|restr)\s*(?<arg>.)*', 'names', 'once');
    if ~isempty(res)
        result(end + 1) = res; %#ok<AGROW>
    end
end
fclose(fid);
