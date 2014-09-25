#!/bin/bash
# Select two samples out of a VCF with many samples:
samples=( 00C01655.variant19 02C10767.variant9 03C17802.variant7 90C00691.variant16 90C01334.variant14 90C03009.variant18 00C01656.variant19 02C11048.variant13 03C19764.variant10 90C00789.variant16 90C01798.variant11 90C03067.variant17 00C01822.variant19 02C12825.variant13 03C20094.variant10 90C00866.variant16 90C01801.variant11 90C03142.variant18 01C08396.variant4 02C12826.variant13 03C21012.variant10 90C00990.variant16 90C01805.variant11 90C03310.variant6 01C08398.variant4 03C13990.variant7 03C21155.variant10 90C01063.variant12 90C01840.variant11 90C03313.variant8 01C08760.variant4 03C14076.variant9 04C30815.variant5 90C01235.variant14 90C01890.variant14 90C03332.variant6 01C08761.variant4 03C14816.variant 04C30822.variant5 90C01238.variant12 90C01891.variant14 90C03520.variant17 01C08766.variant4 03C14821.variant 04C30824.variant5 90C01297.variant2 90C02936.variant8 90C03522.variant17 01C09383.variant15 03C14829.variant 04C30825.variant5 90C01298.variant2 90C02963.variant8 90C03540.variant6 01C09388.variant15 03C14865.variant 04C37691.variant3 90C01304.variant2 90C02970.variant18 90C04224.variant14 02C09539.variant15 03C14989.variant 04C37692.variant3 90C01308.variant2 90C02971.variant18 02C10243.variant9 03C15391.variant7 05C50396.variant3 90C01319.variant2 90C02992.variant17 )
for i in "${samples[@]}"
do
	echo "Processing sample $i..."
	java -Xmx2g -jar software/GenomeAnalysisTK.jar \
		-nt 8 \
		-R resources/hg19.fa \
		-T SelectVariants \
		--variant results/SeattleSeq/merged_vcf_gatk_fam_call_UCSC_target_corrected.indel.snp.recalibrated.filtered.annovar.SeattleSeqAnnotation138.vcf \
		-o results/SeattleSeq/select_variants_gatk/$i.annovar.seattleseq.vcf \
		-sn $i
done