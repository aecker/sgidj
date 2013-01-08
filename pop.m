function pop(file, wait)
% Populate DJ tables using the cluster
%   pop(file) populates the tables specified in the given file.
%
%   Tables and restrictions to apply when populating are specified in a
%   config file. Each line in the config file specifies either a script to
%   run (run), a folder to add to the path (path), a table to populate
%   (table), or a restriction to apply to the table indicated previously
%   (restr). Restrictions are applied using eval, i.e. string need to be in
%   quotes. E.g.
%
%   path    ~/lab/libraries/matlab
%   run     ~/lab/projects/acq/alex_setPath.m 
%   run     ~/lab/projects/anesthesia/code/setPath.m
%   path    ~/lab/libraries/various/mex_tt
%   run     djstart.m
%
%   table   nc.LnpModel3Set
%   restr   'sort_method_num = 5 AND min_freq = 0'
%
%   table   nc.LnpModel3
%   restr   'num_trials = -1'
%   restr   ephys.Spikes
%
% AE 2012-09-28

try
    
    % wait for some time to desynchronize the processes a bit?
    if nargin > 1
        if ischar(wait)
            wait = str2double(wait);
        end
        pause(2 * wait)
        rng(wait)
    end
    
    % parse config file
    res = parse(file);
    
    % process commands
    tables = {};
    restrictions = {};
    k = 0;
    for r = res
        switch r.cmd
            case 'run'
                fprintf('run %s\n', r.arg)
                run(r.arg)
            case 'path'
                fprintf('addpath %s\n', r.arg)
                addpath(r.arg)
            case 'table'
                fprintf('table %s\n', r.arg)
                k = k + 1;
                tables{k} = eval(r.arg); %#ok<*AGROW>
                restrictions{k} = {};
            case 'restr'
                fprintf('restriction %s\n', r.arg)
                restrictions{k}{end + 1} = eval(r.arg);
        end
    end
    
    % populate tables
    for i = 1 : k
        parpopulate(tables{i}, restrictions{i}{:})
    end
    
    fprintf('Done!\n\n')

catch err
    err %#ok
    err.message
    for i = 1 : numel(err.stack)
        err.stack(i)
    end
end
