#!/bin/bash
# Select two samples out of a VCF with many samples:
samples=( 30-11296 30-11583 31-10046 31-10087 32-10283 44-1053-001 45-1040-004 70-12256 11606 30-11310 30-1193 )
for i in "${samples[@]}"
do
	echo "Processing sample $i..."
    head -123 results/ind_call/vcf_from_ug/$i.vcf > results/ind_call/corrected/$i.corrected.vcf
    cat results/ind_call/vcf_from_ug/$i.vcf | grep -v ^# | sed 's/^/chr/' >> results/ind_call/corrected/$i.corrected.vcf
    
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
 
     
   # annotate
   
   software/annovar/table_annovar.pl results/ind_call/variant_recal/temp/$i.corrected.vcf.recal.snp.vcf software/annovar/humandb/ \
   	-buildver hg19 -out results/ind_call/annotated/$i.corrected.vcf.snp.indel.recal.filt.annovar -remove \
   	-protocol refGene,genomicSuperDups,esp6500si_all,esp6500si_ea,esp6500si_aa,1000g2014aug_all,1000g2014aug_afr,1000g2014aug_eur,snp132,snp138 -operation g,r,f,f,f,f,f,f,f,f -nastring NA -vcfinput
    
done