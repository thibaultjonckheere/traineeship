#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 12                                # number of cores   
#SBATCH -t 6:00:00                          # max running time
#SBATCH -J merged_normalization                         # job name
#SBATCH -o out/merged_normalization_%A.out # standard output
#SBATCH -e err/merged_normalization_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load java/sun_jdk1.7.0_25 bioinfo-tools bowtie/1.2.3 samtools/1.14 trinity/2014-07-17

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/merged_normalization_$SLURM_JOB_ID
jobDir=$projDir/jobs/merged_normalization_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#making an outputdir
mkdir trinity_out_dir/

#Run job code
# Trinity --seqType fq --max_memory 100G --left reads_1.fq  --right reads_2.fq --CPU 16
$TRINITY_HOME/util/insilico_read_normalization.pl --seqType fq --JM 100G --max_cov 50 \
--left R1_normalized_merged.fq --right R2_normalized_merged.fq \
--pairs_together --PARALLEL_STATS --CPU 12 --output trinity_out_dir/

#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r $SNIC_TMP  $jobDir
