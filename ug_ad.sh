#!/bin/bash
# Picard-GATK pipeline for Alzheimer's Disease

samples4=( 50578-90C03120.14501 )  
for i in "${samples4[@]}"
do
	echo "Processing sample $i..."
	# Picard SortSam
	# java -Xmx50g -jar software/picard-tools-1.119/SortSam.jar SO=coordinate I=/media/RAID5-2/jan/jan/bam-exon/$i.bam O=results/bam/sorted/$i.sorted.bam CREATE_INDEX=true

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
