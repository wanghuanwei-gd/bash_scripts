Select Variants

java -Xmx2g -jar software/GenomeAnalysisTK.jar -R resources/ucsc.hg19.fasta -T SelectVariants --variant NIH-Schizophrenia/original_files/42010/PhenoGenotypeFiles/RootStudyConsentSet_phs000473.SchizophreniaSwedish_Sklar.v1.p1.c1.GRU/GenotypeFiles/scz-only-exome-all-nozeros-corrected-header.vcf -o NIH-Schizophrenia/scz_swedish_april16/scz_swedish_april16.vcf -L NIH-Schizophrenia/scz_swedish_april16/rare_genes_scz_only_ind_april16-2.bed


Annotation
   
software/annovar/table_annovar.pl NIH-Schizophrenia/scz_swedish_april16/scz_swedish_april16.vcf software/annovar/humandb/ -buildver hg19 -out NIH-Schizophrenia/scz_swedish_april16/scz_swedish_april16_annotated -remove -protocol refGene,esp6500siv2_all,esp6500siv2_ea,esp6500siv2_aa,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eur,exac02_ExAC,exac02_FIN,exac02_NFE,exac02_AMR,snp132 -operation g,f,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput