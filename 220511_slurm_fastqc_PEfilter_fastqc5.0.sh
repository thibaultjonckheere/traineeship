#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 4                                # number of cores   
#SBATCH -t 2:00:00                          # max running time
#SBATCH -J filter_fastQC_     # job name
#SBATCH -o out/filter_fastQC_L001_%A.out # standard output
#SBATCH -e err/fastQC_filter_fastQC_L001_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools FastQC/0.11.9 cutadapt/3.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/01-output_filtering/test2TruSeq_filter_fastQC_L001_$SLURM_JOB_ID
jobDir=$projDir/jobs/01-output_filtering/test2TruSeq_filter_fastQC_L001_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/01-input_filtering/P18452_129_S44_L001_R1_001.fastq.gz data/01-input_filtering/P18452_129_S44_L001_R2_001.fastq.gz $SNIC_TMP
cd $SNIC_TMP

#Running fastQC=>already happened
#fastqc P18452_129_S44_L001_R1_001.fastq.gz
#fastqc P18452_129_S44_L001_R2_001.fastq.gz

#Run cutadapt for paired adapters
#cutadapt -a ADAPTER_FWD -A ADAPTER_REV -o out.1.fastq -p out.2.fastq reads.1.fastq reads.2.fastq
#I use two adapter sequences provided by illumina:
#Read 1: AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
#Read 2: AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
cutadapt --nextseq-trim=20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --minimum-length 100 \
-o P18452_129_S44_L001_R1_001_filtered.fastq.gz -p P18452_129_S44_L001_R2_001_filtered.fastq.gz \
P18452_129_S44_L001_R1_001.fastq.gz P18452_129_S44_L001_R2_001.fastq.gz

#Running fastQC again
fastqc P18452_129_S44_L001_R1_001_filtered.fastq.gz
fastqc P18452_129_S44_L001_R2_001_filtered.fastq.gz

#Transfer results back to job directory
echo [`date`] Receiving result file
cp P18452_129_S44_L001_R1_001_filtered.fastq.gz P18452_129_S44_L001_R2_001_filtered.fastq.gz *.html $jobDir
