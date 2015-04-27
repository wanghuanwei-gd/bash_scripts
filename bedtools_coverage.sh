#!/bin/bash
# Run SamStat on mapped and recallibrated samples:
FILES=/media/RAID5/fgelin/results/bam/gatk_print_reads/*.bam

samples_bed=( 22-12-1 22-12-2 22-12-3 22-12-4 22-12-99 25-18-346 25-18-347 25-18-348 25-18-349 25-18-359 26-HTB-24401 26-HTB-24403 26-HTB-24404 26-HTB-24449 4H-242-11 4H-242-12 4H-242-5 4H-242-8 4H-242-99 4H-348-11 4H-348-3 4H-348-8 4H-348-99 4H-348-9 50296-10001 50296-10015 50296-10036 50296-10553 50456-10167 50456-10169 50456-10199 50459-10333 50459-10334 50459-10354 50999-10621 50999-10622 50999-10624 51141-10091 51141-10092 51141-10093 51151-10124 51151-10125 51151-10140 51219-10310 51219-10311 51219-10422 52143-10098 52143-10101 52143-10110 52143-10537 52251-10474 52251-10484 52251-10485 52251-10487 52251-10488 )
for i in "${samples_bed[@]}"
do 
  echo "Processing sample $i..."
  bedtools coverage -hist -abam alzheimer/results/bam/gatk_print_reads/$i.recal.bam -b resources/S04380110/S04380110_Covered_corrected.bed | grep ^all > $i.hist.all.txt
done


/media/RAID5/fgelin/software/bedtools2/bin/bedtools coverage -hist -abam /media/RAID5/fgelin/results/bam/gatk_print_reads/62071-37.30218.recal.bam -b /media/RAID5/fgelin/resources/S04380110/S04380110_Covered_corrected.bed | grep ^all > 62071-37.30218.hist.all.txt