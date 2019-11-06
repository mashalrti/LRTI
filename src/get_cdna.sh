cd /home/rstudio/disk/
mkdir ref_transcripts
wget -O /home/rstudio/disk/ref_transcripts/Hsap_cDNA.fa ' http://ensembl.org/biomart/martservice?query=<Query  virtualSchemaName = "default" formatter = "FASTA" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6" >
			
	<Dataset name = "hsapiens_gene_ensembl" interface = "default" >
		<Attribute name = "ensembl_gene_id" />
		<Attribute name = "ensembl_transcript_id" />
		<Attribute name = "external_gene_name" />
		<Attribute name = "cdna" />
	</Dataset>
</Query>' #telecharger URL dans fichier, suivant adresse récupéree dans Ensembl
