java -Xmx50g -jar software/GenomeAnalysisTK.jar -nct 8 -T HaplotypeCaller -L resources/S04380110/S04380110_Covered_corrected.bed -R resources/hg19.fa -I results/individual_data/11151/11151.recal.bam  -I results/individual_data/11606/11606.recal.bam  -I results/individual_data/11607/11607.recal.bam  -I results/individual_data/30-10084/30-10084.recal.bam  -I results/individual_data/30-10102/30-10102.recal.bam  -I results/individual_data/30-10115/30-10115.recal.bam  -I results/individual_data/30-10138/30-10138.recal.bam  -I results/individual_data/30-11135/30-11135.recal.bam  -I results/individual_data/30-11148/30-11148.recal.bam  -I results/individual_data/30-11173/30-11173.recal.bam  -I results/individual_data/30-11174/30-11174.recal.bam  -I results/individual_data/30-11186/30-11186.recal.bam  -I results/individual_data/30-11207/30-11207.recal.bam  -I results/individual_data/30-11265/30-11265.recal.bam  -I results/individual_data/30-11295/30-11295.recal.bam  -I results/individual_data/30-11296/30-11296.recal.bam  -I results/individual_data/30-11310/30-11310.recal.bam  -I results/individual_data/30-11504/30-11504.recal.bam  -I results/individual_data/30-11573/30-11573.recal.bam  -I results/individual_data/30-11583/30-11583.recal.bam  -I results/individual_data/30-11593/30-11593.recal.bam  -I results/individual_data/31-10039/31-10039.recal.bam  -I results/individual_data/31-10046/31-10046.recal.bam  -I results/individual_data/31-10051/31-10051.recal.bam  -I results/individual_data/31-10065/31-10065.recal.bam  -I results/individual_data/31-10087/31-10087.recal.bam  -I results/individual_data/31-10091/31-10091.recal.bam  -I results/individual_data/31-10092/31-10092.recal.bam  -I results/individual_data/31-10095/31-10095.recal.bam  -I results/individual_data/31-10103/31-10103.recal.bam  -I results/individual_data/31-10104/31-10104.recal.bam  -I results/individual_data/31-10302/31-10302.recal.bam  -I results/individual_data/32-10280/32-10280.recal.bam  -I results/individual_data/32-10281/32-10281.recal.bam  -I results/individual_data/32-10282/32-10282.recal.bam  -I results/individual_data/32-10283/32-10283.recal.bam  -I results/individual_data/32-10290/32-10290.recal.bam  -I results/individual_data/33-8520-10/33-8520-10.recal.bam  -I results/individual_data/33-8520-35/33-8520-35.recal.bam  -I results/individual_data/44-1053-001/44-1053-001.recal.bam  -I results/individual_data/44-1053-002/44-1053-002.recal.bam  -I results/individual_data/44-1053-004/44-1053-004.recal.bam  -I results/individual_data/45-1040-001/45-1040-001.recal.bam  -I results/individual_data/45-1040-002/45-1040-002.recal.bam  -I results/individual_data/45-1040-003/45-1040-003.recal.bam  -I results/individual_data/45-1040-004/45-1040-004.recal.bam  -I results/individual_data/45-1040-005/45-1040-005.recal.bam  -I results/individual_data/49-1002-001/49-1002-001.recal.bam  -I results/individual_data/49-1002-002/49-1002-002.recal.bam  -I results/individual_data/49-1002-005/49-1002-005.recal.bam  -I results/individual_data/49-1002-017/49-1002-017.recal.bam  -I results/individual_data/49-1002-018/49-1002-018.recal.bam  -I results/individual_data/53-10031/53-10031.recal.bam  -I results/individual_data/53-10032/53-10032.recal.bam  -I results/individual_data/53-10035/53-10035.recal.bam  -I results/individual_data/53-10036/53-10036.recal.bam  -I results/individual_data/53-10046/53-10046.recal.bam  -I results/individual_data/56-10203/56-10203.recal.bam  -I results/individual_data/56-10209/56-10209.recal.bam  -I results/individual_data/56-10210/56-10210.recal.bam  -I results/individual_data/56-10211/56-10211.recal.bam  -I results/individual_data/70-10693/70-10693.recal.bam  -I results/individual_data/70-11292/70-11292.recal.bam  -I results/individual_data/70-11634/70-11634.recal.bam  -I results/individual_data/70-11714/70-11714.recal.bam  -I results/individual_data/70-11731/70-11731.recal.bam  -I results/individual_data/70-11760/70-11760.recal.bam  -I results/individual_data/70-11763/70-11763.recal.bam  -I results/individual_data/70-12255/70-12255.recal.bam  -I results/individual_data/70-12256/70-12256.recal.bam  -I results/individual_data/70-12565/70-12565.recal.bam  -I results/individual_data/71-5077-01/71-5077-01.recal.bam  -I results/individual_data/71-5077-02/71-5077-02.recal.bam  -I results/individual_data/71-5077-85/71-5077-85.recal.bam  -o results/schiz_group_call_haplotype_caller_raw.vcf -stand_call_conf 30.0 -stand_emit_conf 10.0 --annotation AlleleBalance --annotation FisherStrand --annotation DepthPerAlleleBySample --annotation RMSMappingQuality --annotation HomopolymerRun --annotation AlleleBalanceBySample --annotation HaplotypeScore --annotation LowMQ --annotation MappingQualityZero --annotation MappingQualityZeroBySample --annotation QualByDepth --annotation RMSMappingQuality -nda -mbq 20