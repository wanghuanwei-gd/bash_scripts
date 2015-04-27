#!/bin/bash
# Run SamStat on mapped and recallibrated samples:
FILES=/media/RAID5/fgelin/results/bam/gatk_print_reads/*.bam
for f in $FILES
do 
	/media/RAID5/fgelin/software/samstat-1.5/src/samstat $f
done

#!/bin/bash
# Run SamStat on mapped and recallibrated samples:
samples=( 22-12-99 25-18-346 25-18-347 25-18-348 26-HTB-24404 4H-242-11 4H-348-11 4H-348-3 4H-348-8 4H-348-99 4H-348-9 50296-10001 50296-10015 50296-10036 50296-10553 50456-10167 50456-10169 50456-10199 51151-10125 51151-10140 51219-10310 51219-10311 51219-10422 52143-10101 52143-10110 52251-10474 )
for i in "${samples[@]}"
do 
	/data2/fgelin/software/samstat-1.5/src/samstat /data2/fgelin/alzheimer/results/bam/gatk_print_reads/4H-242-99.recal.bam
done


4H-242-99