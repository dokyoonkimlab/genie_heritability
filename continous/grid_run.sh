#!/bin/bash
#$ -N ldsc
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=12:00:00
#$ -t 1-73

source /cbica/projects/kimlab/software_dir/modules/common/Anaconda-3.7/etc/profile.d/conda.sh
conda activate ldsc
module load ldsc/1.0.1
mkdir out

PHE=(dummy total_fat_CT_mm2 visceral_fat_CT_mm2 SBP DBP Height Weight BMI Inbody_skeletal_muscle_mass Inbody_Body_fat_mass Inbody_Fat_percent WC glucose TG HDL HBA1C exercise_continuous cal_score_cont EKG_rate WBC PLT SEG_NEUT. LYMPHOCYTE MONOCYTE EOSINOPHIL BASOPHIL RBC HB CALCIUM PHOSPHORUS BUN URIC_ACID CREATININE Na K CL TCO2 GFR free_T4 TSH CA125 CA19_9 AFP CEA PSA VitD3 Total_chol serum_protein serum_albumin serum_total_bil ALP GOT GPT GGT LDL_chol MCV MCH MCHC PCT MPV PT aPTT HCT RDW IOP_rt IOP_left FVC_L FVC_percent FEV1_L FEV1_percent FEV1_FVC_percent nocturia_frequency depression_score urine_PH)

# editing munge_sumstats.py (line 701, in the check_median() function) to loosen the tolerance on the check
# https://groups.google.com/forum/#!topic/ldsc_users/RLbVw3e_PU0
munge_sumstats_nobeta_median_check.py --sumstats ../convert_plato_output/continous/out/result_"${PHE[$SGE_TASK_ID]}" --out out/res_"${PHE[$SGE_TASK_ID]}" --p Var1_Pval --N-col Num_NonMissing --snp Var1_ID --signed-sumstats Var1_beta,0 --merge-alleles ../1000G.EAS.QC.snplist
ldsc.py --h2 out/res_"${PHE[$SGE_TASK_ID]}".sumstats.gz --ref-ld-chr ../eas_ldscores/ --w-ld-chr ../eas_ldscores/ --out out/result_"${PHE[$SGE_TASK_ID]}"

