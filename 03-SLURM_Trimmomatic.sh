#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 8	                            # number of cores   
#SBATCH -t 10:00:00                          # max running time
#SBATCH -J Trimmomatic_FastQC_119_L001_P1                    # job name
#SBATCH -o out/Trimmomatic_FastQC_119_L001_P1_%A.out          # standard output
#SBATCH -e err/Trimmomatic_FastQC_119_L001_P1_%A.err          # standard error
#SBATCH --mail-type=ALL                     # notify user of progresss
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load java bioinfo-tools trimmomatic/0.39 FastQC/0.11.9

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/Trimmomatic_FastQC_119_L001_P1_$SLURM_JOB_ID
jobDir=$projDir/jobs/Trimmomatic_FastQC_119_L001_P1_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#fastqc before
fastqc 119_L001_R1_ca.part_001.fastq.gz
fastqc 119_L001_R2_ca.part_001.fastq.gz

#Running trimmomatic
#java -jar <path to trimmomatic.jar> PE [-threads <threads] [-phred33 | -phred64] [-trimlog <logFile>] <input 1> <input 2> <paired output 1> <unpaired output 1> 
#<paired output 2> <unpaired output 2> <step 1> ...
java -jar $TRIMMOMATIC_ROOT/trimmomatic-0.39.jar PE -threads 8 -phred33 119_L001_R1_ca.part_001.fastq.gz 119_L001_R2_ca.part_001.fastq.gz \
119_L001_R1_trimmed_paired.part_001.fastq.gz 119_L001_R1_trimmed_unpaired.part_001.fastq.gz 119_L001_R2_trimmed_paired.part_001.fastq.gz 119_L001_R2_trimmed_unpaired.part_001.fastq.gz \
ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE-2.fa:2:3:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#running fastqc
fastqc 119_L001_R1_trimmed_paired.part_001.fastq.gz 
fastqc 119_L001_R1_trimmed_unpaired.part_001.fastq.gz 
fastqc 119_L001_R2_trimmed_paired.part_001.fastq.gz 
fastqc 119_L001_R2_trimmed_unpaired.part_001.fastq.gz 

#Transfer results back to job directory
echo [`date`] Receiving result file
cp 119_L001_R1_trimmed_paired.part_001.fastq.gz 119_L001_R1_trimmed_unpaired.part_001.fastq.gz 119_L001_R2_trimmed_paired.part_001.fastq.gz 119_L001_R2_trimmed_unpaired.part_001.fastq.gz *html $jobDir
