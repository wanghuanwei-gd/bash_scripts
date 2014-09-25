#!/bin/bash
FILES=/data2/fgelin/results/SeattleSeq/select_variants_gatk/*.vcf
for f in $FILES
do
	echo "Processing $f file..."
	nohup java -Xmx4g -jar /data2/fgelin/software/snpEff/snpEff.jar -c /data2/fgelin/software/snpEff/snpEff.config -v hg19 -stats $f.html $f > $f.snpEff 2> /dev/null < /dev/null
done