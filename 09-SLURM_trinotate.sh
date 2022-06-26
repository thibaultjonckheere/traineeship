#!/bin/bash -l

#SBATCH -A snic2022-22-434                  # project ID = snic2022-22-434
#SBATCH -p core                             # core or node
#SBATCH -n 16                                # number of cores   
#SBATCH -t 24:00:00                          # max running time
#SBATCH -J trinotate_merged                         # job name
#SBATCH -o out/trinotate_merged_%A.out # standard output
#SBATCH -e err/trinotate_merged_%A.err # standard error
#SBATCH --mail-type=ALL                     # notify user of progress
#SBATCH --mail-user=thibault.jonckheere@student.howest.be

#load modules
module load bioinfo-tools trinotate/3.2.2


#$TRINOTATE_HOME


#Create job directory
echo [`date`] Creating job directory
projDir=`pwd`
mkdir -p jobs/trinotate_merged_$SLURM_JOB_ID
jobDir=$projDir/jobs/trinotate_merged_$SLURM_JOB_ID/

#Transfer data to compute node disk
echo [`date`] Transferring data
cp data/* $SNIC_TMP
cd $SNIC_TMP

#Run job code ($TRINOTATE_HOME: /sw/bioinfo/trinotate/3.2.2/rackham)
##############################################################################
#
# Required:
#
#  --Trinotate_sqlite <string>                Trinotate.sqlite boilerplate database
#
#  --transcripts <string>                     transcripts.fasta
#
#  --gene_to_trans_map <string>               gene-to-transcript mapping file
#
#  --conf <string>                            config file
#
#  --CPU <int>                                number of threads to use.
#
#
##############################################################################
$TRINOTATE_HOME/auto/autoTrinotate.pl --Trinotate_sqlite ./Trinotate.sqlite \
--transcripts ./Trinity.fasta \
--gene_to_trans_map ./Trinity.fasta.gene_trans_map --conf ./conf.txt --CPU 16



#Transfer results back to job directory
echo [`date`] Receiving result file
cp -r $SNIC_TMP $jobDir
