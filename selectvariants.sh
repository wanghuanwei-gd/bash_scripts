# GATK SelectVariants

java -Xmx50g -jar software/GenomeAnalysisTK.jar \
   -nt 8 \
   -R resources/ucsc.hg19.fasta \
   -T SelectVariants \
   --variant NIH-Schizophrenia/42010/PhenoGenotypeFiles/RootStudyConsentSet_phs000473.SchizophreniaSwedish_Sklar.v1.p1.c1.GRU/GenotypeFiles/scz-only-exome-all-nozeros-corrected-header.vcf \
   -o NIH-Schizophrenia/scz-only-exome-all-nozeros_interval_rare_genes.vcf \
   -L resources/interval_rare_genes_scz.bed


# VCFtools subesting based on interval file

software/vcftools_0.1.12a/bin/vcftools --vcf NIH-Schizophrenia/42010/PhenoGenotypeFiles/RootStudyConsentSet_phs000473.SchizophreniaSwedish_Sklar.v1.p1.c1.GRU/GenotypeFiles/scz-only-exome-all-nozeros-corrected-header.vcf --bed resources/interval_rare_genes_scz.bed --out NIH-Schizophrenia/scz-only-exome-all-nozeros-corrected-header-SUBSET-vcftools.vcf --recode --keep-INFO-all