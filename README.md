# mhc_alpha_project

This repository contains the scripts used to conduct the analyses in the manuscript "Expansion of MHC-IIB has constrained the evolution of MHC-IIA in passerines"
Iris L. Ruesink-Bueno, Anna Drews, Emily O’Connor and Helena Westerdahl
Code written and run by Emily O'Connor (2024-03-03)
For questions about the code and analyses: emily.oconnor@biol.lu.se 

Analyses were run using the workflow manager Nextflow (version 23.10.0)

code/
 | - env/                                    Contains YAML file to re-create the nextflow environment used to run the workflows
 | - nonpartitioned/                         Contains workflow script (main.nf) and configuration file (nextflow.config) to run selection analyses (BUSTED, MEME & FUBAR) on non-partitioned dataset  
 | - partitioned/                            Contains workflow script (main.nf) and configuration file (nextflow.config) to run BUSTED-PH test on partitioned dataset. Also contains HyPhy batch file required to run BUSTED-PH
 
 Note that when running partitioned analyses (BUSTED-PH) the input tree needs to be labelled with labels that match the '--branches' and '--comparison' flags.   
 
# Implementation

To reproduce and run the code in Nextflow first create and activate the conda environment (giving it the name 'nextflow-env') that contains the version of Nextflow used to run the analyses in our study and its dependencies. To create the conda environment from the YAML file in the 'env' folder run the following command from within the 'env' folder (note that you will need conda installed for this to work):
```
conda env create -n nextlow-env -f environment.yml
```

The conda environment can then be activated using the following command:
```
conda activate nextlow-env
```

Once the conda environment has been activated, the workflow scripts found within the folders 'partitioned' and 'nonpartitioned' can be run. Note that if Nextflow is installed already on your computer / server, then it would be possible to run these analyses without the conda environment. The conda environment is primarily to aid reproducibility by ensuring the analyses can be run within the same environment.  

The 'partitioned' and 'nonpartitioned' folders each contain a file called 'main.nf' and 'nextflow.config'. The file 'main.nf' contains the workflow itself for each set of analyses (partitioned or nonpartitioned) and 'nextflow.config' contains the file path to the input sequences and, in the case of the nonpartitioned analyses the path to the input tree. Once the 'nextflow.config' file has been edited to contain the appropriate file paths, then the workflow can be run either within the 'partitioned' and 'nonpartitioned' with the following command:
```
nextflow run main.nf
```

Note that the Nextflow scripts (main.nf) call containers to run most of the software (CodonPhyML, PRANK & HyPhy). So you will require internet connection to run the scripts successfully as well having docker installed on your computer / server in order to enable you to run containers. 

The workflow takes one alignment file at a time and thus needs to be run multiple times to reproduce all the results described in the paper. 



