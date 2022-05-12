#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 1                                # number of cores   
#SBATCH -t 1:00:00                          # max running time
#SBATCH -J test1_rnaSPAdes_129                         # job name
#SBATCH -o out/test1_rnaSPAdes129%A.out # standard output
#SBATCH -e err/test1_rnaSPAdes129%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools spades/3.15.3


#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/'''job_name_'''$SLURM_JOB_ID
jobDir=$projDir/jobs/'''job_name_'''$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/'''inputfile''' $SNIC_TMP
cd $SNIC_TMP

#Run job code
#rnaspades.py [options] -o <output_dir> 
#spades.py --rna
spades.py --rna -1 forwardreads.fastq.gz -2 reversereads.fastq.gz -o output

#Transfer results back to job directory
echo [`date`] Receiving result file
cp '''outputfile''' $jobDir