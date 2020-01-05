#!/bin/bash
#$ -N dis_convert
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=2:00:00
#$ -t 1-65

PHE=(dummy marital smoking_2 alcohol_heavy HTN_diagnosis DM_diagnosis Dyslipid_diagnosis metabolic_syndrome Renal_stone liver_hemangioma cholecystitis GB_stone GB_adenomyomatosis IPMN GB_polyp brain_UBO brain_SVD brain_atherosclerosis brain_stenosis brain_aneurysmm brain_atrophy breast_cancer coronary_stenosis aorta_dilatation coronary_plaque DEXA_bone_density spine_spondylosis spine_spondylolisthesis spine_compression_fracture spine_disc_narrowing EKG_axis EKG_sinusbradycardia EKG_RBBB EKG_1DAVB EKG_infarct EKG_ischemia cataract drusen macular_change optic_disc_cupping optic_fiber_loss gastric_cancer atrophic_gastritic intestinal_metaplasia duodenal_ulcer gastric_ulcer GERD urine_PU_cat HBV HCV PFT_categoric thyroid_cancer education SOL WASO Depressed_mood Appetite_change_increase cognitive_funx guilt_feeling suicidal loss_of_interest fatigue retardation agitation fatty_liver_4grade0_123 daily_coffee01_23)

python ../convert_plato_output.py ../../../discrete/ out result_"${PHE[$SGE_TASK_ID]}" 
