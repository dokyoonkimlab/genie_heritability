#!/bin/bash
#$ -N d_ldsc
#$ -cwd
#$ -l h_vmem=16G
#$ -l h_rt=12:00:00
#$ -t 1-65

source /cbica/projects/kimlab/software_dir/modules/common/Anaconda-3.7/etc/profile.d/conda.sh
conda activate ldsc
module load ldsc/1.0.1
mkdir out

PHE=(dummy marital smoking_2 alcohol_heavy HTN_diagnosis DM_diagnosis Dyslipid_diagnosis metabolic_syndrome Renal_stone liver_hemangioma cholecystitis GB_stone GB_adenomyomatosis IPMN GB_polyp brain_UBO brain_SVD brain_atherosclerosis brain_stenosis brain_aneurysmm brain_atrophy breast_cancer coronary_stenosis aorta_dilatation coronary_plaque DEXA_bone_density spine_spondylosis spine_spondylolisthesis spine_compression_fracture spine_disc_narrowing EKG_axis EKG_sinusbradycardia EKG_RBBB EKG_1DAVB EKG_infarct EKG_ischemia cataract drusen macular_change optic_disc_cupping optic_fiber_loss gastric_cancer atrophic_gastritic intestinal_metaplasia duodenal_ulcer gastric_ulcer GERD urine_PU_cat HBV HCV PFT_categoric thyroid_cancer education SOL WASO Depressed_mood Appetite_change_increase cognitive_funx guilt_feeling suicidal loss_of_interest fatigue retardation agitation fatty_liver_4grade0_123 daily_coffee01_23)

munge_sumstats.py --sumstats ../convert_plato_output/discrete/out/result_"${PHE[$SGE_TASK_ID]}" --out out/res_"${PHE[$SGE_TASK_ID]}" --p Var1_Pval --N-col Num_NonMissing --snp Var1_ID --signed-sumstats Var1_beta,0 --merge-alleles ../1000G.EAS.QC.snplist
ldsc.py --h2 out/res_"${PHE[$SGE_TASK_ID]}".sumstats.gz --ref-ld-chr ../eas_ldscores/ --w-ld-chr ../eas_ldscores/ --out out/result_"${PHE[$SGE_TASK_ID]}"
