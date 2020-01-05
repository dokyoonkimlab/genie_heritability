#!/bin/bash
#$ -N ica_convert
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=2:00:00
#$ -t 1-78

PHE=(dummy CA19_9_1 CALCIUM_1 MCHC_1 BUN_1 GOT_1 Na_1 ALP_1 GPT_1 GFR_1 MPV_1 WC_1 GGT_1 MCH_1 TSH_1 PSA_1 CREATININE_1 serum_albumin_1 WBC_1 HDL_1 RDW_1 SEG_NEUT._1 Inbody_Fat_percent_1 glucose_1 serum_protein_1 aPTT_1 alcohol_heavy_1 PCT_1 TG_1 visceral_fat_CT_mm2_1 BASOPHIL_1 MCV_1 URIC_ACID_1 Inbody_Body_fat_mass_1 CL_1 HB_1 HTN_diagnosis_1 PHOSPHORUS_1 PLT_1 daily_coffee01_23_1 HBA1C_1 HCT_1 LYMPHOCYTE_1 RBC_1 Weight_1 Total_chol_1 BMI_1 fatty_liver_4grade0_123_1 Inbody_skeletal_muscle_mass_1 PT_1 AFP_1 CEA_1 depression_score_1 DM_diagnosis_1 serum_total_bil_1 FEV1_L_1 EOSINOPHIL_1 FVC_L_1 MONOCYTE_1 Height_1 FEV1_FVC_percent_1 VitD3_1 total_fat_CT_mm2_1 FEV1_percent_1 FVC_percent_1 TCO2_1 exercise_continuous_1 Dyslipid_diagnosis_1 metabolic_syndrome_1 LDL_chol_1 EKG_rate_1 atrophic_gastritic_1 intestinal_metaplasia_1 DEXA_bone_density_1 K_1 cognitive_funx_1 free_T4_1 HBV_1 HBV_4)

python ../convert_plato_output.py ../../../ICA out result_${PHE[$SGE_TASK_ID]}

