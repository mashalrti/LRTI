# Libraries:
library("tximport")
library("readr")
library(apeglm)
library("DESeq2", quietly = T)

# Location of the data:
dir <- "/home/rstudio/disk/salmon_quant"


# Import the data:
condition <- read.delim("~/disk/condition.csv")
samples <- data.frame(run=condition$Run, type=condition$subject_group, sex=condition$gender, time=condition$time_point, patient=condition$subject_id)
samples$run = c("SRR3308956paired_quant", "SRR3308957paired_quant", "SRR3308972paired_quant",
                "SRR3308974paired_quant", "SRR3308975paired_quant", "SRR3308975paired_quant") # Je change les lignes pour correspondre aux noms de mes dossiers
files <- file.path(dir, samples$run, "quant.sf") # On va chercher le fichier avec la quantification
names(files) <- samples$run

# On fait le lien entre nom de gène et numéro de transcrit :
#(Les noms ne sont pas explicites car le code est adapté depuis le projet poisson clown)
tx2gene <- as.character(read.table(files[1], header = T,sep = "\t")$Name)
trinity.genes <- unlist(lapply(lapply(strsplit(x = tx2gene,split = "|",fixed=T), FUN = `[`,1), paste,collapse="_"))
trinity.trans <- unlist(lapply(lapply(strsplit(x = tx2gene,split = "|",fixed=T), FUN = `[`,1:3), paste,collapse="|"))
tx2gene <- data.frame(txname=trinity.trans, geneid=trinity.genes)

# On fait l'importation en utilisant tximport :
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

# On affiche la table de comptes avec :
txi$counts

# Et on construit un 'DESeqDataSet' à partir de txi en utilisant les noms contenus dans samples
ddsTxi <- DESeqDataSetFromTximport(txi, colData = samples, design = ~ time)

# On fait l'analyse différentielle :
ddsTxi = DESeq(ddsTxi)
res = results(ddsTxi)
summary(res)

# Maintenant on shrink, comme conseillé dans le papier DESeq2. On regarde les plus grands fold changes pour les gènes avec bcp d'information
#statistique (changer de 1000 à 5000 n'est pas pareil que de changer de 1 à 5. Les petites différences peuvent etre dues à du bruit de fond)
# Ici je compare avec et sans shrinkage
resLFC <- lfcShrink(ddsTxi, coef="time_before.bevacizumab.combination.treatment_vs_after.bevacizumab.combination.treatment", type="apeglm")
resLFC
summary(resLFC)
# Je plotte les données shrinkées et non shrinkées :
plotMA(resLFC) #ou
plotMA(ddsTxi)


# Maintenant je classe par p value les résultats :
resOrdered <- res[order(res$pvalue),]
head(resOrdered)

# Et je me demande combien j'ai d'échantillons avec p-value < 0.1 :
sum(res$padj < 0.1, na.rm=TRUE)

# Maintenant je vais faire une PCA pour visualiser quels facteurs sont responsables des différences observées :
# VST est un algo de stabilisation de la variance (normalisation par rapport à la taille de la bibliothèque)
# blind = TRUE par défaut, mais cette option attribuerait bcp de différences 'vraies' à du bruit ; le tuto propose de définir blind = FALSE
vsd <- vst(ddsTxi, blind=FALSE)
head(assay(vsd), 3)

# Et je plotte la PCA :
plotPCA(vsd, intgroup=c("time"), returnData = TRUE) # D'abord je regarde seulement la condition (avant/ après traitement). La condition n'a pas l'air de distinguer les échantillons.
plotPCA(vsd, intgroup=c("time", "sex")) # Je prends en compte la condition (avant/ après traitement) et le sexe

# Je retourne à mon analyse
# J'aimerais faire une Independent Hypothesis Weighing
# L'IHW fait de multiples tests, en utilisant la covariable qui est indicative de la puissance du test
# Il faut d'abord installer IHW:
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("IHW")
#library('IHW')
# Mais en fait c'est très long à installer et ça fait planter toute ma session donc tant pis...

# A la place de faire l'analyse statistique poussée, je vais représenter les data d'une autre façon, en utilisant une heatmap :
sampleDists <- dist(t(assay(vsd)))

library("RColorBrewer")
library(pheatmap)
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(vsd$time, vsd$type, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)
# On voit que les échantillons après traitement clusterisent ensemble, mais un des échantillons avant et plus proche des
#after que des before. Donc même si nous avons trouvé beaucoup de gènes différentiellement exprimés (cf analyses sur l'ensemble
#des échantillons), ici on ne voit pas de différence claire entre les répondeurs avant et après traitement.