import sys
import argparse
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("file_snpEff")
parser.add_argument("file_annovar")
args = parser.parse_args()

df1 =pd.read_csv(args.file_snpEff, sep="\t")
df2 = pd.read_csv(args.file_annovar, sep="\t")
df_merge = df1.merge(df2, left_on=["CHROM", "POS", "REF", "ALT"], right_on=["Otherinfo4", "Otherinfo5", "Otherinfo7", "Otherinfo8"])
df_merge.to_csv(sys.stdout, sep="\t", index=None)
