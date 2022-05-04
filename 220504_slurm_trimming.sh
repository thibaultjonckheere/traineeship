#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 1                                # number of cores   
#SBATCH -t 1:00:00                          # max running time
#SBATCH -J test_trimming                    # job name
#SBATCH -o out/test_trimming%A.out          # standard output
#SBATCH -e err/test_trimming%A.err          # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools '''trimmomatic/xx'''

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/test6_trimming_$SLURM_JOB_ID
jobDir=$projDir/jobs/test6_trimming_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp jobs/test6_adapter_filtered.fastq.gz'''ID''' $SNIC_TMP
cd $SNIC_TMP

#Run job code
java -jar <path to trimmomatic.jar> PE [-threads <threads] [-phred33 | -phred64] [-trimlog <logFile>] <input 1> <input 2> <paired output 1> <unpaired output 1> <paired output 2> <unpaired output 2> <step 1> ...

#Transfer results back to job directory
echo [`date`] Receiving result file
cp '''outputfile.fastq.gz''' $jobDir