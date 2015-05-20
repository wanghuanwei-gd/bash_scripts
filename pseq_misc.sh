java -Xmx2g -jar software/GenomeAnalysisTK.jar -R resources/ucsc.hg19.fasta -T SelectVariants --variant NIH-Schizophrenia/42010/PhenoGenotypeFiles/RootStudyConsentSet_phs000473.SchizophreniaSwedish_Sklar.v1.p1.c1.GRU/GenotypeFiles/scz-only-exome-all-nozeros-corrected-header.vcf -o NIH-Schizophrenia/scz_swedish_subset.vcf -L NIH-Schizophrenia/rare_genes_april7.bed 

software/annovar/table_annovar.pl NIH-Schizophrenia/scz_swedish_subset.vcf software/annovar/humandb/ -buildver hg19 -out NIH-Schizophrenia/scz_swedish_april7 -remove -protocol refGene,esp6500siv2_all,esp6500siv2_ea,esp6500siv2_aa,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eur,exac02_ExAC,exac02_FIN,exac02_NFE,exac02_AMR,snp132 -operation g,f,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput


pseq scz-swedish-april7 assoc --phenotype scz --mask loc.group=refseq mac=1-100 meta.req='1000g2014oct_all':lt:0.01 include="ExonicFunc.refGene == 'stopgain' ||  ExonicFunc.refGene == 'stoploss' || ExonicFunc.refGene == 'frameshift_deletion' || ExonicFunc.refGene == 'frameshift_insertion' || ExonicFunc.refGene == 'nonsynonymous_SNV'" --tests burden uniq vt calpha sumstat > assoc_tests/assoc_tests_mac100_le1.txt &

pseq scz-swedish-april7 assoc --phenotype scz --mask loc.group=refseq mac=1-100 meta.req='1000g2014oct_all':ge:0.01,'1000g2014oct_all':le:0.05 include="ExonicFunc.refGene == 'stopgain' ||  ExonicFunc.refGene == 'stoploss' || ExonicFunc.refGene == 'frameshift_deletion' || ExonicFunc.refGene == 'frameshift_insertion' || ExonicFunc.refGene == 'nonsynonymous_SNV'" --tests burden uniq vt calpha sumstat > assoc_tests/assoc_tests_mac100_gt1_le5.txt &

pseq scz-swedish-april7 assoc --phenotype scz --mask loc.group=refseq mac=1-100 meta.req='1000g2014oct_all':le:0.05 include="ExonicFunc.refGene == 'stopgain' ||  ExonicFunc.refGene == 'stoploss' || ExonicFunc.refGene == 'frameshift_deletion' || ExonicFunc.refGene == 'frameshift_insertion' || ExonicFunc.refGene == 'nonsynonymous_SNV'" --tests burden uniq vt calpha sumstat > assoc_tests/assoc_tests_mac100_le5.txt &






pseq scz-swedish-april16 assoc --phenotype scz --mask loc.group=refseq mac=1-100 meta.req='1000g2014oct_all':le:0.01 include="ExonicFunc.refGene == 'stopgain' ||  ExonicFunc.refGene == 'stoploss' || ExonicFunc.refGene == 'frameshift_deletion' || ExonicFunc.refGene == 'frameshift_insertion' || ExonicFunc.refGene == 'nonsynonymous_SNV'" --tests burden vt uniq calpha sumstat > assoc_tests/april16_assoc_mac100_le1.txt &
