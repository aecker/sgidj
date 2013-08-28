qsub -l h_vmem=4G -l matlab=1 -cwd -j y -o logs/ -q matlabstat.q -t 1-72 pop gpfamodel

