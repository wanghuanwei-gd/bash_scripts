#!/bin/bash
# Select two samples out of a VCF with many samples:
samples=( 11151 30-10084 30-10138 30-11173 30-11207 30-11296 30-11573 31-10039 31-10065 31-10092 31-10104 32-10281 32-10290 )
for i in "${samples[@]}"
do
	echo "Processing sample $i..."

    # VariantRecalibrator - SNPs

   java -Xmx4g -jar software/GenomeAnalysisTK.jar \
      -T VariantRecalibrator \
      -R resources/ucsc.hg19.fasta \
      -input results/ind_call/corrected/$i.corrected.vcf \
      -resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources/hapmap_3.3.hg19.sites.vcf \
      -resource:omni,known=false,training=true,truth=false,prior=12.0 resources/1000G_omni2.5.hg19.sites.vcf \
      -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 resources/dbsnp_138.hg19.vcf \
      -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
      -mode SNP \
      -recalFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.recal \
      -tranchesFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.tranches \
      -rscriptFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.plots.R
   
   # ApplyRecalibration - SNPs
 
   java -Xmx3g -jar software/GenomeAnalysisTK.jar \
      -T ApplyRecalibration \
      -R resources/ucsc.hg19.fasta \
      -input results/ind_call/corrected/$i.corrected.vcf \
      --ts_filter_level 99.0 \
      -tranchesFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.tranches \
      -recalFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.recal \
      -mode SNP \
      -o results/ind_call/variant_recal/temp/$i.corrected.vcf.recal.snp.vcf 
 
   
    # VariantRecalibrator - INDELS 

   
   java -Xmx4g -jar software/GenomeAnalysisTK.jar \
      -T VariantRecalibrator \
      -R resources/ucsc.hg19.fasta \
      -input results/ind_call/variant_recal/temp/$i.corrected.vcf.recal.snp.vcf \
      -resource:mills,known=false,training=true,truth=true,prior=15.0 resources/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
      -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
      -mode INDEL \
      -recalFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.indel.recal \
      -tranchesFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.indel.tranches \
      -rscriptFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.indel.plots.R
   
    # ApplyRecalibration - INDELS
 
   java -Xmx3g -jar software/GenomeAnalysisTK.jar \
      -T ApplyRecalibration \
      -R resources/ucsc.hg19.fasta \
      -input results/ind_call/variant_recal/temp/$i.corrected.vcf.recal.snp.vcf \
      --ts_filter_level 99.0 \
      -tranchesFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.indel.tranches \
      -recalFile results/ind_call/variant_recal/temp/$i.corrected.vcf.snp.indel.recal \
      -mode INDEL \
      -o results/ind_call/variant_recal/final/$i.corrected.vcf.snp.indel.recalibrated.filtered.vcf 
   
   # annotate
   
   software/annovar/table_annovar.pl results/ind_call/variant_recal/final/$i.corrected.vcf.snp.indel.recalibrated.filtered.vcf software/annovar/humandb/ \
   	-buildver hg19 -out results/ind_call/annotated/$i.corrected.vcf.snp.indel.recal.filt.annovar -remove \
   	-protocol refGene,genomicSuperDups,esp6500si_all,esp6500si_ea,esp6500si_aa,1000g2014aug_all,1000g2014aug_afr,1000g2014aug_eur,snp132,snp138 -operation g,r,f,f,f,f,f,f,f,f -nastring NA -vcfinput
    
done