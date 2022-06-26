#!/usr/bin/python3
import pandas as pd
table1 = pd.read_csv("/home/guest/Downloads/M.Ejdeback_20_01_sample_information.tsv",delimiter="\t")

#print(table1.head())

#sorting the runs on highest quality scores
table1.sortedonQ30 = table1.sort_values(by=">=Q30(%)", ascending=False)
#print(table1.sortedonQ30.head())
#writing the table into a new file
table1.sortedonQ30.to_csv("/home/guest/Documents/FastQ/MultiQCorderedQ30.csv")


table1.sortedonMreads = table1.sort_values(by="Mreads", ascending=False)
#print(table1.sortedonMreads.head())
#writing the table into a new file
table1.sortedonMreads.to_csv("/home/guest/Documents/FastQ/MultiQCorderedMreads.csv")
