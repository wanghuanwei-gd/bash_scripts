head -132 merged_vcf_gatk_fam_call_UCSC_target.vcf > merged_vcf_gatk_fam_call_UCSC_target_corrected.vcf
cat merged_vcf_gatk_fam_call_UCSC_target.vcf | grep -v ^# | sed 's/^/chr/' >> merged_vcf_gatk_fam_call_UCSC_target_corrected.vcf


 # VariantRecalibrator - SNPs

java -Xmx4g -jar /share/apps/gatk-3.2.2/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/ucsc.hg19.fasta \
   -input data/merged_vcf_gatk_fam_call_UCSC_target_corrected.vcf \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources/hapmap_3.3.hg19.sites.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 resources/1000G_omni2.5.hg19.sites.vcf \
   -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 resources/dbsnp_138.hg19.vcf \
   -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode SNP \
   -recalFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.snp.recal \
   -tranchesFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.snp.tranches \
   -rscriptFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.snp.plots.R
   
# ApplyRecalibration - SNPs
 
java -Xmx3g -jar /share/apps/gatk-3.2.2/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/ucsc.hg19.fasta \
   -input data/merged_vcf_gatk_fam_call_UCSC_target_corrected.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.snp.tranches \
   -recalFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.snp.recal \
   -mode SNP \
   -o results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.corrected.snp.recalibrated.filtered.vcf 
 
   
 # VariantRecalibrator - INDELS 

   
java -Xmx4g -jar /share/apps/gatk-3.2.2/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/ucsc.hg19.fasta \
   -input results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.corrected.snp.recalibrated.filtered.vcf \
   -resource:mills,known=false,training=true,truth=true,prior=15.0 resources/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
   -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode  INDEL \
   -recalFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.indel.recal \
   -tranchesFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.indel.tranches \
   -rscriptFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.indel.plots.R
   
 # ApplyRecalibration - INDELS
 
java -Xmx3g -jar /share/apps/gatk-3.2.2/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/ucsc.hg19.fasta \
   -input results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.corrected.snp.recalibrated.filtered.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.indel.tranches \
   -recalFile results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target.indel.recal \
   -mode INDEL \
   -o results/variant_recal/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.vcf 
   