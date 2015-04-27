# Annovar

# Annovar


software/annovar/table_annovar.pl alzheimer/results/vcf/annotated_vcf/ad_b2.ug.vcf.snp.indel.recal.filt.snpeff.vcf software/annovar/humandb/ \
	-buildver hg19 -out alzheimer/results/vcf/annotated_vcf/ad_b2.ug.vcf.snp.indel.recal.filt.snpeff -remove \
	-protocol refGene,esp6500siv2_all,esp6500siv2_ea,esp6500siv2_aa,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eur,exac02,snp132 -operation g,f,f,f,f,f,f,f,f -nastring . -vcfinput

software/annovar/table_annovar.pl results/vcf/annotated_vcf/ad_b1.ug.vcf.snp.indel.recal.filt.snpeff.vcf software/annovar/humandb/ \
	-buildver hg19 -out results/vcf/annotated_vcf/ad_b1.ug.vcf.snp.indel.recal.filt.snpeff -remove \
	-protocol refGene,esp6500siv2_all,esp6500siv2_ea,esp6500siv2_aa,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eur,snp132 -operation g,f,f,f,f,f,f,f -nastring . -vcfinput

# SnpEff

java -Xmx4g -jar software/snpEff/snpEff.jar -c software/snpEff/snpEff.config -v hg19 -o gatk alzheimer/results/vcf/variant_recal/snp_indel/ad_b2_ug.vcf.snp.indel.recal.filt.vcf > alzheimer/results/vcf/annotated_vcf/ad_b2.ug.vcf.snp.indel.recal.filt.snpeff.vcf

java -Xmx4g -jar software/snpEff-2/snpEff.jar -c software/snpEff-2/snpEff.config -v hg19 -o gatk results/vcf/variant_recalibration/snp_indel/ad.ug.vcf.snp.indel.recal.filt.vcf > results/vcf/annotated_vcf/ad_b1.ug.vcf.snp.indel.recal.filt.snpeff.vcf

software/annovar/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac02 software/annovar/humandb/


software/annovar/table_annovar.pl NIH-Schizophrenia/scz_intersecting_intervals_gatk.vcf software/annovar/humandb/ \
	-buildver hg19 -out NIH-Schizophrenia/scz_intersecting_intervals_sub_gatk.vcf -remove \
	-protocol refGene,esp6500siv2_all,esp6500siv2_ea,esp6500siv2_aa,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eur,exac02_ExAC,exac02_FIN,exac02_NFE,exac02_AMR,snp132 -operation g,f,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput
