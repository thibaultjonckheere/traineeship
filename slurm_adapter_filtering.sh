#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 1                                # number of cores   
#SBATCH -t 12:00:00                         # max running time
#SBATCH -J test_adapter_filtering           # job name
#SBATCH -o out/test_adapter_filtering%A.out # standard output
#SBATCH -e err/test_adapter_filtering%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools cutadapt/3.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/test6_adapter_filtering_$SLURM_JOB_ID
jobDir=$projDir/jobs/test6_adapter_filtering_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/test6 $SNIC_TMP
cd $SNIC_TMP

#Run job code
cutadapt -a TAACTTGGTC...GATTCACGAC -o test6_adapter_filtered.fastq.gz test6

#Transfer results back to job directory
echo [`date`] Receiving result file
cp test6_adapter_filtered.fastq.gz $jobDir