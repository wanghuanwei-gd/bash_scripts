head -172 SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.vcf.313827603213.txt > SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.vcf.313827603213.corrected.txt
cat SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.vcf.313827603213.txt | grep -v ^# | sed 's/^/chr/' >> SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.vcf.313827603213.corrected.txt

 # VariantRecalibrator - SNPs

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/ucsc.hg19.fasta \
   -input results/annotated_vcf/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.vcf.313827603213.corrected.txt \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources/hapmap_3.3.hg19.sites.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 resources/1000G_omni2.5.hg19.sites.vcf \
   -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 resources/dbsnp_138.hg19.vcf \
   -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode SNP \
   -recalFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.recal \
   -tranchesFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.tranches \
   -rscriptFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.plots.R
   
# ApplyRecalibration - SNPs
 
java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/ucsc.hg19.fasta \
   -input results/annotated_vcf/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.vcf.313827603213.corrected.txt \
   --ts_filter_level 99.0 \
   -tranchesFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.tranches \
   -recalFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.recal \
   -mode SNP \
   -o results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.recalibrated.filtered.vcf 
 
   
 # VariantRecalibrator - INDELS 

   
java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/ucsc.hg19.fasta \
   -input results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.recalibrated.filtered.vcf \
   -resource:mills,known=false,training=true,truth=true,prior=15.0 resources/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
   -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode  INDEL \
   -recalFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.indel.recal \
   -tranchesFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.indel.tranches \
   -rscriptFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.indel.plots.R
   
 # ApplyRecalibration - INDELS
 
java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/ucsc.hg19.fasta \
   -input results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.recalibrated.filtered.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.indel.tranches \
   -recalFile results/variant_recal/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.snp.indel.recal \
   -mode INDEL \
   -o results/annotated_vcf/SeattleSeqAnnotation138.schiz_group_call.annovar.hg19_multianno.indel.snp.recalibrated.filtered.vcf 
   