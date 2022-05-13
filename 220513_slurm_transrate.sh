#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 8                                # number of cores   
#SBATCH -t 2:00:00                          # max running time
#SBATCH -J transrate                         # job name
#SBATCH -o out/129_L001_transrate%A.out # standard output
#SBATCH -e err/129_L001_transrate%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinf-tools transrate/1.0.3

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/129_L001_transrate_$SLURM_JOB_ID
jobDir=$projDir/jobs/129_L001_transrate_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#unzipping the fastq files
gunzip *fastq.gz

#Run job code
# $ transrate --assembly transcripts.fa \
#             --left left.fq \
#             --right right.fq
transrate --assembly \
--left \
--right


#Transfer results back to job directory
echo [`date`] Receiving result file
cp transrate.csv $jobDir