head -56 common_all_20150415.vcf  > common_all_20150415_chr.vcf
cat common_all_20150415.vcf | grep -v ^# | sed 's/^/chr/' >> common_all_20150415_chr.vcf

../software/MIPGEN-master/mipgen -regions_to_scan practice_genes.bed -project_name test_modified_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -feature_flank 5 -snp_file common_all_20150415_chr.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta



MIP DESIGN TESTS

# TEST 1: arm length 45, capture size 157, feature flank 0, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan practice_genes.bed -project_name test_1_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

# TEST 2: arm length 45, capture size 157, feature flank 5, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan practice_genes.bed -project_name test_2_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -feature_flank 5 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

# TEST 3: arm length 45, capture size 157, feature flank 5, no common snp file
../software/MIPGEN-master/mipgen -regions_to_scan practice_genes.bed -project_name test_3_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -feature_flank 5 -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

# TEST 6: arm length 45, capture size 157, feature flank 0, bed file plus 5, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan practice_genes_plus5.bed -project_name test_6_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &



# TEST 4: arm length 45, capture size 157, feature flank 0, common snp file from Boyle link to NCBI, indexed with tabix, bed file plus 5 bases
../software/MIPGEN-master/mipgen -regions_to_scan practice_genes_plus5.bed -project_name test_4_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -snp_file common_all.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

# TEST 5: arm length 45, capture size 157, feature flank 5, common snp file from Boyle link to NCBI, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan practice_genes.bed -project_name test_5_design -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -feature_flank 5 -snp_file common_all.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &



# MIP DESIGN: arm length 45, capture size 157, feature flank 5, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan genes_for_MIP_reduced.bed -project_name mips_scz_reduced -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -feature_flank 5 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

python ../software/MIPGEN-master/tools/generate_ucsc_track.py mips_scz.picked_mips.txt mips_scz_track

# MIP DESIGN: arm length 45, capture size 157, feature flank 5, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan genes_for_MIP.bed -project_name mips_scz_145 -arm_length_sums 45 -min_capture_size 145 -max_capture_size 157 -feature_flank 5 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

python ../software/MIPGEN-master/tools/generate_ucsc_track.py mips_scz_145.picked_mips.txt mips_scz_track_145

# MIP DESIGN: arm length 45, capture size 145-155, feature flank 5, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan genes_for_MIP.bed -project_name mips_scz_145-155 -arm_length_sums 45 -min_capture_size 145 -max_capture_size 155 -feature_flank 5 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

python ../software/MIPGEN-master/tools/generate_ucsc_track.py mips_scz_145-155.picked_mips.txt mips_scz_track_145-155


# MIP DESIGN v2: arm length 45, capture size 157 (45+112), feature flank 5, common snp file 20150415, indexed with tabix
../software/MIPGEN-master/mipgen -regions_to_scan genes_for_MIP_2.bed -project_name mip_3 -arm_length_sums 45 -min_capture_size 157 -max_capture_size 157 -feature_flank 5 -snp_file common_all_20150415.vcf.gz -bwa_threads 10 -bwa_genome_index ../resources/hg19_bwa_indexed/hg19.fasta &

python ../software/MIPGEN-master/tools/generate_ucsc_track.py mip_2.picked_mips.txt mip_2_ucsc_track




python ../software/MIPGEN-master/tools/generate_ucsc_track.py test_2_design.picked_mips.txt test_2_ucsc_track
python ../software/MIPGEN-master/tools/generate_ucsc_track.py test_3_design.picked_mips.txt test_3_ucsc_track
python ../software/MIPGEN-master/tools/generate_ucsc_track.py test_4_design.picked_mips.txt test_4_ucsc_track
python ../software/MIPGEN-master/tools/generate_ucsc_track.py test_5_design.picked_mips.txt test_5_ucsc_track
python ../software/MIPGEN-master/tools/generate_ucsc_track.py test_6_design.picked_mips.txt test_6_ucsc_track
