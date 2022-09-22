#!/bin/sh
#SBATCH --partition=gpu_p
#SBATCH --job-name=rebasecall_notrim
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=100:00:00
#SBATCH --mem=10G
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.out
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL


# #############################################################################
#
# demultiplex 
#    
# ##################################################################################

# TOOL="/scratch/rx32940/minION/Guppy/demultiplex/ont_fast5_api/ont_fast5_api/conversion_tools"
# fast5_path="/scratch/rx32940/minION/Guppy/PolyA_cDNA_FAST5_Pass/workspace"
# debarcode="/scratch/rx32940/minION/Guppy/PolyA_cDNA_demultiplex_FAST5_Pass"
# out="/scratch/rx32940/minION/Guppy/demultiplex/output"

# python $TOOL/demux_fast5.py -t 8 -i $fast5_path -s $out -l $debarcode/barcoding_summary.txt

# #############################################################################
#
# rebasecalling raw fast5 files for cDNA samples to perform MINIONQC and tailfindr
#    
# ##################################################################################

ml ont-guppy/4.4.2-GPU

input="/scratch/rx32940/minION/Guppy/PolyA_cDNA_FAST5_Pass/demultiplex"
output="/scratch/rx32940/minION/Guppy/PolyA_cDNA_FAST5_Pass/demultiplex/rebasecallNoTrim"

for dir in $input/output/*;
do

sample=$(basename $dir)

mkdir -p $output/$sample

guppy_basecaller -x "cuda:0" --compress_fastq --input_path $dir --save_path $output/$sample --config dna_r9.4.1_450bps_hac.cfg --fast5_out –cpu_threads_per_caller 5 --num_callers 1 --trim_strategy 'none' 

done