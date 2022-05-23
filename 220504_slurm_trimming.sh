#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 8	                            # number of cores   
#SBATCH -t 10:00:00                          # max running time
#SBATCH -J Trimmomatic_FastQC_138_L001                    # job name
#SBATCH -o out/Trimmomatic_FastQC_138_L001_%A.out          # standard output
#SBATCH -e err/Trimmomatic_FastQC_138_L001_%A.err          # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load java bioinfo-tools trimmomatic/0.39 FastQC/0.11.9

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/Trimmomatic_FastQC_138_L001_$SLURM_JOB_ID
jobDir=$projDir/jobs/Trimmomatic_FastQC_138_L001_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/138_L001* $SNIC_TMP
cd $SNIC_TMP

#Running trimmomatic
#java -jar <path to trimmomatic.jar> PE [-threads <threads] [-phred33 | -phred64] [-trimlog <logFile>] <input 1> <input 2> <paired output 1> <unpaired output 1> 
#<paired output 2> <unpaired output 2> <step 1> ...
java -jar $TRIMMOMATIC_ROOT/trimmomatic-0.39.jar PE -threads 8 -phred33 138_L001_R1_ca.fastq.gz 138_L001_R2_ca.fastq.gz \
138_L001_R1_trimmed_paired.fastq.gz 138_L001_R1_trimmed_unpaired.fastq.gz 138_L001_R2_trimmed_paired.fastq.gz 138_L001_R2_trimmed_unpaired.fastq.gz \
ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE-2.fa:2:3:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#running fastqc
fastqc 138_L001_R1_trimmed_paired.fastq.gz 
fastqc 138_L001_R1_trimmed_unpaired.fastq.gz 
fastqc 138_L001_R2_trimmed_paired.fastq.gz 
fastqc 138_L001_R2_trimmed_unpaired.fastq.gz 

#Transfer results back to job directory
echo [`date`] Receiving result file
cp 138_L001_R1_trimmed_paired.fastq.gz 138_L001_R1_trimmed_unpaired.fastq.gz 138_L001_R2_trimmed_paired.fastq.gz 138_L001_R2_trimmed_unpaired.fastq.gz *html $jobDir
