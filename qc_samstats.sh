#!/bin/bash
# run fastQC and SAMstats
FILES=/data2/jan/exome-seq2/*.fastq
for f in $FILES
do 
echo "Running fastQC on sample $f"
   ./software/FastQC/fastqc --version
   ./software/FastQC/fastqc --version -o results/alzheimers/fastqc/$f -f $f
done