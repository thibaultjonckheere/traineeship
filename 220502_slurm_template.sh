#!/bin/bash -l
 
#SBATCH -A snic2022-22-434      # project ID = SNIC 2022/22-434
#SBATCH -p core                 # core or node
#SBATCH -n 1                    # number of cores   
#SBATCH -t 12:00:00             # max running time
#SBATCH -J some_job_name        # job name
#SBATCH -o                      # standard output
#SBATCH -e                      # standard error
#SBATCH --mail-type=ALL         # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules


#Create job directory


#Transfer data to compute node disk


#Run job code


#Transfer results back to job directory