#! /bin/bash

software/vcftools_0.1.12a/perl/vcf-subset -c $1 results/SeattleSeq/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.annovar.SeattleSeqAnnotation138.vcf > results/SeattleSeq/splitted_vcf/$1.annovar.seattleseq.vcf &