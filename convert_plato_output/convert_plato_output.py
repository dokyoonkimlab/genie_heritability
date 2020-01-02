import sys
import os
import gzip

input_dir = sys.argv[1]
output_dir = sys.argv[2]
sge_index_phe = sys.argv[3]
rsq_imputation_file = "/cbica/projects/kimlab_hpeace/projects/genie_phewas/QC/imputed/association1/plato/genie_heritability/rsq_score"
bim_file = "/cbica/projects/kimlab_hpeace/projects/genie_phewas/QC/imputed/5_hwe/merged_chr1-23_maf0.01_rsq0.7_addrmsnps.bim"
bim_file_1000g = "/cbica/projects/kimlab_hpeace/projects/genie_phewas/QC/imputed/association1/plato/genie_heritability/1000G.EAS.QC.all.bim"

CHANGE_IDS_USING_BIM = True

def flip_alleles(alleles):
	s = ""
	for a in alleles:
		if a == 'A':
			s += 'T'
		elif a == 'T':
			s += 'A'
		elif a == 'G':
			s += 'C'
		elif a == 'C':
			s += 'G'
	return s

def get_phe_name(result_file):
	with open(result_file) as rf:
		next(rf)
		line = next(rf)
		line = line.strip()
		parts = line.split('\t')
		return(parts[0])

snp_rsid_map = {}
with open(bim_file_1000g) as bmg:
	for line in bmg:
		line = line.strip()
		parts = line.split('\t')
		snpid = parts[0] + ':' + parts[3] + ':' + parts[4] + ':' + parts[5]
		snp_rsid_map[snpid] = parts[1]
		snpid = parts[0] + ':' + parts[3] + ':' + flip_alleles(parts[4]) + ':' + flip_alleles(parts[5])
		snp_rsid_map[snpid] = parts[1]
		snpid = parts[0] + ':' + parts[3] + ':' + parts[5] + ':' + parts[4]
		snp_rsid_map[snpid] = parts[1]
		snpid = parts[0] + ':' + parts[3] + ':' + flip_alleles(parts[5]) + ':' + flip_alleles(parts[4])
		snp_rsid_map[snpid] = parts[1]

if not os.path.exists(output_dir):
	os.mkdir(output_dir)

snp_pos_map = {}
with open(bim_file) as bf:
	for line in bf:
		line = line.strip()
		parts = line.split('\t')
		snp_pos_map[parts[1]] = parts[0] + ':' + parts[3] + ':' + parts[4] + ':' + parts[5]


snp_rsq_map = {}
with open(rsq_imputation_file) as rf:
	next(rf)
	for line in rf:
		line = line.strip()
		parts = line.split('\t')
		if parts[1] == "Imputed" or parts[1] == "IMPUTED":
			snp_rsq_map[parts[0]] = parts[2]
		else:
			snp_rsq_map[parts[0]] = "Genotyped"

pval_index = None
beta_index = None
num_cases_index = -1
d = sge_index_phe

print("input_dir:" + input_dir)
print("phe_file:" + d)
if os.path.isdir(os.path.join(input_dir, d)):
	in_file = os.path.join(input_dir, d, "output.txt")
	with open(in_file) as inf, open(os.path.join(output_dir, d), 'w') as of:
		print("Writing to file : " + os.path.join(output_dir, d))
		header = next(inf)
		header = header.strip()
		header = header.split('\t')
		pval_index = header.index("Var1_Pval")
		beta_index = header.index("Var1_beta")
		if "Num_Cases" in header:
			num_cases_index = header.index("Num_Cases")
		if num_cases_index:
			of.write(header[0] + '\t' + header[1] + "\tchr" + "\tpos" + "\ta1" + "\ta2" + '\t' + header[3] + '\t' + header[4] + '\t' + header[pval_index] + '\t' + header[beta_index] + "\trsq\t" + header[num_cases_index] + '\n')
		else:
			of.write(header[0] + '\t' + header[1] + "\tchr" + "\tpos" + "\ta1" + "\ta2" + '\t' + header[3] + '\t' + header[4] + '\t' + header[pval_index] + '\t' + header[beta_index] + "\trsq\n")
		for line in inf:
			line = line.strip()
			parts = line.split('\t')
			chr_pos_alleles = snp_pos_map[parts[1]].split(':')
			alleles = set([chr_pos_alleles[2], chr_pos_alleles[3]])
			var1_allele = parts[3].split(':')
			alleles.remove(var1_allele[0])
			if parts[1] not in snp_rsq_map:
				snp_rsq_map[parts[1]] = "Genotyped"
			snpid = parts[1]
			if CHANGE_IDS_USING_BIM and parts[1] in snp_rsid_map:
				snpid = snp_rsid_map[parts[1]]
			if num_cases_index == -1:
				of.write(parts[0] + '\t' + snpid + '\t' + chr_pos_alleles[0] + '\t' + chr_pos_alleles[1] + '\t' + var1_allele[0] + '\t' + alleles.pop() + '\t' + var1_allele[1] + '\t' + parts[4] + '\t' + parts[pval_index] + '\t' + parts[beta_index] + '\t' + snp_rsq_map[parts[1]] + '\n')
			else:
				of.write(parts[0] + '\t' + snpid + '\t' + chr_pos_alleles[0] + '\t' + chr_pos_alleles[1] + '\t' + var1_allele[0] + '\t' + alleles.pop() + '\t' + var1_allele[1] + '\t' + parts[4] + '\t' + parts[pval_index] + '\t' + parts[beta_index] + '\t' + snp_rsq_map[parts[1]] + '\t' + parts[num_cases_index] + '\n')
			

