#!/bin/bash
#$ -N cont_convert
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=2:00:00
#$ -t 1-74

PHE=(dummy total_fat_CT_mm2 visceral_fat_CT_mm2 SBP DBP Height Weight BMI Inbody_skeletal_muscle_mass Inbody_Body_fat_mass Inbody_Fat_percent WC glucose TG HDL HBA1C exercise_continuous cal_score_cont EKG_rate WBC PLT SEG_NEUT. LYMPHOCYTE MONOCYTE EOSINOPHIL BASOPHIL RBC HB CALCIUM PHOSPHORUS BUN URIC_ACID CREATININE Na K CL TCO2 GFR free_T4 TSH CA125 CA19_9 AFP CEA PSA VitD3 Total_chol serum_protein serum_albumin serum_total_bil ALP GOT GPT GGT LDL_chol MCV MCH MCHC PCT MPV PT aPTT HCT RDW IOP_rt IOP_left FVC_L FVC_percent FEV1_L FEV1_percent FEV1_FVC_percent nocturia_frequency depression_score urine_PH)

python ../convert_plato_output.py ../../../continous out result_${PHE[$SGE_TASK_ID]}

