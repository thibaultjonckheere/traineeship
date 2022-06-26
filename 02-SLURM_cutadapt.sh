#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 4                                # number of cores   
#SBATCH -t 2:00:00                          # max running time
#SBATCH -J filter_fastQC_119_L001     # job name
#SBATCH -o out/filter_fastQC_119_L001_%A.out # standard output
#SBATCH -e err/filter_fastQC_119_L001_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools FastQC/0.11.9 cutadapt/3.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/filter_fastQC_119_L001_$SLURM_JOB_ID
jobDir=$projDir/jobs/filter_fastQC_119_L001_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#Run cutadapt for poly-G removal
cutadapt --nextseq-trim=20 -o 119_L001_R1_ca.fastq.gz -p 119_L001_R2_ca.fastq.gz \
reads_119_L001_non_rRNA_1.fq.gz reads_119_L001_non_rRNA_2.fq.gz

#Running fastQC again
fastqc 119_L001_R1_ca.fastq.gz
fastqc 119_L001_R2_ca.fastq.gz

#Transfer results back to job directory
echo [`date`] Receiving result file
cp 119_L001_R{1,2}_ca.fastq.gz *.html $jobDir
