#!/bin/bash
# Select samples out of a VCF with many samples:
samples_24=( 30-11135 31-10046 31-10103 53-10032 56-10210 70-11731 71-5077-01 30-11148 31-10065 31-10104 53-10035 56-10211 70-11760 71-5077-02 30-11504 31-10087 31-10302 53-10036 70-10693 70-11763 71-5077-85 30-11573 31-10091 33-8520-10 53-10046 70-11292 70-12255 30-11583 31-10092 33-8520-35 56-10203 70-11634 70-12256 30-11593 31-10095 53-10031 56-10209 70-11714 70-12565)
samples_25=( 30-10084 30-11174 30-11296 32-10281 44-1053-002 49-1002-002 30-10102 30-11186 30-11310 32-10282 44-1053-004 49-1002-005 30-10115 30-11207 31-10039 32-10283 45-1040-002 49-1002-017 30-10138 30-11265 31-10051 32-10290 45-1040-004 49-1002-018 30-11173 30-11295 32-10280 44-1053-001 49-1002-001)
for i in "${samples_24[@]}"
do
	echo "Processing sample $i..."
    software/vcftools_0.1.12a/perl/vcf-subset -c $i results/annotated_vcf/SeattleSeqAnnotation138.RyanNesbitt_1403KHS-0024_VCFMerge.annovar.hg19_multianno.vcf.313577199904.txt > results/annotated_vcf/individual_vcf/$i.axeq.annovar.seattleseq.vcf &
done

for j in "${samples_25[@]}"
do
	echo "Processing sample $j..."
    software/vcftools_0.1.12a/perl/vcf-subset -c $j results/annotated_vcf/SeattleSeqAnnotation138.RyanNesbitt_1403KHS-0025_VCFMerge.annovar.hg19_multianno.vcf.313577257241.txt > results/annotated_vcf/individual_vcf/$j.axeq.annovar.seattleseq.vcf &
done