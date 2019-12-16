# Libraries:
library("tximport")
library("readr")
library(apeglm)
library("DESeq2", quietly = T)

# Location of the data:
dir <- "/home/rstudio/disk/salmon_quant" # Ici mettre le dossier dans lequel vous travaillez


# Import the data:
#condition <- read.table("condition.csv", header = T) ### Donner la table des métadata
condition <- read.delim("~/disk/condition.csv")
samples <- data.frame(run=condition$Run, type=condition$subject_group, sex=condition$gender, time=condition$time_point, patient=condition$subject_id)
#files <- file.path(dir, "salmon", samples$run, "quant.sf")
samples$run = c("SRR3308956paired_quant", "SRR3308957paired_quant", "SRR3308972paired_quant", "SRR3308973paired_quant",
                "SRR3308974paired_quant", "SRR3308975paired_quant") # Je change les lignes pour correspondre aux noms de mes dossiers
files <- file.path(dir, samples$run, "quant.sf") # On va chercher le fichier avec la quantification
names(files) <- samples$run

# On fait le lien entre nom de gène et numéro de transcrit
tx2gene <- as.character(read.table(files[1], header = T,sep = "\t")$Name)
trinity.genes <- unlist(lapply(lapply(strsplit(x = tx2gene,split = "|",fixed=T), FUN = `[`,1), paste,collapse="_"))
trinity.trans <- unlist(lapply(lapply(strsplit(x = tx2gene,split = "|",fixed=T), FUN = `[`,1:3), paste,collapse="|"))
tx2gene <- data.frame(txname=trinity.trans, geneid=trinity.genes)

txi <- tximport(files, type="salmon", tx2gene=tx2gene)

# On affiche la table de compte avec :
txi$counts

# Et on construit un 'DESeqDataSet' à partir de txi en utilisant les noms contenus dans samples
ddsTxi <- DESeqDataSetFromTximport(txi, colData = samples, design = ~ time)