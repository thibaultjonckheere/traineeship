#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 16                                # number of cores   
#SBATCH -t 5:00:00                          # max running time
#SBATCH -J 138_L003_trinity                         # job name
#SBATCH -o out/138_L003_trinity_%A.out # standard output
#SBATCH -e err/138_L003_trinity_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools trinity/2014-07-17

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/138_L003_trinity_$SLURM_JOB_ID
jobDir=$projDir/jobs/138_L003_trinity_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/138_L003* $SNIC_TMP
cd $SNIC_TMP

#Run job code
# Trinity --seqType fq --max_memory 50G --left reads_1.fq  --right reads_2.fq --CPU 6
Trinity --seqType fq --max_memory 50G \
--left 138_L003_R1_trimmed_paired.fastq.gz --right 138_L003_R2_trimmed_paired.fastq.gz \
--CPU 16

#Transfer results back to job directory
echo [`date`] Receiving result file
cp trinity_out_dir/ $jobDir