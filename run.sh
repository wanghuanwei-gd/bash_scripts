#java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/SortSam.jar SO=coordinate I=alzheimer/results/bam/bwa/22-12-2.sam O=alzheimer/results/bam/sorted/22-12-2.sorted.bam CREATE_INDEX=true

#java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/MarkDuplicates.jar CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT M=index2 I=alzheimer/results/bam/sorted/22-12-2.sorted.bam O=alzheimer/results/bam/mark_duplicates/22-12-2.sorted.dpl.bam

#java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/AddOrReplaceReadGroups.jar I=alzheimer/results/bam/mark_duplicates/22-12-2.sorted.dpl.bam O=alzheimer/results/bam/add_replace_groups/22-12-2.sorted.dpl.adr.bam SO=coordinate RGID=AD RGLB=UW PL=illumina PU=FG SM=22-12-2
	# Picard BuildBamIndex

#java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/BuildBamIndex.jar I=alzheimer/results/bam/add_replace_groups/22-12-2.sorted.dpl.adr.bam O=alzheimer/results/bam/add_replace_groups/22-12-2.sorted.dpl.adr.bai
	
	# GATK RealignerTargetCreator

#java -Xmx50g -jar software/GenomeAnalysisTK.jar -nt 10 -T RealignerTargetCreator -R resources/hg19.fa -I alzheimer/results/bam/add_replace_groups/22-12-2.sorted.dpl.adr.bam -o alzheimer/results/bam/gatk_target_creator_list/22-12-2.intervalsList.list -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf
	
	# GATK IndelRealigner

java -Xmx50g -jar software/GenomeAnalysisTK.jar -T IndelRealigner -R resources/hg19.fa -targetIntervals alzheimer/results/bam/gatk_target_creator_list/22-12-2.intervalsList.list -I alzheimer/results/bam/add_replace_groups/22-12-2.sorted.dpl.adr.bam -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -o alzheimer/results/bam/gatk_indel_realigner/22-12-2.sorted.dpl.adr.realigned.bam
	# GATK BaseRecalibrator

java -Xmx50g -jar software/GenomeAnalysisTK.jar -T BaseRecalibrator -R resources/hg19.fa -knownSites resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -I alzheimer/results/bam/gatk_indel_realigner/22-12-2.sorted.dpl.adr.realigned.bam -o alzheimer/results/bam/base_recalibrator_tables/22-12-2.table

	# GATK PrintReads

java -Xmx50g -jar software/GenomeAnalysisTK.jar -T PrintReads -R resources/hg19.fa -I alzheimer/results/bam/gatk_indel_realigner/22-12-2.sorted.dpl.adr.realigned.bam --BQSR alzheimer/results/bam/base_recalibrator_tables/22-12-2.table -o alzheimer/results/bam/gatk_print_reads/22-12-2.recal.bam

java -Xmx50g -jar software/GenomeAnalysisTK.jar -nct 8 -T UnifiedGenotyper -L resources/S04380110/S04380110_Covered_corrected.bed -R resources/hg19.fa \
-I alzheimer/results/bam/gatk_print_reads/22-12-1.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/22-12-2.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/22-12-3.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/22-12-4.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/22-12-99.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/25-18-346.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/25-18-347.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/25-18-348.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/25-18-349.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/25-18-359.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/26-HTB-24401.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/26-HTB-24403.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/26-HTB-24404.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/26-HTB-24449.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-242-11.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-242-12.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-242-5.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-242-8.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-242-99.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-348-11.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-348-3.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-348-8.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-348-99.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/4H-348-9.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50296-10001.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50296-10015.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50296-10036.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50296-10553.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50456-10167.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50456-10169.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50456-10199.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50459-10333.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50459-10334.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50459-10354.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50999-10621.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50999-10622.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/50999-10624.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51141-10091.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51141-10092.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51141-10093.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51151-10124.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51151-10125.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51151-10140.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51219-10310.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51219-10311.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/51219-10422.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52143-10098.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52143-10101.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52143-10110.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52143-10537.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52251-10474.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52251-10484.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52251-10485.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52251-10487.recal.bam \
-I alzheimer/results/bam/gatk_print_reads/52251-10488.recal.bam \
-o alzheimer/results/vcf/unified_genotyper/ad_ug_b2_group_call_agilentV5_target.vcf -stand_call_conf 20.0 -stand_emit_conf 20.0 -glm BOTH -dcov 1000 --annotation AlleleBalance --annotation FisherStrand --annotation DepthPerAlleleBySample --annotation RMSMappingQuality --annotation HomopolymerRun --annotation AlleleBalanceBySample --annotation HaplotypeScore --annotation LowMQ --annotation MappingQualityZero --annotation MappingQualityZeroBySample --annotation QualByDepth --annotation RMSMappingQuality -nda -mbq 20

# GATK VariantFiltration

java -Xmx50g -jar software/GenomeAnalysisTK.jar -T VariantFiltration -R resources/hg19.fa --variant alzheimer/results/vcf/unified_genotyper/ad_ug_b2_group_call_agilentV5_target.vcf -o alzheimer/results/vcf/variant_filtration/ad_ug_b2_group_call_agilentV5_target_filtered.vcf --filterExpression "QD < 5.0" --filterName "QDFilter" --filterExpression "QUAL <= 30.0" --filterName "QUALFilter" --clusterSize 3 --downsample_to_coverage 1000 --baq OFF -baqGOP 40 --defaultBaseQualities 1 --filterExpression "MQ < 30.00" --filterName "MQ" --filterExpression "FS > 60.000" --filterName "FS" --filterExpression "HRun > 5.0" --filterName "HRunFilter" --filterExpression "ABHet > 0.75" --filterName "ABFilter" --filterExpression "SB > -10.0 " --filterName "StrandBias"
