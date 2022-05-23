#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 4                                # number of cores   
#SBATCH -t 2:00:00                          # max running time
#SBATCH -J fastQC_filter_fastQC_138_L001     # job name
#SBATCH -o out/fastQC_filter_fastQC_138_L001_%A.out # standard output
#SBATCH -e err/fastQC_filter_fastQC_138_L001_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools FastQC/0.11.9 cutadapt/3.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/fastQC_filter_fastQC_138_L001_$SLURM_JOB_ID
jobDir=$projDir/jobs/fastQC_filter_fastQC_138_L001_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/P18452_138_S51* $SNIC_TMP
cd $SNIC_TMP

#Running fastQC=>already happened
fastqc P18452_138_S51_L001_R1_001.fastq.qz
fastqc P18452_138_S51_L001_R2_001.fastq.qz

#Run cutadapt for paired adapters
#cutadapt -a ADAPTER_FWD -A ADAPTER_REV -o out.1.fastq -p out.2.fastq reads.1.fastq reads.2.fastq
#I use two adapter sequences provided by illumina:
#Read 1: AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
#Read 2: AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
cutadapt --nextseq-trim=20 -o 138_L001_R1_ca.fastq.gz -p 138_L001_R2_ca.fastq.gz \
P18452_138_S51_L001_R1_001.fastq.qz P18452_138_S51_L001_R2_001.fastq.qz

#Running fastQC again
fastqc 138_L001_R1_ca.fastq.gz
fastqc 138_L001_R2_ca.fastq.gz

#Transfer results back to job directory
echo [`date`] Receiving result file
cp 138_L001_R{1,2}_ca.fastq.gz *.html $jobDir
