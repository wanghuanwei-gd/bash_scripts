#!/bin/bash

# Picard-GATK pipeline for Alzheimer's Disease
# Pipeline for variant calling using GATK's UnifiedGenotyper for group call.
# This pipeline assumes you have BWA, Picard and GATK installed in a child directory called software/. Call this script from the parent directory, you will have to set the path to the data folder.  The intermediate files WILL BE DELETED after used to save space on disk. To avoid that, delete the 'rm file' commands.
# Necessary resource files: hg19.fa (can be download_b2_d from ftp.broad_b2_nstitute.org), hg19.dict (created using SAMtools (or BWA), can be download_b2_d from the ftp as well), hg19.fai (generated using CreateSequenceDictionary from Picard (or BWA), can also be download_b2_d from ftp server).
# Note: Be carful with the hg19 and b37 notations. b37 uses sequence naming conventions “1” to “22”, “X”, “Y” and “MT”, whereas hg19 uses sequence naming conventions “chr1” to “chr22”, “chrX”, “chrY” and “chrM”. Moreover, hg19 has an older mitochondrial sequence (whereas b37 has an updated one), and includes “alternate loci”. Make sure your files have the same notation as the reference files.
# Target file: S04380110_Covered_corrected.bed (download_b2_d from Agilent server), or other target file (can be created at UCSC Table Browser)
# Other resource files for Variant Recalibration : Mills_and_1000G_gold_standard.indels.b37.sites.vcf, hapmap_3.3.b37.sites.vcf, 1000G_omni2.5.b37.sites.vcf, dbsnp_138.b37.vcf.


mkdir results \
	  alzheimer/results/bam \
	  alzheimer/results/bam/bwa \
	  alzheimer/results/bam/sorted \
	  alzheimer/results/bam/ad_b2__replace_groups \
	  alzheimer/results/bam/gatk_target_creator_list \
	  alzheimer/results/bam/gatk_indel_realigner \
      alzheimer/results/bam/base_recalibrator_tables \
	  alzheimer/results/bam/gatk_print_read_b2_ \
	  alzheimer/results/vcf \
	  alzheimer/results/vcf/unified_genotyper \
	  alzheimer/results/vcf/variant_recal \
	  alzheimer/results/vcf/variant_recal/temp \
	  alzheimer/results/vcf/variant_recal/snp \
	  alzheimer/results/vcf/variant_recal/snp_indel   	  	 
	  	  
# list with the file names
samples=( 22-12-2 )  
for i in "${samples[@]}"
do
	echo "Processing sample $i..."
	# BWA
	# software/bwa-0.7.9a2/bwa mem -t 10 -M resources/hg19.fa alzheimer/data/exome_fastq/$i\_1.fastq alzheimer/data/exome_fastq/$i\_2.fastq > alzheimer/results/bam/bwa/$i.sam
	
	# Picard SortSam, change the input directory to I=path/to/data
	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/SortSam.jar SO=coordinate I=alzheimer/results/bam/bwa/$i.sam O=alzheimer/results/bam/sorted/$i.sorted.bam CREATE_INDEX=true

	# Picard MarkDuplicates

	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/MarkDuplicates.jar CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT M=index2 I=alzheimer/results/bam/sorted/$i.sorted.bam O=alzheimer/results/bam/mark_duplicates/$i.sorted.dpl.bam
	rm alzheimer/results/bam/sorted/$i.sorted.bam
	# Picard AddOrReplaceGroups

	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/AddOrReplaceRead_b2_roups.jar I=alzheimer/results/bam/mark_duplicates/$i.sorted.dpl.bam O=alzheimer/results/bam/ad_b2__replace_groups/$i.sorted.dpl.ad_b2_.bam SO=coordinate RGID=AD RGLB=UW PL=illumina PU=FG SM=$i
	rm alzheimer/results/bam/mark_duplicates/$i.sorted.dpl.bam
	# Picard BuildBamIndex

	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/BuildBamIndex.jar I=alzheimer/results/bam/ad_b2__replace_groups/$i.sorted.dpl.ad_b2_.bam O=alzheimer/results/bam/ad_b2__replace_groups/$i.sorted.dpl.ad_b2_.bai
	
	# GATK RealignerTargetCreator

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -nt 10 -T RealignerTargetCreator -R resources/hg19.fa -I results/bam/ad_b2__replace_groups/$i.sorted.dpl.ad_b2_.bam -o alzheimer/results/bam/gatk_target_creator_list/$i.intervalsList.list -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf
	
	# GATK IndelRealigner

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T IndelRealigner -R resources/hg19.fa -targetIntervals alzheimer/results/bam/gatk_target_creator_list/$i.intervalsList.list -I results/bam/ad_b2__replace_groups/$i.sorted.dpl.ad_b2_.bam -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -o alzheimer/results/bam/gatk_indel_realigner/$i.sorted.dpl.ad_b2_.realigned.bam
	rm alzheimer/results/bam/ad_b2__replace_groups/$i.sorted.dpl.ad_b2_.bam
	rm alzheimer/results/bam/gatk_target_creator_list/$i.intervalsList.list
	# GATK BaseRecalibrator

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T BaseRecalibrator -R resources/hg19.fa -knownSites resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -I results/bam/gatk_indel_realigner/$i.sorted.dpl.ad_b2_.realigned.bam -o alzheimer/results/bam/base_recalibrator_tables/$i.table

	# GATK PrintRead_b2_

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T PrintRead_b2_ -R resources/hg19.fa -I results/bam/gatk_indel_realigner/$i.sorted.dpl.ad_b2_.realigned.bam --BQSR alzheimer/results/bam/base_recalibrator_tables/$i.table -o alzheimer/results/bam/gatk_print_read_b2_/$i.recal.bam
	rm alzheimer/results/bam/base_recalibrator_tables/$i.table
	rm alzheimer/results/bam/gatk_indel_realigner/$i.sorted.dpl.ad_b2_.realigned.bam
done

# GATK UnifiedGenotyper, include the path to each BAM file generated by GATK Print Read_b2_ in the -I fields.

java -Xmx50g -jar software/GenomeAnalysisTK.jar -nct 8 -T UnifiedGenotyper -L resources/S04380110/S04380110_Covered_corrected.bed -R resources/hg19.fa \
	-I results/bam/gatk_print_read_b2_/0-62071-22.14477.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62249-42.14481.recal.bam \
	-I results/bam/gatk_print_read_b2_/19-L0022-L0022A.14512.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-162-7.14452.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-197-90.14486.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-224-48.14488.recal.bam \
	-I results/bam/gatk_print_read_b2_/50115-90C00049.14502.recal.bam \
	-I results/bam/gatk_print_read_b2_/50857-90C03164.14506.recal.bam \
	-I results/bam/gatk_print_read_b2_/5-26057-107.14460.recal.bam \
	-I results/bam/gatk_print_read_b2_/8-64021-47.30215.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62071-27.14478.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62249-7.14480.recal.bam \
	-I results/bam/gatk_print_read_b2_/19-L0034-L0034A.14513.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-393-31.14456.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-197-9.14484.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-354-12.14489.recal.bam \
	-I results/bam/gatk_print_read_b2_/50127-90C00007.14504.recal.bam \
	-I results/bam/gatk_print_read_b2_/50857-90C04542.14507.recal.bam \
	-I results/bam/gatk_print_read_b2_/5-26057-119.14461.recal.bam \
	-I results/bam/gatk_print_read_b2_/8-64035-29.14517.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62100-21.14482.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62486-14.14475.recal.bam \
	-I results/bam/gatk_print_read_b2_/25-42-1139.14514.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-393-36.14457.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-216-14.14492.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-354-21.14490.recal.bam \
	-I results/bam/gatk_print_read_b2_/50127-90C00053.14505.recal.bam \
	-I results/bam/gatk_print_read_b2_/50962-90C03735.14508.recal.bam \
	-I results/bam/gatk_print_read_b2_/62071-37.30218.recal.bam \
	-I results/bam/gatk_print_read_b2_/8-64041-1.14464.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62100-29.14483.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62486-34.14476.recal.bam \
	-I results/bam/gatk_print_read_b2_/25-48-1355.14515.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-393-4.14455.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-216-18.14493.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-354-25.30225.recal.bam \
	-I results/bam/gatk_print_read_b2_/50452-90C01493.14496.recal.bam \
	-I results/bam/gatk_print_read_b2_/50962-90C03934.14509.recal.bam \
	-I results/bam/gatk_print_read_b2_/62151-31.30216.recal.bam \
	-I results/bam/gatk_print_read_b2_/8-64041-77.14465.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62151-115.14474.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62630-1.14470.recal.bam \
	-I results/bam/gatk_print_read_b2_/26-ASW-ASW62022.14516.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-553-21.14458.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-216-9.14491.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-360-12.14495.recal.bam \
	-I results/bam/gatk_print_read_b2_/50452-90C04511.14497.recal.bam \
	-I results/bam/gatk_print_read_b2_/50997-90C04643.14510.recal.bam \
	-I results/bam/gatk_print_read_b2_/62249-16.30219.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62151-3.14472.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62630-95.14471.recal.bam \
	-I results/bam/gatk_print_read_b2_/27-51-83751.14518.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-553-99.14459.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-224-26.30222.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-360-99.14494.recal.bam \
	-I results/bam/gatk_print_read_b2_/50452-90C04531.14498.recal.bam \
	-I results/bam/gatk_print_read_b2_/50997-90C04646.30227.recal.bam \
	-I results/bam/gatk_print_read_b2_/62486-35.30217.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62151-33.14473.recal.bam \
	-I results/bam/gatk_print_read_b2_/10R-R64-1.14468.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-162-11.14453.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-197-14.14485.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-224-28.14487.recal.bam \
	-I results/bam/gatk_print_read_b2_/50115-90C00018.14503.recal.bam \
	-I results/bam/gatk_print_read_b2_/50578-90C03259.14499.recal.bam \
	-I results/bam/gatk_print_read_b2_/50997-90C04651.30228.recal.bam \
	-I results/bam/gatk_print_read_b2_/8-64016-10.14519.recal.bam \
	-I results/bam/gatk_print_read_b2_/0-62249-3.14479.recal.bam \
	-I results/bam/gatk_print_read_b2_/10R-R64-21.14469.recal.bam \
	-I results/bam/gatk_print_read_b2_/4-162-68.14454.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-197-15.30221.recal.bam \
	-I results/bam/gatk_print_read_b2_/4H-224-29.30223.recal.bam \
	-I results/bam/gatk_print_read_b2_/50115-90C00025.30226.recal.bam \
	-I results/bam/gatk_print_read_b2_/50578-90C04632.14500.recal.bam \
	-I results/bam/gatk_print_read_b2_/50997-90C04652.14511.recal.bam \
	-I results/bam/gatk_print_read_b2_/8-64021-3.14463.recal.bam \
	-I results/bam/gatk_print_read_b2_/50578-90C03120.14501.recal.bam \
-o results/vcf/unified_genotyper/ad_b2_ug_group_call_agilentV5_target.vcf -stand_call_conf 20.0 -stand_emit_conf 20.0 -glm BOTH -dcov 1000 --annotation AlleleBalance --annotation FisherStrand --annotation DepthPerAlleleBySample --annotation RMSMappingQuality --annotation HomopolymerRun --annotation AlleleBalanceBySample --annotation HaplotypeScore --annotation LowMQ --annotation MappingQualityZero --annotation MappingQualityZeroBySample --annotation QualByDepth --annotation RMSMappingQuality -nda -mbq 20

# GATK VariantFiltration

java -Xmx50g -jar software/GenomeAnalysisTK.jar -T VariantFiltration -R resources/hg19.fa --variant results/vcf/unified_genotyper/ad_b2_ug_group_call_agilentV5_target.vcf -o results/vcf/variant_filtration/ad_b2_ug_group_call_agilentV5_target_filtered.vcf --filterExpression "QD < 5.0" --filterName "QDFilter" --filterExpression "QUAL <= 30.0" --filterName "QUALFilter" --clusterSize 3 --downsample_to_coverage 1000 --baq OFF -baqGOP 40 --defaultBaseQualities 1 --filterExpression "MQ < 30.00" --filterName "MQ" --filterExpression "FS > 60.000" --filterName "FS" --filterExpression "HRun > 5.0" --filterName "HRunFilter" --filterExpression "ABHet > 0.75" --filterName "ABFilter" --filterExpression "SB > -10.0 " --filterName "StrandBias"

# VariantRecalibrator - SNPs.
# PDF will be generated only if R is installed, otherwise only R scripts will be generated.

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/hg19.fa \
   -input alzheimer/results/vcf/variant_filtration/ad_b2_ug_group_call_agilentV5_target_filtered.vcf \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources/hapmap_3.3.b37.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 resources/1000G_omni2.5.b37.vcf \
   -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 resources/dbsnp_138.b37.vcf \
   -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode SNP \
   -recalFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.recal \
   -tranchesFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.tranches \
   -rscriptFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.plots.R

# ApplyRecalibration - SNPs

java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/hg19.fa \
   -input alzheimer/results/vcf/variant_filtration/ad_b2_ug_group_call_agilentV5_target_filtered.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.tranches \
   -recalFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.recal \
   -mode SNP \
   -o alzheimer/results/vcf/variant_recal/snp/ad_b2_ug.vcf.recal.snp.vcf 

 # VariantRecalibrator - INDELS 

java -Xmx4g -jar software/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R resources/hg19.fa \
   -input alzheimer/results/vcf/variant_recal/snp/ad_b2_ug.vcf.recal.snp.vcf  \
   -resource:mills,known=false,training=true,truth=true,prior=15.0 resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
   -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ \
   -mode  INDEL \
   -recalFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.indel.recal \
   -tranchesFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.indel.tranches \
   -rscriptFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.indel.plots.R

 # ApplyRecalibration - INDELS

java -Xmx3g -jar software/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R resources/hg19.fa \
   -input alzheimer/results/vcf/variant_recal/snp/ad_b2_ug.vcf.recal.snp.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.indel.tranches \
   -recalFile alzheimer/results/vcf/variant_recal/temp/ad_b2_ug.vcf.snp.indel.recal \
   -mode INDEL \
   -o alzheimer/results/vcf/variant_recal/snp_indel/ad_b2_ug.vcf.snp.indel.recal.filt.vcf 
