#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 8                                # number of cores   
#SBATCH -t 2:00:00                          # max running time
#SBATCH -J 138_L001_transrate                         # job name
#SBATCH -o out/138_L001_transrate_%A.out # standard output
#SBATCH -e err/138_L001_transrate_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools blast/2.9.0+ transrate/1.0.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/138_L001_transrate_$SLURM_JOB_ID
jobDir=$projDir/jobs/138_L001_transrate_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/138_L001* data/transcripts_L001.fasta $SNIC_TMP
cd $SNIC_TMP

#unzipping the fastq files
gunzip 138_L001*.fastq.gz

#Run job code
# $ transrate --assembly transcripts.fa \
#             --left left.fq \
#             --right right.fq
transrate --install-deps all
transrate --assembly transcripts_L001.fasta \
--left 138_L001_R1_trimmed_paired.fastq \
--right 138_L001_R2_trimmed_paired.fastq

#removing used files before transfer of results
rm *fastq *fasta

#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r /scratch/$SLURM_JOB_ID/ $jobDir
