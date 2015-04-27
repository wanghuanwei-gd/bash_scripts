# VariantRecalibrator - SNPs.
# PDF will be generated only if R is installed, otherwise only R scripts will be generated.

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/hg19.fa \
   -input   alzheimer/results/vcf/variant_filtration/ad_b2_ug_group_call_agilentV5_target_filtered.vcf \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources/hapmap_3.3.b37.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 resources/1000G_omni2.5.b37.vcf \
   -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 resources/dbsnp_138.b37.vcf \
   -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode SNP \
   -recalFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.recal \
   -tranchesFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.tranches \
   -rscriptFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.plots.R

# ApplyRecalibration - SNPs

java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/hg19.fa \
   -input  alzheimer/results/vcf/variant_filtration/ad_b2_ug_group_call_agilentV5_target_filtered.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile  alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.tranches \
   -recalFile  alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.recal \
   -mode SNP \
   -o  alzheimer/results/vcf/variant_recalibration/snp/ad_b2.ug.vcf.recal.snp.vcf 

 # VariantRecalibrator - INDELS 

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/hg19.fa \
   -input  alzheimer/results/vcf/variant_recalibration/snp/ad_b2.ug.vcf.recal.snp.vcf  \
   -resource:mills,known=false,training=true,truth=true,prior=15.0 resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
   -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode  INDEL \
   -recalFile  alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.indel.recal \
   -tranchesFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.indel.tranches \
   -rscriptFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.indel.plots.R

 # ApplyRecalibration - INDELS

java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/hg19.fa \
   -input   alzheimer/results/vcf/variant_recalibration/snp/ad_b2.ug.vcf.recal.snp.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.indel.tranches \
   -recalFile   alzheimer/results/vcf/variant_recalibration/temp/ad_b2.ug.vcf.snp.indel.recal \
   -mode INDEL \
   -o   alzheimer/results/vcf/variant_recalibration/snp_indel/ad_b2.ug.vcf.snp.indel.recal.filt.vcf 
