#!/usr/bin/python3
import pandas as pd

tablep = pd.read_csv("/home/guest/Documents/Analysis/annotation_merged/09-annotation/swissprot.blastp.outfmt6",delimiter="\t",header=None)
#print(tablep.head())
tablex = pd.read_csv("/home/guest/Documents/Analysis/annotation_merged/09-annotation/swissprot.blastx.outfmt6",delimiter="\t",header=None)
#print(tablex.head())

IDblastP = tablep[[1]]
#print(IDblastP.head())
IDblastX = tablex[[1]]
#print(IDblastX.head())
IDcombo = [IDblastP, IDblastX]
merged = pd.concat(IDcombo, ignore_index=True, sort=False)
#print(merged.head())

merged.to_csv("/home/guest/Documents/Analysis/annotation_merged/09-annotation/IDblastcombo.csv",header=None)