#!/bin/bash
#$ -N ldsc
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=1:00:00
#$ -t 1-1

source /cbica/projects/kimlab/software_dir/modules/common/Anaconda-3.7/etc/profile.d/conda.sh
conda activate ldsc
module load ldsc/1.0.1
mkdir out

PHE=(dummy CA19_9_1 TSH_1 CALCIUM_1 MCHC_1 PSA_1 Na_1 MPV_1 urine_PH_1 GOT_1 BUN_1 GPT_1 MCH_1 PCT_1 GGT_1 CA125_1 GFR_1 CREATININE_1 ALP_1 BASOPHIL_1 WC_1 serum_albumin_1 Inbody_Fat_percent_1 MCV_1 RDW_1 glucose_1 HDL_1 HB_1 URIC_ACID_1 PHOSPHORUS_1 metabolic_syndrome_1 PT_1 Inbody_Body_fat_mass_1 SEG_NEUT._1 TG_1 IOP_rt_1 serum_protein_1 PLT_1 CL_1 WBC_1 HBA1C_1 alcohol_heavy_1 aPTT_1 IOP_left_1 HTN_diagnosis_1 HCT_1 depression_score_1 visceral_fat_CT_mm2_1 BMI_1 fatty_liver_4grade0_123_1 AFP_1 RBC_1 LYMPHOCYTE_1 Weight_1 DM_diagnosis_1 education_1 cal_score_cont_1 CEA_1 FVC_L_1 daily_coffee01_23_1 FEV1_L_1 Total_chol_1 EOSINOPHIL_1 Inbody_skeletal_muscle_mass_1 HBV_1 cognitive_funx_1 MONOCYTE_1 Height_1 serum_total_bil_1 TCO2_1 loss_of_interest_1 suicidal_1 cataract_1 optic_disc_cupping_1 Depressed_mood_1 EKG_axis_1 EKG_ischemia_1 agitation_1 FVC_percent_1 exercise_continuous_1 FEV1_FVC_percent_1 atrophic_gastritic_1 gastric_cancer_1 Dyslipid_diagnosis_1 EKG_rate_1 spine_spondylosis_1 urine_PU_cat_1 retardation_1 VitD3_1 intestinal_metaplasia_1 gastric_ulcer_1 spine_compression_fracture_1 SOL_1 total_fat_CT_mm2_1 optic_fiber_loss_1 PFT_categoric_1 FEV1_percent_1 EKG_infarct_1 brain_SVD_1 HCV_1 aorta_dilatation_1 DEXA_bone_density_1 GB_stone_1 thyroid_cancer_1 drusen_1 fatigue_1 GERD_1 GB_polyp_1 macular_change_1 liver_hemangioma_1 EKG_sinusbradycardia_1 cholecystitis_1 spine_spondylolisthesis_1 guilt_feeling_1 spine_disc_narrowing_1 free_T4_1 coronary_stenosis_1 LDL_chol_1 K_1 brain_atrophy_1 duodenal_ulcer_1 WASO_1 breast_cancer_1 brain_atherosclerosis_1 EKG_1DAVB_1 smoking_2_1 Appetite_change_increase_1 GB_adenomyomatosis_1 brain_stenosis_1 IPMN_1 nocturia_frequency_1 Renal_stone_1 brain_aneurysmm_1 EKG_RBBB_1 coronary_plaque_1 brain_UBO_1)

munge_sumstats_nobeta_median_check.py --sumstats ../convert_plato_output/PCA/out/result_"${PHE[$SGE_TASK_ID]}" --out out/res_"${PHE[$SGE_TASK_ID]}" --p Var1_Pval --N-col Num_NonMissing --snp Var1_ID --signed-sumstats Var1_beta,0 --merge-alleles ../1000G.EAS.QC.snplist
ldsc.py --h2 out/res_"${PHE[$SGE_TASK_ID]}".sumstats.gz --ref-ld-chr ../eas_ldscores/ --w-ld-chr ../eas_ldscores/ --out out/result_"${PHE[$SGE_TASK_ID]}"

