#!/bin/bash

# Picard-GATK pipeline for Alzheimer's Disease
# Pipeline for variant calling using GATK's UnifiedGenotyper for group call.
# This pipeline assumes you have BWA, Picard and GATK installed in a child directory called software/. Call this script from the parent directory, you will have to set the path to the data folder.  The intermediate files WILL BE DELETED after used to save space on disk.
# Necessary resource files: hg19.fa (can be downloaded from ftp.broadinstitute.org), hg19.dict (created using SAMtools (or BWA), can be downloaded from the ftp as well), hg19.fai (generated using CreateSequenceDictionary from Picard (or BWA), can also be downloaded from ftp server).
# Note: Be carful with the hg19 and b37 notations. b37 uses sequence naming conventions “1” to “22”, “X”, “Y” and “MT”, whereas hg19 uses sequence naming conventions “chr1” to “chr22”, “chrX”, “chrY” and “chrM”. Moreover, hg19 has an older mitochondrial sequence (whereas b37 has an updated one), and includes “alternate loci”. Make sure your files have the same notation as the reference files.
# Target file: S04380110_Covered_corrected.bed (downloaded from Agilent server), or other target file (can be created at UCSC Table Browser)
# Other resource files for Variant Recalibration : Mills_and_1000G_gold_standard.indels.b37.sites.vcf, hapmap_3.3.b37.sites.vcf, 1000G_omni2.5.b37.sites.vcf, dbsnp_138.b37.vcf.


mkdir results \
	  results/bam \
	  results/bam/bwa \
	  results/bam/sorted \
	  results/bam/add_replace_groups \
	  results/bam/gatk_target_creator_list \
	  results/bam/gatk_indel_realigner \
      results/bam/base_recalibrator_tables \
	  results/bam/gatk_print_reads \
	  results/vcf \
	  results/vcf/unified_genotyper \
	  results/vcf/variant_recal \
	  results/vcf/variant_recal/temp \
	  results/vcf/variant_recal/snp \
	  results/vcf/variant_recal/snp_indel   	  	 
	  	  
# list with the file names
samples=( 10R-R64-1.14468 10R-R64-21.14469 25-48-1355.14515 26-ASW-ASW62022.14516 27-51-83751.14518 4-162-11.14453 4-162-68.14454 4H-360-12.14495 4H-360-99.14494 50115-90C00018.14503 4-162-7.14452 4-393-31.14456 4-393-36.14457 4H-197-14.14485 4H-197-15.30221 4H-197-90.14486 4H-197-9.14484 4H-216-14.14492 )  
for i in "${samples[@]}"
do
	echo "Processing sample $i..."
	# BWA
	# bwa mem -t 10 -M resources/hg19.fa data/$i_1.fastq /data/$i_2.fastq > results/bam/bwa/$i.sam
	
	# Picard SortSam, change the input directory to I=path/to/data
	java -Xmx50g -jar software/picard-tools-1.119/SortSam.jar SO=coordinate I=/media/RAID5-2/jan/jan/bam-exon/$i.bam O=results/bam/sorted/$i.sorted.bam CREATE_INDEX=true

	# Picard MarkDuplicates

	java -Xmx50g -jar software/picard-tools-1.119/MarkDuplicates.jar CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT M=index2 I=results/bam/sorted/$i.sorted.bam O=results/bam/mark_duplicates/$i.sorted.dpl.bam
	rm results/bam/sorted/$i.sorted.bam
	# Picard AddOrReplaceGroups

	java -Xmx50g -jar software/picard-tools-1.119/AddOrReplaceReadGroups.jar I=results/bam/mark_duplicates/$i.sorted.dpl.bam O=results/bam/add_replace_groups/$i.sorted.dpl.adr.bam SO=coordinate RGID=AD RGLB=UW PL=illumina PU=FG SM=$i
	rm results/bam/mark_duplicates/$i.sorted.dpl.bam
	# Picard BuildBamIndex

	java -Xmx50g -jar software/picard-tools-1.119/BuildBamIndex.jar I=results/bam/add_replace_groups/$i.sorted.dpl.adr.bam O=results/bam/add_replace_groups/$i.sorted.dpl.adr.bai
	
	# GATK RealignerTargetCreator

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -nt 10 -T RealignerTargetCreator -R resources/hg19.fa -I results/bam/add_replace_groups/$i.sorted.dpl.adr.bam -o results/bam/gatk_target_creator_list/$i.intervalsList.list -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf
	
	# GATK IndelRealigner

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T IndelRealigner -R resources/hg19.fa -targetIntervals results/bam/gatk_target_creator_list/$i.intervalsList.list -I results/bam/add_replace_groups/$i.sorted.dpl.adr.bam -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -o results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam
	rm results/bam/add_replace_groups/$i.sorted.dpl.adr.bam
	rm results/bam/gatk_target_creator_list/$i.intervalsList.list
	# GATK BaseRecalibrator

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T BaseRecalibrator -R resources/hg19.fa -knownSites resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -I results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam -o results/bam/base_recalibrator_tables/$i.table

	# GATK PrintReads

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T PrintReads -R resources/hg19.fa -I results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam --BQSR results/bam/base_recalibrator_tables/$i.table -o results/bam/gatk_print_reads/$i.recal.bam
	rm results/bam/base_recalibrator_tables/$i.table
	rm results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam
done

# GATK UnifiedGenotyper, include the path to each BAM file generated by GATK Print Reads in the -I fields.

java -Xmx50g -jar software/GenomeAnalysisTK.jar -nct 8 -T UnifiedGenotyper -L resources/S04380110/S04380110_Covered_corrected.bed -R resources/hg19.fa \
-I results/bam/gatk_print_reads/0-62071-22.14477.recal.bam \
-I results/bam/gatk_print_reads/0-62071-27.14478.recal.bam \
-I results/bam/gatk_print_reads/0-62100-21.14482.recal.bam \
-I results/bam/gatk_print_reads/0-62100-29.14483.recal.bam \
-I results/bam/gatk_print_reads/0-62151-115.14474.recal.bam \
-I results/bam/gatk_print_reads/0-62151-3.14472.recal.bam \
-I results/bam/gatk_print_reads/0-62151-33.14473.recal.bam \
-I results/bam/gatk_print_reads/0-62249-3.14479.recal.bam \
-I results/bam/gatk_print_reads/0-62249-42.14481.recal.bam \
-I results/bam/gatk_print_reads/0-62249-7.14480.recal.bam \
-I results/bam/gatk_print_reads/0-62486-14.14475.recal.bam \
-I results/bam/gatk_print_reads/0-62486-34.14476.recal.bam \
-I results/bam/gatk_print_reads/0-62630-1.14470.recal.bam \
-I results/bam/gatk_print_reads/0-62630-95.14471.recal.bam \
-I results/bam/gatk_print_reads/07C62252.6152.recal.bam \
-I results/bam/gatk_print_reads/07C65579.6153.recal.bam \
-I results/bam/gatk_print_reads/10R-R64-1.14468.recal.bam \
-I results/bam/gatk_print_reads/10R-R64-21.14469.recal.bam \
-I results/bam/gatk_print_reads/19-L0022-L0022A.14512.recal.bam \
-I results/bam/gatk_print_reads/19-L0034-L0034A.14513.recal.bam \
-I results/bam/gatk_print_reads/25-42-1139.14514.recal.bam \
-I results/bam/gatk_print_reads/25-48-1355.14515.recal.bam \
-I results/bam/gatk_print_reads/26-ASW-ASW62022.14516.recal.bam \
-I results/bam/gatk_print_reads/27-51-83751.14518.recal.bam \
-I results/bam/gatk_print_reads/4-162-11.14453.recal.bam \
-I results/bam/gatk_print_reads/4-162-68.14454.recal.bam \
-I results/bam/gatk_print_reads/4-162-7.14452.recal.bam \
-I results/bam/gatk_print_reads/4-393-31.14456.recal.bam \
-I results/bam/gatk_print_reads/4-393-36.14457.recal.bam \
-I results/bam/gatk_print_reads/4-393-4.14455.recal.bam \
-I results/bam/gatk_print_reads/4-553-21.14458.recal.bam \
-I results/bam/gatk_print_reads/4-553-99.14459.recal.bam \
-I results/bam/gatk_print_reads/4H-197-14.14485.recal.bam \
-I results/bam/gatk_print_reads/4H-197-15.30221.recal.bam \
-I results/bam/gatk_print_reads/4H-197-90.14486.recal.bam \
-I results/bam/gatk_print_reads/4H-197-9.14484.recal.bam \
-I results/bam/gatk_print_reads/4H-216-14.14492.recal.bam \
-I results/bam/gatk_print_reads/4H-216-18.14493.recal.bam \
-I results/bam/gatk_print_reads/4H-216-9.14491.recal.bam \
-I results/bam/gatk_print_reads/4H-224-26.30222.recal.bam \
-I results/bam/gatk_print_reads/4H-224-28.14487.recal.bam \
-I results/bam/gatk_print_reads/4H-224-29.30223.recal.bam \
-I results/bam/gatk_print_reads/4H-224-48.14488.recal.bam \
-I results/bam/gatk_print_reads/4H-354-12.14489.recal.bam \
-I results/bam/gatk_print_reads/4H-354-21.14490.recal.bam \
-I results/bam/gatk_print_reads/4H-354-25.30225.recal.bam \
-I results/bam/gatk_print_reads/4H-360-12.14495.recal.bam \
-I results/bam/gatk_print_reads/4H-360-99.14494.recal.bam \
-I results/bam/gatk_print_reads/50115-90C00018.14503.recal.bam \
-I results/bam/gatk_print_reads/50115-90C00025.30226.recal.bam \
-I results/bam/gatk_print_reads/50115-90C00049.14502.recal.bam \
-I results/bam/gatk_print_reads/50127-90C00007.14504.recal.bam \
-I results/bam/gatk_print_reads/50127-90C00053.14505.recal.bam \
-I results/bam/gatk_print_reads/50452-90C01493.14496.recal.bam \
-I results/bam/gatk_print_reads/50452-90C04511.14497.recal.bam \
-I results/bam/gatk_print_reads/50452-90C04531.14498.recal.bam \
-I results/bam/gatk_print_reads/50578-90C03259.14499.recal.bam \
-I results/bam/gatk_print_reads/50578-90C04632.14500.recal.bam \
-I results/bam/gatk_print_reads/50857-90C03164.14506.recal.bam \
-I results/bam/gatk_print_reads/50857-90C04542.14507.recal.bam \
-I results/bam/gatk_print_reads/50962-90C03735.14508.recal.bam \
-I results/bam/gatk_print_reads/50962-90C03934.14509.recal.bam \
-I results/bam/gatk_print_reads/50997-90C04643.14510.recal.bam \
-I results/bam/gatk_print_reads/50997-90C04646.30227.recal.bam \
-I results/bam/gatk_print_reads/50997-90C04651.30228.recal.bam \
-I results/bam/gatk_print_reads/50997-90C04652.14511.recal.bam \
-I results/bam/gatk_print_reads/5-26057-107.14460.recal.bam \
-I results/bam/gatk_print_reads/5-26057-119.14461.recal.bam \
-I results/bam/gatk_print_reads/62071-37.30218.recal.bam \
-I results/bam/gatk_print_reads/62151-31.30216.recal.bam \
-I results/bam/gatk_print_reads/62249-16.30219.recal.bam \
-I results/bam/gatk_print_reads/62486-35.30217.recal.bam \
-I results/bam/gatk_print_reads/8-64016-10.14519.recal.bam \
-I results/bam/gatk_print_reads/8-64021-3.14463.recal.bam \
-I results/bam/gatk_print_reads/8-64021-47.30215.recal.bam \
-I results/bam/gatk_print_reads/8-64035-29.14517.recal.bam \
-I results/bam/gatk_print_reads/8-64041-1.14464.recal.bam \
-I results/bam/gatk_print_reads/8-64041-77.14465.recal.bam \
-o results/vcf/unified_genotyper/ad_ug_group_call_agilentV5_target.vcf -stand_call_conf 20.0 -stand_emit_conf 20.0 -glm BOTH -dcov 1000 --annotation AlleleBalance --annotation FisherStrand --annotation DepthPerAlleleBySample --annotation RMSMappingQuality --annotation HomopolymerRun --annotation AlleleBalanceBySample --annotation HaplotypeScore --annotation LowMQ --annotation MappingQualityZero --annotation MappingQualityZeroBySample --annotation QualByDepth --annotation RMSMappingQuality -nda -mbq 20

# GATK VariantFiltration

java -Xmx50g -jar software/GenomeAnalysisTK.jar -T VariantFiltration -R resources/hg19.fa --variant results/vcf/unified_genotyper/ad_ug_group_call_agilentV5_target.vcf -o results/vcf/variant_filtration/ad_ug_group_call_agilentV5_target_filtered.vcf --filterExpression "QD < 5.0" --filterName "QDFilter" --filterExpression "QUAL <= 30.0" --filterName "QUALFilter" --clusterSize 3 --downsample_to_coverage 1000 --baq OFF -baqGOP 40 --defaultBaseQualities 1 --filterExpression "MQ < 30.00" --filterName "MQ" --filterExpression "FS > 60.000" --filterName "FS" --filterExpression "HRun > 5.0" --filterName "HRunFilter" --filterExpression "ABHet > 0.75" --filterName "ABFilter" --filterExpression "SB > -10.0 " --filterName "StrandBias"

# VariantRecalibrator - SNPs.
# PDF will be generated only if R is installed, otherwise only R scripts will be generated.

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/hg19.fa \
   -input results/vcf/variant_filtration/ad_ug_group_call_agilentV5_target_filtered.vcf \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources/hapmap_3.3.b37.sites.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 resources/1000G_omni2.5.b37.sites.vcf \
   -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 resources/dbsnp_138.b37.vcf \
   -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode SNP \
   -recalFile results/vcf/variant_recalibration/temp/ad.ug.vcf.snp.recal \
   -tranchesFile results/vcf/variant_recalibration/temp/ad.ug.vcf.snp.tranches \
   -rscriptFile results/vcf/variant_recalibration/temp/ad.ug.vcf.snp.plots.R

# ApplyRecalibration - SNPs

java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/hg19.fa \
   -input results/vcf/variant_filtration/ad_ug_group_call_agilentV5_target_filtered.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile results/vcf/variant_recalibration/temp/ad.ug.vcf.snp.tranches \
   -recalFile results/vcf/variant_recalibration/temp/ad.ug.vcf.snp.recal \
   -mode SNP \
   -o results/vcf/variant_recal/snp/ad.ug.vcf.recal.snp.vcf 

 # VariantRecalibrator - INDELS 

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/hg19.fa \
   -input results/vcf/variant_recal/snp/ad.ug.vcf.recal.snp.vcf  \
   -resource:mills,known=false,training=true,truth=true,prior=15.0 resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
   -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode  INDEL \
   -recalFile results/vcf/variant_recal/temp/ad.ug.vcf.snp.indel.recal \
   -tranchesFile results/vcf/variant_recal/temp/ad.ug.vcf.snp.indel.tranches \
   -rscriptFile results/vcf/variant_recal/temp/ad.ug.vcf.snp.indel.plots.R

 # ApplyRecalibration - INDELS

java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/ucsc.hg19.fasta \
   -input results/vcf/variant_recal/snp/ad.ug.vcf.recal.snp.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile results/vcf/variant_recal/temp/ad.ug.vcf.snp.indel.tranches \
   -recalFile results/vcf/variant_recal/temp/ad.ug.vcf.snp.indel.recal \
   -mode INDEL \
   -o results/vcf/variant_recal/snp_indel/ad.ug.vcf.snp.indel.recal.filt.vcf 
