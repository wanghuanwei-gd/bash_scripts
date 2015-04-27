#!/bin/bash

# Picard-GATK pipeline for Alzheimer's Disease
# Pipeline for variant calling using GATK's UnifiedGenotyper for group call.
# This pipeline assumes you have BWA, Picard and GATK installed in a child directory called software/. Call this script from the parent directory, you will have to set the path to the data folder.  The intermediate files WILL BE DELETED after used to save space on disk. To avoid that, delete the 'rm file' commands.
# Necessary resource files: hg19.fa (can be downloaded from ftp.broadinstitute.org), hg19.dict (created using SAMtools (or BWA), can be downloaded from the ftp as well), hg19.fai (generated using CreateSequenceDictionary from Picard (or BWA), can also be downloaded from ftp server).
# Note: Be carful with the hg19 and b37 notations. b37 uses sequence naming conventions “1” to “22”, “X”, “Y” and “MT”, whereas hg19 uses sequence naming conventions “chr1” to “chr22”, “chrX”, “chrY” and “chrM”. Moreover, hg19 has an older mitochondrial sequence (whereas b37 has an updated one), and includes “alternate loci”. Make sure your files have the same notation as the reference files.
# Target file: S04380110_Covered_corrected.bed (downloaded from Agilent server), or other target file (can be created at UCSC Table Browser)
# Other resource files for Variant Recalibration : Mills_and_1000G_gold_standard.indels.b37.sites.vcf, hapmap_3.3.b37.sites.vcf, 1000G_omni2.5.b37.sites.vcf, dbsnp_138.b37.vcf.

# list with the file names

#samples=( 50296-10015 50296-10001 50296-10036 50296-10553 50456-10199 50456-10169 50456-10167 50459-10334 )
#samples=( 50459-10333 50459-10354 50999-10622 50999-10624 50999-10621 51141-10093 51141-10092 51141-10091 )
#samples=( 51151-10124 51151-10125 51151-10140 51219-10310 51219-10311 51219-10422 52143-10101 52143-10110 )
#samples=( 52143-10098 52143-10537 52251-10484 52251-10474 52251-10485 52251-10487 52251-10488 22-12-1 22-12-2 )
#samples=( 22-12-3 22-12-4 22-12-99 25-18-346 25-18-347 25-18-348 25-18-349 25-18-359 4H-242-11 4H-242-12 4H-242-5 4H-242-8 )
samples=( 4H-242-99 4H-348-11 4H-348-3 4H-348-8 4H-348-9 4H-348-99 26-HTB-24401 26-HTB-24403 26-HTB-24449 26-HTB-24404 )


for i in "${samples[@]}"
do
	echo "Processing sample $i..."
	# BWA
	software/bwa-0.7.9a2/bwa mem -t 10 -M resources/hg19.fa /data2/fgelin/alzheimer/data/exome_fastq/$i\_1.fastq /data2/fgelin/alzheimer/data/exome_fastq/$i\_2.fastq > /data2/fgelin/alzheimer/results/bam/bwa/$i.sam
	
	# Picard SortSam, change the input directory to I=path/to/data
	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/SortSam.jar SO=coordinate I=/data2/fgelin/alzheimer/results/bam/bwa/$i.sam O=/data2/fgelin/alzheimer/results/bam/sorted/$i.sorted.bam CREATE_INDEX=true

	# Picard MarkDuplicates

	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/MarkDuplicates.jar CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT M=index2 I=/data2/fgelin/alzheimer/results/bam/sorted/$i.sorted.bam O=/data2/fgelin/alzheimer/results/bam/mark_duplicates/$i.sorted.dpl.bam
	rm /data2/fgelin/alzheimer/results/bam/sorted/$i.sorted.bam
	# Picard AddOrReplaceGroups

	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/AddOrReplaceReadGroups.jar I=/data2/fgelin/alzheimer/results/bam/mark_duplicates/$i.sorted.dpl.bam O=/data2/fgelin/alzheimer/results/bam/add_replace_groups/$i.sorted.dpl.adr.bam SO=coordinate RGID=AD RGLB=UW PL=illumina PU=FG SM=$i
	rm /data2/fgelin/alzheimer/results/bam/mark_duplicates/$i.sorted.dpl.bam
	# Picard BuildBamIndex

	java -Xmx50g -jar software/picard-tools-1/picard-tools-1.114/BuildBamIndex.jar I=/data2/fgelin/alzheimer/results/bam/add_replace_groups/$i.sorted.dpl.adr.bam O=/data2/fgelin/alzheimer/results/bam/add_replace_groups/$i.sorted.dpl.adr.bai
	
	# GATK RealignerTargetCreator

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -nt 10 -T RealignerTargetCreator -R resources/hg19.fa -I /data2/fgelin/alzheimer/results/bam/add_replace_groups/$i.sorted.dpl.adr.bam -o /data2/fgelin/alzheimer/results/bam/gatk_target_creator_list/$i.intervalsList.list -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf
	
	# GATK IndelRealigner

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T IndelRealigner -R resources/hg19.fa -targetIntervals /data2/fgelin/alzheimer/results/bam/gatk_target_creator_list/$i.intervalsList.list -I /data2/fgelin/alzheimer/results/bam/add_replace_groups/$i.sorted.dpl.adr.bam -known resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -o /data2/fgelin/alzheimer/results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam
	rm /data2/fgelin/alzheimer/results/bam/add_replace_groups/$i.sorted.dpl.adr.bam
	rm /data2/fgelin/alzheimer/results/bam/gatk_target_creator_list/$i.intervalsList.list
	# GATK BaseRecalibrator

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T BaseRecalibrator -R resources/hg19.fa -knownSites resources/Mills_and_1000G_gold_standard.indels.b37.sites.vcf -I /data2/fgelin/alzheimer/results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam -o /data2/fgelin/alzheimer/results/bam/base_recalibrator_tables/$i.table

	# GATK PrintReads

	java -Xmx50g -jar software/GenomeAnalysisTK.jar -T PrintReads -R resources/hg19.fa -I /data2/fgelin/alzheimer/results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam --BQSR /data2/fgelin/alzheimer/results/bam/base_recalibrator_tables/$i.table -o /data2/fgelin/alzheimer/results/bam/gatk_print_reads/$i.recal.bam
	rm /data2/fgelin/alzheimer/results/bam/base_recalibrator_tables/$i.table
	rm /data2/fgelin/alzheimer/results/bam/gatk_indel_realigner/$i.sorted.dpl.adr.realigned.bam
done