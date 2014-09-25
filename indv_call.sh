#! /bin/bash


# UnifiedGenotyper - individual call
# UCSC_interval.bed - Exons + 10bp at each end



# GATK

nohup java -Xmx50g -jar software/GenomeAnalysisTK.jar -nct 8 -T UnifiedGenotyper -L genome/UCSC_interval.bed -R genome/hg19.fa -I results/$1/$1.recal.bam -o results/temp/$1_indv_call_snps.vcf -stand_call_conf 20.0 -stand_emit_conf 20.0 -glm BOTH -dcov 1000 --annotation AlleleBalance --annotation FisherStrand --annotation DepthPerAlleleBySample --annotation RMSMappingQuality --annotation HomopolymerRun --annotation AlleleBalanceBySample --annotation HaplotypeScore --annotation LowMQ --annotation MappingQualityZero --annotation MappingQualityZeroBySample --annotation QualByDepth --annotation RMSMappingQuality -nda -mbq 20 -D genome/dbSNP137.vcf 2> /dev/null < /dev/null

nohup java -Xmx50g -jar software/GenomeAnalysisTK.jar -T VariantFiltration -R genome/hg19.fa --variant results/temp/$1_indv_call_snps.vcf -o results/individual_call/$1_indv_call_recal_filt.vcf --filterExpression "QD < 5.0" --filterName "QDFilter" --filterExpression "QUAL <= 50.0" --filterName "QUALFilter" --clusterSize 3 --downsample_to_coverage 1000 --baq OFF -baqGOP 40 --defaultBaseQualities 1 --filterExpression "MQ < 30.00" --filterName "MQ" --filterExpression "FS > 60.000" --filterName "FS" --filterExpression "HRun > 5.0" --filterName "HRunFilter" --filterExpression "ABHet > 0.75" --filterName "ABFilter" 2> /dev/null < /dev/null

# ANNOVAR

nohup software/annovar/convert2annovar.pl --format vcf4 --includeinfo results/individual_call/$1_indv_call_recal_filt.vcf > results/temp/annovar/$1_indv_call_recal_filt.annovar 2> /dev/null < /dev/null

nohup software/annovar/table_annovar.pl results/temp/annovar/$1_indv_call_recal_filt.annovar software/annovar/humandb/ -buildver hg19 -out results/annovar_files/$1_indv_call_recal_filt -remove -protocol refGene,phastConsElements46way,genomicSuperDups,esp6500si_all,1000g2012apr_all,snp130,snp132,ljb2_all -operation g,r,r,f,f,f,f,f -nastring NA -csvout 2> /dev/null < /dev/null
