java -Xmx2g -jar software/GenomeAnalysisTK.jar -R genome/hg19.fa -T CombineVariants --variant results/family_call/merged_vcf_fam_call_UCSC/45-1040_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/32-32213_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/70-1179_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/53-108_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/56-195_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/30-30142_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/71-5077_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/30-30134_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/70-1096_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/70-1120_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/31-31114_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/31-31115_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/70-1088_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/31-31119_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/44-1053_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/30-30117_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/30-30136_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/30-30135_fam_call_recal_filt.vcf --variant results/family_call/merged_vcf_fam_call_UCSC/49-1002_fam_call_recal_filt.vcf -o merged_vcf_gatk_fam_call_UCSC_target.vcf -genotypeMergeOptions UNIQUIFY