qsub -l h_vmem=4G -l matlab=1 -cwd -j y -o logs/ -t 1-8 -l hostname=node20 pop lnpmodel3
qsub -l h_vmem=4G -l matlab=1 -cwd -j y -o logs/ -q matlabstat.q -t 1-60 pop lnpmodel3
