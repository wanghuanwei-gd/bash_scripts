#!/bin/bash
# Select samples out of a VCF with many samples:
sample_ids=( 90C01297 90C01298 90C01304 90C01319 90C01308 90C02970 90C02971 90C03009 90C03142 00C01445 00C01424 00C01822 00C01656 00C01655 90C01063 90C01238 01C09383 01C09388 02C09539 90C00691 90C00789 90C00866 90C00990 90C02992 90C03067 90C03522 90C03520 03C14865 03C14816 90C01235 90C01334 90C01890 90C01891 90C04224 03C19764 03C20094 03C21012 03C21155 90C01798 90C01805 90C01840 90C01801 04C37692 04C37691 05C50396 03C13990 03C17802 03C15391 90C03310 90C03540 90C03332 02C10767 02C10243 03C14076 01C07039 01C07056 90C02936 90C02963 90C03313 01C08396 01C08398 01C08766 01C08760 01C08761 04C30824 04C30815 04C30822 04C30825 02C11048 02C12825 02C12826 03C14989 03C14829 03C14821 )
individual_ids=( 32-10280 32-10281 32-10282 32-10283 32-10290 30-11173 30-11174 30-11186 30-11265 49-1002-001 49-1002-002 49-1002-005 49-1002-017 49-1002-018 31-10039 31-10051 44-1053-001 44-1053-002 44-1053-004 30-10084 30-10102 30-10115 30-10138 30-11207 30-11295 30-11296 30-11310 45-1040-002 45-1040-004 31-10046 31-10065 31-10103 31-10104 31-10302 70-11714 70-11731 70-11760 70-11763 31-10087 31-10091 31-10092 31-10095 70-12255 70-12256 70-12565 71-5077-01 71-5077-02 71-5077-85 30-11573 30-11583 30-11593 70-10693 70-11292 70-11634 33-8520-10 33-8520-35 30-11135 30-11148 30-11504 53-10031 53-10032 53-10035 53-10036 53-10046 56-10203 56-10209 56-10210 56-10211 11151 11606 11607 45-1040-001 45-1040-003 45-1040-005 )
for ((i=0; i < ${#sample_ids[@]} && i < ${#individual_ids[@]}; i++))
do
	echo "Processing sample $i..."
	cat "${sample_ids[i]}".* > "${individual_ids[i]}".gatk.fam.annovar.seattleseq.vcf.table
done
