#!/bin/bash
# Select two samples out of a VCF with many samples:
FILES=results/ind_call/axeq_ind/*.remdup.uniqMap.SS5.D1000.var.flt.vcf
for f in $FILES
do 

   software/annovar/table_annovar.pl $f  software/annovar/humandb/ \
   	-buildver hg19 -out $f.annovar -remove \
   	-protocol refGene,genomicSuperDups,esp6500si_all,esp6500si_ea,esp6500si_aa,1000g2014aug_all,1000g2014aug_afr,1000g2014aug_eur,snp132,snp138 -operation g,r,f,f,f,f,f,f,f,f -nastring NA -vcfinput
    
done