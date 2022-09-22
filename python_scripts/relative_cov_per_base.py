import os
import pandas as pd
import sys

############################################
#
# get relative cov for bases flanking to homopolymers
# pandas required
# [tran_max_cov]: max coverage of each transcript
# [homopolymer_region_cov]: per base cov for regions 100bps flanking to homopolymers 
# [relative_cov_per_base]: output, relative cover with respect to the maximum cov position per transcript
#
# python trans_max_cov_pos.py [trans_max_cov] [homopolymer_region_cov] [relative_cov_per_base]
#
#############################################

# files with 1st column has transcript name, second column has the maximumn coverage (at a base) of the transcript
trans_max_cov = pd.read_csv(sys.argv[1], sep="\t", names=["transName","maxCov"], index_col=False)
# coverage 100bp +- a homopolymer (1: transcript name, 2: start, 3: end, 4: homopolymer region, 5: position, 6: coverage)
homo_cov= pd.read_csv(sys.argv[2], sep="\t", names=["transName", "start", "end", "homoRegion", "homoLen","basePos", "cov"], index_col=False)

merged_cov = homo_cov.merge(trans_max_cov, how="left",on="transName")

merged_cov["relative_cov"] = merged_cov["cov"]/merged_cov["maxCov"]

merged_cov["homoStart"] = merged_cov["homoRegion"].apply(lambda x: int(x. split(":")[0]))

merged_cov["homoEnd"] = merged_cov["homoRegion"].apply(lambda x: int(x. split(":")[1]))

merged_cov["basePos"] = merged_cov.apply(lambda x: int(x["basePos"]-1 + x["start"]), axis=1)

merged_cov['fromHomePos'] = merged_cov.apply(lambda x: (x['basePos']- x["homoStart"]) if x['basePos'] < x["homoStart"] else (0 if x["basePos"] >= x["homoStart"] and x["basePos"] <= x["homoEnd"] else x['basePos'] -x['homoEnd']),axis=1)

merged_cov.to_csv(sys.argv[3], index=False, header=True, sep="\t")

