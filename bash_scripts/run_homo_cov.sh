#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=get_nuc5_cov_cDNA
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=1           
#SBATCH --time=100:00:00
#SBATCH --mem=50G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

MAIN="/scratch/rx32940/minION/homopolymer_cov"
REF="/scratch/rx32940/minION/polyA_cDNA/map/transcriptome/reference/"

##########################################################
#
# get regions in reference transcriptome with homopolymers
# this script will return the region +- 100 from the homopolymer region
# if the exceed region of transcript, then the begining and end of transcript position will be used
# the 4th column has the exact region of the homopolymer
# the 5th column has the length of the homopolymer
#
#########################################################

# ml Biopython/1.78-intel-2020b
# # arg1: nucleotide to find, arg2: min length of the homopolymers, arg3: input reference fasta, arg4: output bed file
# for nuc in A T C G;
# do
# python $MAIN/get_homo_coord.py $nuc 5 $REF/GCF_000007685.1_ASM768v1_cds_from_genomic.fna $MAIN/bed/GCF_000007685.1_ASM768v1_cds_homo${nuc}_5.bed

# python $MAIN/get_homo_coord.py $nuc 5 $REF/GCF_000017685.1_ASM1768v1_cds_from_genomic.fna $MAIN/bed/GCF_000017685.1_ASM1768v1_cds_homo${nuc}_5.bed

# python $MAIN/get_homo_coord.py $nuc 5 $REF/GCF_014858895.1_ASM1485889v1_cds_from_genomic.fna $MAIN/bed/GCF_014858895.1_ASM1485889v1_cds_homo${nuc}_5.bed

# done

##########################################################
#
# get coverage from every base around homopolymer region
#
#########################################################

# source activate tu_annotation

# BAM="/scratch/rx32940/minION/polyA_directRNA/map/transcriptome/bam"
# OUT="/scratch/rx32940/minION/homopolymer_cov/output"
# lower_limit=5 # at least how many nucleotide to count as homopolymer

# ml BEDTools/2.30.0-GCC-8.3.0

# mkdir -p $OUT/overall_trans_cov

# # # convert cds_from_genomic.fna file to bed, so coverage output across each transcript can be consistenet with homopolymer cov output
# # python $MAIN/reference/cds_to_bed.py $REF/GCF_000007685.1_ASM768v1_cds_from_genomic.fna $MAIN/reference/GCF_000007685.1_ASM768v1_cds.bed
# # python $MAIN/reference/cds_to_bed.py $REF/GCF_000017685.1_ASM1768v1_cds_from_genomic.fna $MAIN/reference/GCF_000017685.1_ASM1768v1_cds.bed
# # python $MAIN/reference/cds_to_bed.py $REF/GCF_014858895.1_ASM1485889v1_cds_from_genomic.fna $MAIN/reference/GCF_014858895.1_ASM1485889v1_cds.bed

# for HOMO in A T C G;
# do
#     mkdir -p $OUT/nuc_$lower_limit/homo$HOMO/
#     for file in $BAM/*sorted.bam;
#     do
#     sample=$(basename $file ".sorted.bam")
#     echo $sample

#     # # get overall coverage for each transcript
#     bedtools coverage -a $MAIN/reference/GCF_000007685.1_ASM768v1_cds.bed -b $file -d > $OUT/overall_trans_cov/$sample.cov

#     # # get max cov from each transcript
#     python trans_max_cov_pos.py $OUT/overall_trans_cov/$sample.cov $OUT/overall_trans_cov/$sample.max.cov

#     # # get coverage around each homopolymer region
#     bedtools coverage -a $MAIN/bed/GCF_000007685.1_ASM768v1_cds_homo${HOMO}_$lower_limit.bed -b $file -d > $OUT/nuc_$lower_limit/homo$HOMO/$sample.$HOMO$lower_limit.cov

#     # # get relative cov within the flanking regions of homopolymer by divide each base' cov with the max cov of the transcript
#     python relative_cov_per_base.py $OUT/overall_trans_cov/$sample.max.cov $OUT/nuc_$lower_limit/homo$HOMO/$sample.$HOMO$lower_limit.cov $OUT/nuc_$lower_limit/homo$HOMO/$sample.$HOMO$lower_limit.relative.cov

#     done
# done

######## cDNA #################################
# source activate tu_annotation

# BAM="/scratch/rx32940/minION/polyA_cDNA/map/transcriptome/bam"
# OUT="/scratch/rx32940/minION/homopolymer_cov/output"
# lower_limit=5 # at least how many nucleotide to count as homopolymer

# # ml BEDTools/2.30.0-GCC-8.3.0

# mkdir -p $OUT/overall_trans_cov

# for HOMO in A T C G;
# do
#     mkdir -p $OUT/nuc_$lower_limit/homo$HOMO/
#     for file in $BAM/*sorted.bam;
#     do
#     sample=$(basename $file ".sorted.bam")
#     echo $sample

#     if [[ $sample == Copen* ]]
#     then
#         REF="GCF_000007685.1_ASM768v1_cds";
#     elif [[ $sample == Man* ]] || [[ $sample == Icter* ]]
#     then
#         REF="GCF_014858895.1_ASM1485889v1_cds"
#     elif [[ $sample == Pa* ]] 
#     then
#         REF="GCF_000017685.1_ASM1768v1_cds"
#     else
#         REF=""
#     fi

#     echo $REF
#     # # get overall coverage for each transcript
#     bedtools coverage -a $MAIN/reference/$REF.bed -b $file -d > $OUT/overall_trans_cov/$sample.cov

#     # # get max cov from each transcript
#     python trans_max_cov_pos.py $OUT/overall_trans_cov/$sample.cov $OUT/overall_trans_cov/$sample.max.cov

#     # get coverage around each homopolymer region
#     bedtools coverage -a $MAIN/bed/${REF}_homo${HOMO}_$lower_limit.bed -b $file -d > $OUT/nuc_$lower_limit/homo$HOMO/$sample.$HOMO$lower_limit.cov

#     # # get relative cov within the flanking regions of homopolymer by divide each base' cov with the max cov of the transcript
#     python relative_cov_per_base.py $OUT/overall_trans_cov/$sample.max.cov $OUT/nuc_$lower_limit/homo$HOMO/$sample.$HOMO$lower_limit.cov $OUT/nuc_$lower_limit/homo$HOMO/$sample.$HOMO$lower_limit.relative.cov

#     done
# done

##########################################################
#
# plot relative expression
#
#########################################################

ml R/4.1.3-foss-2020b

main_path="/scratch/rx32940/minION/homopolymer_cov/output/nuc_5"

for file in $main_path/homo*;
do
nuc=$(basename $file)

Rscript homo_plot.r $main_path $nuc

done