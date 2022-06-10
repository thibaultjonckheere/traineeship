#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 16                                # number of cores   
#SBATCH -t 5:00:00                          # max running time
#SBATCH -J 119_L003_normalization                         # job name
#SBATCH -o out/119_L003_normalization_%A.out # standard output
#SBATCH -e err/119_L003_normalization_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load java/sun_jdk1.7.0_25 bioinfo-tools bowtie/1.2.3 samtools/1.14 trinity/2014-07-17

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/119_L003_normalization_$SLURM_JOB_ID
jobDir=$projDir/jobs/119_L003_normalization_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#Run job code
# Trinity --seqType fq --max_memory 100G --left reads_1.fq  --right reads_2.fq --CPU 16
$TRINITY_HOME/util/insilico_read_normalization.pl --seqType fq --JM 100G --max_cov 30\
--left 119_L001_R1_trimmed_paired.fastq.gz --right 119_L001_R2_trimmed_paired.fastq.gz \
--pairs_together --PARALLEL_STATS --CPU 16

#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r trinity_out_dir/ $jobDir
