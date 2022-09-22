
library(ggplot2, lib.loc ="/home/rx32940/Rlibs")
library(dplyr, lib.loc ="/home/rx32940/Rlibs")
# library(plotly,lib.loc ="/home/rx32940/Rlibs")

args <- commandArgs(trailingOnly = TRUE)
homo.path <- args[1] #"/scratch/rx32940/minION/homopolymer_cov/output"
homo.sub <- args[2] #"homoA"
print(homo.sub)

# homo.path <-"/scratch/rx32940/minION/homopolymer_cov/output"
# homo.sub <- "homoA"


files_drna <- list.files(file.path(homo.path, homo.sub), pattern = "*.relative.cov",full.names = TRUE)
files <- c(files_drna)

# file <- "/scratch/rx32940/minION/homopolymer_cov/output/homoA/Icterohaemorrhagiae_Basecalled_Aug_16_2019_Direct-cDNA_NoPolyATail.A3.relative.cov"
all_sample_homo_cov<- data.frame(fromHomePos=numeric(), avgCov= numeric(), SD=numeric(),sample=character(), platform = character(), polyAtail = character())
for(file in files){

  cur_file <- read.csv(file, sep="\t")
  
  sample <- unlist(strsplit(basename(file), split = ".", fixed = TRUE))[1] # get sample name
  print(sample)
  sample_name <- switch(
    sample,
    LIC_NOPOLYA = "LIC-dRNA-nonpolyA",
    LIC_POLYA_DRNA_CDNA = "LIC-dRNA-cDNA-polyA",
    LIC_POLYA = "LIC-dRNA-polyA",
    `Copenhageni_Basecalled_Aug_16_2019_Direct-cDNA_NoPolyATail_Qiagen` = "LIC-cDNA-nonpolyA_Q",
    `Copenhageni_Basecalled_Aug_16_2019_Direct-cDNA_NoPolyATail` = "LIC-cDNA-nonpolyA",
    `Copenhageni_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail` = "LIC-cDNA-polyA",
    `Icterohaemorrhagiae_Basecalled_Aug_16_2019_Direct-cDNA_NoPolyATail` = "LII-cDNA-nonpolyA",
    `Icterohaemorrhagiae_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail` = "LII-cDNA-polyA",
    `Mankarso_Basecalled_Aug_16_2019_Direct-cDNA_NoPolyATail` = "LIM-cDNA-nonpolyA",
    `Mankarso_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail` = "LIM-cDNA-polyA",
    `Patoc_Basecalled_Aug_16_2019_Direct-cDNA_NoPolyATail` = "LBP-cDNA-nonpolyA",
    `Patoc_Basecalled_Aug_16_2019_Direct-cDNA_PolyATail` = "LBP-cDNA-polyA",
    `Q29_Copenhageni_Basecalled_May_22_2020_Direct-RNA`="Q29-dRNA-nonpolyA-R1",
    `Q29_Copenhageni_Basecalled-June_11_2020_Repeat_Direct-RNA`="Q29-dRNA-nonpolyA-R2",
    `Q36_Copenhageni_Basecalled_June_9_2020-Repeat_Direct-RNA`="Q36-dRNA-nonpolyA-R2",
    `Q36_Copenhageni_Basecalled_May_31_2020_Direct-RNA`="Q36-dRNA-nonpolyA-R1"
  )
  
  # sequencing protocol, dRNA or cDNA
  platform <- unlist(strsplit(sample_name, split="-", fixed=TRUE))[2]
  
  # polyA tail added?
  polyAtail <- ifelse(unlist(strsplit(sample_name, split="-", fixed=TRUE))[3] == "nonpolyA", "nonpolyA", "polyA")
  
  # get the average cov across all transcripts mapped at the position flanking homopolymer region
  avg_pos_cov <- cur_file %>% group_by(fromHomePos) %>% summarise(avgCov = mean(relative_cov, na.rm=TRUE), SD=sd(relative_cov, na.rm=TRUE)) %>% mutate(sample=sample_name) %>% mutate(platform = platform, polyAtail = polyAtail)
  
  all_sample_homo_cov <- rbind(all_sample_homo_cov,avg_pos_cov)
}
# unique(all_sample_homo_cov$sample)

write.csv(all_sample_homo_cov, file.path(homo.path, paste0("combined_all_samples.",homo.sub,".csv")), quote = FALSE, row.names = FALSE)

# p <- ggplot(all_sample_homo_cov, aes(x=fromHomePos, y=avgCov))+
#   facet_wrap(~platform)+
#   geom_line(aes(color=sample))+
#   geom_errorbar(aes(ymin=avgCov-SD, ymax=avgCov+SD)) +
#   scale_x_continuous(breaks = seq(-100,100,25), limits = c(-100,100))+
#   labs(x="5'-3'position relative to > 5bp homo(A)", y="relative cov over maximum cov of each transcript")+
#   theme(text = element_text(size = 12))+
#   theme_bw()

# # ggplotly(p)
# ggsave("/Users/rx32940/Dropbox/5.Rachel-projects/Transcriptomics_PolyATail/manuscript/characterize/figures/IV.cov_flanking_homoA5.pdf",p,width = 7,height = 5)