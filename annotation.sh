# Annovar


apps/annovar/table_annovar.pl results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.vcf apps/annovar/humandb/ \
	-buildver hg19 -out results/annotated_vcf/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.annovar -remove \
	-protocol refGene,genomicSuperDups,esp6500si_all,esp6500si_ea,esp6500si_aa,1000g2014aug_all,1000g2014aug_afr,1000g2014aug_eur,snp132,snp138 -operation g,r,f,f,f,f,f,f,f,f -nastring NA -vcfinput

# SnpEff

java -Xmx4g -jar software/snpEff/snpEff.jar -c software/snpEff/snpEff.config -v hg19 data/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.vcf > results/snpEff/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.eff.vcf