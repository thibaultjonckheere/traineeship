#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 16                                # number of cores   
#SBATCH -t 10:00:00                          # max running time
#SBATCH -J rnaSPAdes_138_L001                         # job name
#SBATCH -o out/rnaSPAdes_138_L001_%A.out # standard output
#SBATCH -e err/rnaSPAdes_138_L001_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools spades/3.15.3


#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/138_L001_rnaSPAdes_$SLURM_JOB_ID
jobDir=$projDir/jobs/138_L001_rnaSPAdes_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/138_L001*.fastq.gz $SNIC_TMP
cd $SNIC_TMP

#making an output dir for SPAdes
mkdir 138_L001_rnaSPAdes/

#Run job code
#rnaspades.py [options] -o <output_dir> 
#spades.py --rna
spades.py --rna -1 138_L001_R1_trimmed_paired.fastq.gz -2 138_L001_R2_trimmed_paired.fastq.gz \
--s1 138_L001_R1_trimmed_unpaired.fastq.gz --s2 138_L001_R2_trimmed_unpaired.fastq.gz \
-o 138_L001_rnaSPAdes/

#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r /scratch/$SLURM_JOB_ID/138_L001_rnaSPAdes/ $jobDir
