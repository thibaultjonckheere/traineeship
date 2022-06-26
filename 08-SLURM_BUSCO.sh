#!/bin/bash -l
 
#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 8                                # number of cores   
#SBATCH -t 4:00:00                          # max running time
#SBATCH -J BUSCO                         # job name
#SBATCH -o out/BUSCO_%A.out # standard output
#SBATCH -e err/BUSCO_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools BUSCO/5.3.1

#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/BUSCO_$SLURM_JOB_ID
jobDir=$projDir/jobs/BUSCO_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/*.fasta $SNIC_TMP
cd $SNIC_TMP

mkdir Busco

#Run job code
/sw/bioinfo/BUSCO/5.3.1/rackham/bin/run_BUSCO.py -f -i Trinity.fasta -l \
$BUSCO_LINEAGE_SETS/mollusca_odb10/ -o Busco -c 8 -m transcriptome

#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r $SNIC_TMP $jobDir
