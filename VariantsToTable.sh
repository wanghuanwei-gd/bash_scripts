#!/bin/bash
FILES=results/SeattleSeq/select_variants_gatk/*.vcf
for f in $FILES
do
	echo "Processing $f file..."
	java -jar software/GenomeAnalysisTK.jar \
	     -R resources/hg19.fa \
	     -T VariantsToTable -AMD \
	     -V $f \
		 --showFiltered \
	     -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F FILTER -F DN -F DA -F FG -F FD -F GM -F GL -F AAC \
		 -F PP -F CDP -F PH -F CP -F CG -F AA -F CN -F DG -F DV -F DSP -F KP \
		 -F CPG -F TFBS -F GESP -F PPI -F PAC -F GS -F MR -F ABHet -F ABHom -F AC -F AF -F AN -F BaseQRankSum \
	     -F DB -F DP -F DS -F Dels -F END -F FS -F HRun -F HaplotypeScore -F InbreedingCoeff -F LowMQ \
		 -F MLEAC -F MLEAF -F MQ -F MQ0 -F MQRankSum -F NDA -F NEGATIVE_TRAIN_SITE -F POSITIVE_TRAIN_SITE \
		 -F QD -F RPA -F RU -F STR -F VQSLOD -F culprit -F Func.refGene -F Func.refGene -F Gene.refGene \
         -F GeneDetail.refGene -F ExonicFunc.refGene -F AAChange.refGene -F genomicSuperDups \
		 -F esp6500si_all -F 1000g2014aug_all -F esp6500si_ea -F 1000g2014aug_eur -F esp6500si_aa \
		 -F 1000g2014aug_afr -F snp132 -F snp138 -GF AB -GF AD -GF DP -GF GQ -GF GT -GF MQ0 -GF PL -F set\
	     -o $f.table
done

