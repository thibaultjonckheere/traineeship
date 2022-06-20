#!/usr/bin/python3
import pandas as pd

table = pd.read_csv("/home/guest/Documents/Analysis/annotation_merged/09-annotation/swissprot.blastp.outfmt6",delimiter="\t",header=None)

#print(table.head())

IDblastP = table[[1]]

IDblastP.to_csv("/home/guest/Documents/Analysis/annotation_merged/09-annotation/IDblastP.csv",header=None)