#!/bin/bash
# Picard-GATK pipeline for Alzheimer's Disease
mkdir results results/bam results/bam/bwa results/bam/sorted results/bam/add_replace_groups results/bam/gatk_target_creator_list results/bam/gatk_indel_realigner results/bam/base_recalibrator_tables results/bam/gatk_print_reads

samples=( 10R-R64-1.14468 10R-R64-21.14469 25-48-1355.14515 26-ASW-ASW62022.14516 27-51-83751.14518 4-162-11.14453 4-162-68.14454 4H-360-12.14495 4H-360-99.14494 50115-90C00018.14503 4-162-7.14452 4-393-31.14456 4-393-36.14457 4H-197-14.14485 4H-197-15.30221 4H-197-90.14486 4H-197-9.14484 4H-216-14.14492 )  
for i in "${samples[@]}"
do
	echo "Processing sample $i..."
	# BWA
	# bwa mem -t 10 -M resources/hg19.fa data/$i_1.fastq /data/$i_2.fastq > results/bam/bwa/$i.sam
	
	# Picard SortSam
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
