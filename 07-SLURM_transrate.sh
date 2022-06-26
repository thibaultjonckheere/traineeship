#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 8                                # number of cores   
#SBATCH -t 3:00:00                          # max running time
#SBATCH -J merged_transrate_trinity                         # job name
#SBATCH -o out/merged_transrate_trinity_%A.out # standard output
#SBATCH -e err/merged_transrate_trinity_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools blast/2.9.0+ transrate/1.0.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/merged_transrate_trinity_$SLURM_JOB_ID
jobDir=$projDir/jobs/merged_transrate_trinity_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#Run job code
# $ transrate --assembly transcripts.fa \
#             --left left.fq \
#             --right right.fq
transrate --install-deps all
transrate --assembly Trinity.fasta \
--left R1_normalized_merged.fq.normalized_K25_C50_pctSD200.fq \
--right R2_normalized_merged.fq.normalized_K25_C50_pctSD200.fq

#removing used files before transfer of results
rm *fastq *fasta

#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r /scratch/$SLURM_JOB_ID/ $jobDir
