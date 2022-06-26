# traineeship
repository for scripts made during traineeship at HIS

The purpose of the traineeship was to perform a de novo transcriptome assembly and annotation of the mussel species Anodonta anatina. The different processing steps for the data were carried out on rackham, a server part of the Swedish National Infrastructure for Computing. On the server, various bioinformatic tools are available. To perform tasks you need to construct a shell script so that SLURM, a linux scheduler, can then queue your job and subtract the used resources from your project account. The scripts are numbered according to the order they were performed in. Within the scripts, file names are hard coded.

This is the workflow used:
![image](https://user-images.githubusercontent.com/95277279/175832747-b14ce9df-8ae1-4fe8-9353-bdbba2bd1596.png)
So step 1,2,3 and 4 were run parallel for a number of samples. Between 04 and 05 the different samples were merged and after 05, the different steps  were performed on the merged dataset.
