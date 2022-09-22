#!/bin/sh
#SBATCH --partition=batch
#SBATCH --job-name=minimap2_Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --time=100:00:00
#SBATCH --mem=10G
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.out
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL
 ml minimap2/2.17-GCC-8.3.0
 ml SAMtools/1.10-GCC-8.3.0
 ml BEDTools/2.30.0-GCC-8.3.0
 mkdir -p /scratch/rx32940/minION/polyA_cDNA/map_full/bam /scratch/rx32940/minION/polyA_cDNA/map_full/sam /scratch/rx32940/minION/polyA_cDNA/map_full/bed


    minimap2 -ax splice -k14 -p 0.99 --MD /scratch/rx32940/minION/polyA_cDNA/map_full/reference/GCF_000017685.1_ASM1768v1_genomic.fna /scratch/rx32940/minION/polyA_cDNA/pychopper/output/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.final.fastq > /scratch/rx32940/minION/polyA_cDNA/map_full/sam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.sam

    samclip --ref /scratch/rx32940/minION/polyA_cDNA/map_full/reference/GCF_000017685.1_ASM1768v1_genomic.fna < /scratch/rx32940/minION/polyA_cDNA/map_full/sam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.sam --max 10 > /scratch/rx32940/minION/polyA_cDNA/map_full/sam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.noClip.sam

    samtools view -bS /scratch/rx32940/minION/polyA_cDNA/map_full/sam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.noClip.sam > /scratch/rx32940/minION/polyA_cDNA/map_full/bam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.bam 

    samtools view -@ 3 -bS /scratch/rx32940/minION/polyA_cDNA/map_full/sam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.noClip.sam | samtools sort - -@ 3 -o /scratch/rx32940/minION/polyA_cDNA/map_full/bam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.sorted.bam
 
    samtools index /scratch/rx32940/minION/polyA_cDNA/map_full/bam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.sorted.bam 

    bedtools bamtobed -i /scratch/rx32940/minION/polyA_cDNA/map_full/bam/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.sorted.bam -cigar > /scratch/rx32940/minION/polyA_cDNA/map_full/bed/Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail.bed

    
