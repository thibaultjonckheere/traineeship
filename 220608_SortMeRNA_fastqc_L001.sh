#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 16                                # number of cores   
#SBATCH -t 10:00:00                          # max running time
#SBATCH -J fastQC_SortMeRNA_fastQC_119_L003     # job name
#SBATCH -o out/fastQC_SortMeRNA_fastQC_119_L003_%A.out # standard output
#SBATCH -e err/fastQC_SortMeRNA_fastQC_119_L003_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools FastQC/0.11.9 SortMeRNA/2.1b

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/fastQC_SortMeRNA_fastQC_119_L001_$SLURM_JOB_ID
jobDir=$projDir/jobs/fastQC_SortMeRNA_fastQC_119_L001_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/P18452_119_S38* $SNIC_TMP
cd $SNIC_TMP

#Running fastQC
fastqc P18452_119_S38_L001_R1_001.fastq.gz
fastqc P18452_119_S38_L001_R2_001.fastq.gz

#gunzip fastq files
#gunzip P18452_119_S38_L001_R1_001.fastq.gz
#gunzip P18452_119_S38_L001_R2_001.fastq.gz

#merge the reads
/sw/bioinfo/SortMeRNA/2.1b/rackham/scripts/merge-paired-reads.sh \
P18452_119_S38_L001_R1_001.fastq.gz P18452_119_S38_L001_R2_001.fastq.gz \
reads_interleaved.fq.gz

#Run sortmeRNA
sortmerna --ref \
$SORTMERNA_DBS/rRNA_databases/rfam-5.8s-database-id98.fasta,$SORTMERNA_DBS/index/rfam-5.8s-database-id98:\
$SORTMERNA_DBS/rRNA_databases/rfam-5s-database-id98.fasta,$SORTMERNA_DBS/index/rfam-5s-database-id98:\
$SORTMERNA_DBS/rRNA_databases/silva-arc-16s-id95.fasta,$SORTMERNA_DBS/index/silva-arc-16s-id95:\
$SORTMERNA_DBS/rRNA_databases/silva-arc-23s-id98.fasta,$SORTMERNA_DBS/index/silva-arc-23s-id98:\
$SORTMERNA_DBS/rRNA_databases/silva-bac-16s-id90.fasta,$SORTMERNA_DBS/index/silva-bac-16s-id90:\
$SORTMERNA_DBS/rRNA_databases/silva-bac-23s-id98.fasta,$SORTMERNA_DBS/index/silva-bac-23s-id98:\
$SORTMERNA_DBS/rRNA_databases/silva-euk-18s-id95.fasta,$SORTMERNA_DBS/index/silva-euk-18s-id95:\
$SORTMERNA_DBS/rRNA_databases/silva-euk-28s-id98.fasta,$SORTMERNA_DBS/index/silva-euk-28s-id98 \
--reads ./reads_interleaved.fq.gz --num_alignments 1 \
--fastx --aligned reads_rRNA.fq.gz --other reads_non_rRNA.fq.gz --log -a 16 -m 64000 --paired_in -v

#unmerging filtered file 
/sw/bioinfo/SortMeRNA/2.1b/rackham/scripts/unmerge-paired-reads.sh \
reads_non_rRNA.fq.gz reads_119_L001_non_rRNA_1.fq.gz reads_119_L001_non_rRNA_2.fq.gz

#gzip files again
#gzip reads_119_L001_non_rRNA_1.fq
#gzip reads_119_L001_non_rRNA_2.fq

#Running fastQC again
fastqc reads_119_L001_non_rRNA_1.fq.gz
fastqc reads_119_L001_non_rRNA_2.fq.gz

#Transfer results back to job directory
echo [`date`] Receiving result file
cp reads_119_L001_non_rRNA_1.fq.gz reads_119_L001_non_rRNA_2.fq.gz *html $jobDir
